import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehicleBrandsUseCase {
  const GetVehicleBrandsUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<List<String>>> call() {
    return _repository.getVehicleBrands();
  }
}
