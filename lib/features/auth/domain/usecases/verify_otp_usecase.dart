import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String otp,
  }) {
    return _repository.verifyOtp(email: email.trim().toLowerCase(), otp: otp);
  }
}
