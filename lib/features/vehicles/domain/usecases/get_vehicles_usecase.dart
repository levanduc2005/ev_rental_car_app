import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  const GetVehiclesUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<List<VehicleEntity>>> call([VehicleFilter? filter]) {
    return _repository.getVehicles(filter: filter);
  }
}
