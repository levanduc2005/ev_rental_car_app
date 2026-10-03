import 'package:rental_car/features/booking/data/models/booking_fee_model.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/booking/data/models/vehicle_booking_summary_model.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';

abstract interface class BookingRemoteDataSource {
  /// Gọi POST /api/vehicles/booking để tính biểu phí thuê xe từ backend
  Future<BookingFeeModel> calculateBookingFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
    bool rental = false,
  });

  /// Gọi POST /api/reservations để tạo đơn đặt giữ chỗ
  Future<ReservationModel> createReservation(
    CreateReservationRequestModel request,
  );

  /// Gọi POST /api/reservations/email để lấy danh sách đơn của người dùng
  Future<List<ReservationModel>> getMyReservations({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 20,
    String search = '',
  });

  /// Gọi GET /api/reservations/me/{id} để lấy chi tiết đơn đặt chỗ
  Future<ReservationModel> getReservationDetail(int reservationId);

  /// Gọi POST /api/reservations/{code}/cancel để hủy đơn đặt xe
  Future<bool> cancelReservation(String code, {String? reason});

  /// Gọi GET /api/vehicles/id/{id} để lấy thông tin chi tiết xe từ backend (Không mock data)
  Future<VehicleBookingSummaryModel> getVehicleDetail(int vehicleId);

  /// Gọi POST /api/payment/payos/confirm/{reservationCode} để xác nhận thanh toán PayOS thật
  Future<bool> confirmPayOSPayment(String reservationCode);

  /// Gọi POST /api/payment/payos/create-link/{reservationId} để tạo/lấy link thanh toán PayOS động từ backend
  Future<PayOSPaymentInfoModel> createPayOSPaymentLink(int reservationId);

  /// Lấy danh sách các ngân hàng Việt Nam động từ VietQR API
  Future<List<BankAppItem>> getSupportedBanks();
}
