import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_form_state.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';

/// Controller quản lý luồng chọn thời gian, tính giá và đặt xe.
class BookingFormController extends Notifier<BookingFormState> {
  late final BookingRepository _repository;

  @override
  BookingFormState build() {
    _repository = ref.watch(bookingRepositoryProvider);

    // Tính thời gian mặc định tuân theo luật của Spring Boot Backend:
    // 1. Phút bắt buộc là :00
    // 2. Giờ nhận xe phải sau hiện tại ít nhất 3 tiếng
    // 3. Thời lượng tối thiểu 4 tiếng
    final now = DateTime.now();
    final defaultStart = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 4, // Đảm bảo an toàn > 3 tiếng
    );
    final defaultEnd = defaultStart.add(const Duration(hours: 4));

    return BookingFormState(
      startDateTime: defaultStart,
      endDateTime: defaultEnd,
    );
  }

  /// Khởi tạo thông tin xe và kích hoạt gọi API tính phí thật ngay lập tức
  void initVehicle(VehicleBookingSummary vehicle) {
    if (state.vehicle?.id == vehicle.id && state.feeBreakdown != null) {
      return;
    }
    state = state.copyWith(vehicle: vehicle, clearError: true);
    calculateFee();
  }

  /// Nạp thông tin xe qua vehicleId nếu chuyển trang trực tiếp
  Future<void> loadVehicleById(int vehicleId) async {
    state = state.copyWith(isCalculatingFee: true, clearError: true);
    final result = await _repository.getVehicleDetail(vehicleId);
    result.when(
      ok: (VehicleBookingSummary summary) {
        state = state.copyWith(vehicle: summary, isCalculatingFee: false);
        calculateFee();
      },
      err: (failure) {
        state = state.copyWith(
          isCalculatingFee: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Cập nhật thời gian nhận và trả xe
  void updateRentalSchedule(DateTime start, DateTime end) {
    final now = DateTime.now();
    // Validate luật Backend
    if (start.minute != 0 || end.minute != 0) {
      state = state.copyWith(
        errorMessage:
            'Thời gian nhận và trả xe phải đúng giờ tròn (ví dụ 14:00)',
      );
      return;
    }
    if (start.isBefore(now.add(const Duration(hours: 3)))) {
      state = state.copyWith(
        errorMessage:
            'Thời gian nhận xe phải sau thời điểm hiện tại ít nhất 3 tiếng',
      );
      return;
    }
    if (end.difference(start).inHours < 4) {
      state = state.copyWith(
        errorMessage: 'Thời gian thuê xe tối thiểu là 4 tiếng',
      );
      return;
    }

    state = state.copyWith(
      startDateTime: start,
      endDateTime: end,
      clearError: true,
    );
    calculateFee();
  }

  /// Gọi API Spring Boot backend để tính phí thật cho xe
  Future<void> calculateFee() async {
    final vehicle = state.vehicle;
    if (vehicle == null) return;

    state = state.copyWith(isCalculatingFee: true, clearError: true);

    final result = await _repository.calculateFees(
      vehicleId: vehicle.id,
      startTime: state.startDateTime,
      endTime: state.endDateTime,
    );

    result.when(
      ok: (fee) {
        state = state.copyWith(feeBreakdown: fee, isCalculatingFee: false);
      },
      err: (failure) {
        state = state.copyWith(
          isCalculatingFee: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Gửi yêu cầu đặt xe chính thức qua API POST /api/reservations
  Future<ReservationEntity?> submitReservation({String? note}) async {
    final vehicle = state.vehicle;
    if (vehicle == null) {
      state = state.copyWith(errorMessage: 'Vui lòng chọn thông tin xe trước.');
      return null;
    }

    state = state.copyWith(isCreatingReservation: true, clearError: true);

    final currentUser = ref.read(authControllerProvider).user;
    if (currentUser == null || currentUser.email.isEmpty) {
      state = state.copyWith(
        isCreatingReservation: false,
        errorMessage:
            'Vui lòng đăng nhập tài khoản trước khi thực hiện đặt xe.',
      );
      return null;
    }
    final userEmail = currentUser.email;

    final result = await _repository.createReservation(
      userEmail: userEmail,
      vehicleId: vehicle.id,
      stationId: vehicle.stationId ?? 1,
      startTime: state.startDateTime,
      endTime: state.endDateTime,
    );

    return result.when(
      ok: (rawReservation) {
        final reservation = rawReservation.copyWith(
          vehicle: rawReservation.vehicle ?? state.vehicle,
          totalRentAmount:
              rawReservation.totalRentAmount ?? state.feeBreakdown?.totalAmount,
        );

        state = state.copyWith(
          isCreatingReservation: false,
          createdReservation: reservation,
          payosPaymentInfo: reservation.paymentInfo,
        );

        // Nếu response chưa kèm paymentInfo, tự động gọi tạo link PayOS cho đơn
        if (reservation.paymentInfo == null && reservation.id > 0) {
          fetchPayOSPaymentLink(reservation.id);
        }

        return reservation;
      },
      err: (failure) {
        state = state.copyWith(
          isCreatingReservation: false,
          errorMessage: failure.message,
        );
        return null;
      },
    );
  }

  /// Gán đơn đặt xe sẵn có để tiếp tục thanh toán PayOS
  Future<void> setPaymentReservation(ReservationEntity reservation) async {
    state = state.copyWith(
      createdReservation: reservation,
      payosPaymentInfo: reservation.paymentInfo,
    );

    if (reservation.paymentInfo == null && reservation.id > 0) {
      await fetchPayOSPaymentLink(reservation.id);
    }
  }

  /// Lấy thông tin thanh toán động trực tiếp từ PayOS thông qua backend
  Future<void> fetchPayOSPaymentLink(int reservationId) async {
    final result = await _repository.createPayOSPaymentLink(reservationId);
    result.when(
      ok: (payos) {
        state = state.copyWith(payosPaymentInfo: payos);
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }
}

/// Provider của BookingFormController
final bookingFormControllerProvider =
    NotifierProvider<BookingFormController, BookingFormState>(
      BookingFormController.new,
    );
