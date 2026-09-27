import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

/// Trạng thái form đặt xe e-Motion (nhận và trả tại chi nhánh của xe).
class BookingFormState {
  const BookingFormState({
    this.vehicle,
    required this.startDateTime,
    required this.endDateTime,
    this.feeBreakdown,
    this.isCalculatingFee = false,
    this.isCreatingReservation = false,
    this.errorMessage,
    this.createdReservation,
    this.payosPaymentInfo,
  });

  final VehicleBookingSummary? vehicle;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final BookingFeeEntity? feeBreakdown;
  final bool isCalculatingFee;
  final bool isCreatingReservation;
  final String? errorMessage;
  final ReservationEntity? createdReservation;
  final PayOSPaymentInfoEntity? payosPaymentInfo;

  /// Địa chỉ chi nhánh nhận xe (lấy theo trạm của xe)
  String get pickupAddress =>
      vehicle?.stationAddress ?? vehicle?.stationName ?? 'Chi nhánh e-Motion';

  /// Địa chỉ chi nhánh trả xe (trả tại cùng chi nhánh nhận xe)
  String get returnAddress => pickupAddress;

  /// Tên chi nhánh nhận xe
  String get stationName => vehicle?.stationName ?? 'Chi nhánh e-Motion';

  /// Tổng số giờ thuê xe
  int get rentalHours {
    final diff = endDateTime.difference(startDateTime);
    return diff.inHours > 0 ? diff.inHours : 4;
  }

  /// Tổng tiền thuê xe dự tính từ API biểu phí hoặc gói theo giờ
  int get estimatedTotalRent =>
      feeBreakdown?.totalCost ?? (vehicle?.price4h ?? 0);

  BookingFormState copyWith({
    VehicleBookingSummary? vehicle,
    DateTime? startDateTime,
    DateTime? endDateTime,
    BookingFeeEntity? feeBreakdown,
    bool? isCalculatingFee,
    bool? isCreatingReservation,
    String? errorMessage,
    ReservationEntity? createdReservation,
    PayOSPaymentInfoEntity? payosPaymentInfo,
    bool clearError = false,
  }) {
    return BookingFormState(
      vehicle: vehicle ?? this.vehicle,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      feeBreakdown: feeBreakdown ?? this.feeBreakdown,
      isCalculatingFee: isCalculatingFee ?? this.isCalculatingFee,
      isCreatingReservation:
          isCreatingReservation ?? this.isCreatingReservation,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdReservation: createdReservation ?? this.createdReservation,
      payosPaymentInfo: payosPaymentInfo ?? this.payosPaymentInfo,
    );
  }
}
