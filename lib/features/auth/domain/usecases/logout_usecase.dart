import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Result<void>> call() {
    return _repository.logout();
  }
}
