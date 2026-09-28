import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehicleDetailUseCase {
  const GetVehicleDetailUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<VehicleEntity>> call(String id) {
    return _repository.getVehicleDetail(id);
  }
}
