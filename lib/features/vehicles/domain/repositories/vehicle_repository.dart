import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/paginated_vehicles.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';

abstract interface class VehicleRepository {
  Future<Result<List<VehicleEntity>>> getVehicles({VehicleFilter? filter});
  Future<Result<List<VehicleEntity>>> getHomeVehicles();
  Future<Result<VehicleEntity>> getVehicleDetail(String id);
  Future<Result<List<String>>> getVehicleBrands();
  Future<Result<List<String>>> getVehicleCategories();

  /// Lấy bảng phí booking từ BE
  Future<Result<BookingFeeBreakdown>> getBookingFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Lấy lịch bận của xe
  Future<Result<List<VehicleScheduleSlot>>> getVehicleSchedule(int vehicleId);

  /// Lấy danh sách xe có phân trang
  Future<Result<PaginatedVehicles>> getVehiclesPaginated({
    VehicleFilter? filter,
    int page = 1,
    int limit = 20,
  });
}
