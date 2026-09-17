import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository _repository;

  const CompleteProfileUseCase(this._repository);

  Future<Result<UserEntity>> call({required String fullName}) {
    return _repository.completeProfile(fullName: fullName.trim());
  }
}
