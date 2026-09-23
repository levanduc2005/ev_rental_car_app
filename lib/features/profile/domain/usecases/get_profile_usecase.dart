import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfileEntity>> call() => _repository.getProfile();
}
