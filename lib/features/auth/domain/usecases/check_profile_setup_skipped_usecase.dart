import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class CheckProfileSetupSkippedUseCase {
  final AuthRepository _repository;

  const CheckProfileSetupSkippedUseCase(this._repository);

  Future<Result<bool>> call(String email) {
    return _repository.isProfileSetupSkipped(email.trim().toLowerCase());
  }
}
