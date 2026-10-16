import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class GetStaffProfileUseCase {
  const GetStaffProfileUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<StaffProfileEntity>> call() => _repository.getStaffProfile();
}
