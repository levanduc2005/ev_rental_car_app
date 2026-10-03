import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

abstract interface class BookingRepository {
  /// Tính toán biểu phí thuê xe qua API /api/vehicles/booking
  Future<Result<BookingFeeEntity>> calculateFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
    bool rental = false,
  });

  /// Tạo đơn đặt giữ chỗ qua API /api/reservations
  Future<Result<ReservationEntity>> createReservation({
    required String userEmail,
    required int vehicleId,
    required int stationId,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Lấy danh sách các đơn đặt xe của người dùng qua API /api/reservations/email
  Future<Result<List<ReservationEntity>>> getMyReservations({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 20,
    String search = '',
  });

  /// Lấy chi tiết đơn đặt xe theo ID qua API /api/reservations/me/{id}
  Future<Result<ReservationEntity>> getReservationDetail(int reservationId);

  /// Hủy đơn đặt giữ chỗ qua API /api/reservations/{code}/cancel
  Future<Result<bool>> cancelReservation({
    required String code,
    String? reason,
  });

  /// Lấy thông tin xe thật từ backend qua API /api/vehicles/id/{id} (Không mock data)
  Future<Result<VehicleBookingSummary>> getVehicleDetail(int vehicleId);

  /// Xác nhận thanh toán đặt cọc qua cổng PayOS thật (POST /api/payment/payos/confirm/{reservationCode})
  Future<Result<bool>> confirmPayOSPayment(String reservationCode);

  /// Tạo hoặc lấy liên kết thanh toán PayOS VietQR động từ backend (POST /api/payment/payos/create-link/{reservationId})
  Future<Result<PayOSPaymentInfoEntity>> createPayOSPaymentLink(
    int reservationId,
  );

  /// Lấy danh sách các ứng dụng ngân hàng hỗ trợ VietQR động từ API
  Future<Result<List<BankAppItem>>> getSupportedBanks();
}
