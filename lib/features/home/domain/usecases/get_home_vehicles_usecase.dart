import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';

class GetHomeVehiclesUseCase {
  const GetHomeVehiclesUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<List<VehicleEntity>>> call() {
    return _repository.getHomeVehicles();
  }
}
