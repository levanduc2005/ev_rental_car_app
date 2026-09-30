import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/station_entity.dart';

abstract interface class HomeRepository {
  /// Lấy danh sách trạm xe theo tên thành phố
  Future<Result<List<StationEntity>>> getStationsByCity(String city);
}
