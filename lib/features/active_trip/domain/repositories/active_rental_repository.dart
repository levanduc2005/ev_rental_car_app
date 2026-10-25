import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';

abstract interface class ActiveRentalRepository {
  /// Lấy chi tiết đơn thuê xe theo ID (GET /api/rentals/me/details/{id})
  Future<Result<ActiveRentalEntity>> getActiveRentalDetail(int rentalId);

  /// Lấy đơn thuê xe đang hoạt động (IN_PROGRESS) của người dùng hiện tại
  Future<Result<ActiveRentalEntity?>> getCurrentActiveRental({
    required String email,
  });

  /// Lấy danh sách lịch bận của xe (GET /api/vehicles/{vehicleId}/schedule)
  Future<Result<List<VehicleScheduleEntity>>> getVehicleSchedule(int vehicleId);

  /// Xem trước phí gia hạn từ BE (POST /api/rentals/{rentalId}/preview-extend)
  Future<Result<ExtendRentalPreviewEntity>> previewExtendRental({
    required int rentalId,
    required DateTime newReturnTime,
  });

  /// Gia hạn thời gian trả xe (POST /api/rentals/{rentalId}/extend)
  Future<Result<ExtendRentalResultEntity>> extendRental({
    required int rentalId,
    required DateTime newReturnTime,
  });

  /// Kiểm tra và xác nhận thanh toán gia hạn chuyến đi (POST /api/payment/payos/check/rental/{rentalId})
  Future<Result<bool>> checkExtendPayment(int rentalId);
}
