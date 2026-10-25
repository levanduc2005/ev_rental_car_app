import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class GetVehicleScheduleUseCase {
  const GetVehicleScheduleUseCase({required ActiveRentalRepository repository})
    : _repository = repository;

  final ActiveRentalRepository _repository;

  Future<Result<List<VehicleScheduleEntity>>> call(int vehicleId) {
    return _repository.getVehicleSchedule(vehicleId);
  }
}
