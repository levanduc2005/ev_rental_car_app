import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

abstract interface class StaffRepository {
  /// Lấy thông tin cá nhân của nhân viên, staffId và trạm được phân công
  Future<Result<StaffProfileEntity>> getStaffProfile();

  /// Tra cứu thông tin người thuê qua email
  Future<Result<RenterEntity>> getRenterByEmail(String email);

  /// Tạo hợp đồng thuê xe trực tiếp tại trạm (Walk-in)
  Future<Result<RentalDetailEntity>> createRental({
    required DateTime startTime,
    required DateTime endTime,
    required int vehicleId,
    required String email,
    required int staffId,
  });

  /// Lọc danh sách đơn đặt xe (Reservations) tại trạm
  Future<Result<List<ReservationEntity>>> filterReservations({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  });

  /// Lọc danh sách đơn thuê xe thực tế (Rentals) tại trạm
  Future<Result<List<RentalDetailEntity>>> filterRentals({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  });

  /// Chuyển đổi Reservation sang Rental mới khi khách đến nhận xe
  Future<Result<RentalDetailEntity>> convertReservationToRental({
    required String reservationCode,
    required int staffId,
  });

  /// Tạo hợp đồng điện tử DocuSeal cho Rental
  Future<Result<String>> generateContract(int rentalId);

  /// Lấy URL thanh toán Check-in qua cổng VNPay
  Future<Result<String>> getCheckInPaymentUrl({
    required int rentalId,
    int point = 0,
  });

  /// Cập nhật trạng thái đơn thuê (Ví dụ: Chuyển sang CONFIRM khi thu tiền mặt)
  Future<Result<void>> updateRentalStatus({
    required int rentalId,
    required String status,
  });

  /// Lập biên bản nhận xe (Check-in Checklist) và bàn giao xe (kích hoạt ONGOING)
  Future<Result<RentalChecklistEntity>> submitCheckInChecklist({
    required int rentalId,
    required String staffEmail,
    required int currentBattery,
    required String img,
  });

  /// Lấy danh sách biên bản kiểm tra xe (Check-in / Check-out)
  Future<Result<List<RentalChecklistEntity>>> getChecklists({
    String? keyword,
    String? type,
  });

  /// Lấy danh sách xe thuộc trạm
  Future<Result<List<VehicleEntity>>> getStationVehicles(int stationId);

  /// Hủy đơn thuê xe và hoàn trả xe về trạng thái sẵn sàng
  Future<Result<bool>> cancelRental(int rentalId);
}
