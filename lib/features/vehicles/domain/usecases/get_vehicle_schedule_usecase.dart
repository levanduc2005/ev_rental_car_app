import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehicleScheduleUseCase {
  const GetVehicleScheduleUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<List<VehicleScheduleSlot>>> call(int vehicleId) {
    return _repository.getVehicleSchedule(vehicleId);
  }
}
