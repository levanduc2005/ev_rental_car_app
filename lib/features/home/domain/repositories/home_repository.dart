import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';
import 'package:rental_car/features/home/domain/entities/vehicle_entity.dart';

abstract interface class HomeRepository {
  /// Lấy danh sách 16 xe nổi bật dành cho trang chủ
  Future<Result<List<VehicleEntity>>> getHomeVehicles();

  /// Lấy danh sách tất cả các hãng xe trong hệ thống
  Future<Result<List<String>>> getVehicleBrands();

  /// Lấy danh sách trạm xe theo tên thành phố
  Future<Result<List<StationEntity>>> getStationsByCity(String city);
}
