import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';

abstract interface class VehicleRepository {
  Future<Result<List<VehicleEntity>>> getVehicles({VehicleFilter? filter});
  Future<Result<VehicleEntity>> getVehicleDetail(String id);
}
