import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';

class GetVehicleBrandsUseCase {
  const GetVehicleBrandsUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<List<String>>> call() {
    return _repository.getVehicleBrands();
  }
}
