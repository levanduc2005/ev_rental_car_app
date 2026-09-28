import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class SetProfileSetupSkippedUseCase {
  final AuthRepository _repository;

  const SetProfileSetupSkippedUseCase(this._repository);

  Future<Result<void>> call(String email) {
    return _repository.setProfileSetupSkipped(email.trim().toLowerCase());
  }
}
