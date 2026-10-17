import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class GetStationVehiclesUseCase {
  const GetStationVehiclesUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<List<VehicleEntity>>> call(int stationId) {
    return _repository.getStationVehicles(stationId);
  }
}
