import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/paginated_vehicles.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehiclesPaginatedUseCase {
  const GetVehiclesPaginatedUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<PaginatedVehicles>> call({
    VehicleFilter? filter,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getVehiclesPaginated(
      filter: filter,
      page: page,
      limit: limit,
    );
  }
}
