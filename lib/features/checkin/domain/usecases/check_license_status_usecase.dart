import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';

class CheckLicenseStatusUseCase {
  const CheckLicenseStatusUseCase(this._repository);

  final CheckinRepository _repository;

  Future<Result<LicenseStatusEntity>> call() => _repository.getLicenseStatus();
}
