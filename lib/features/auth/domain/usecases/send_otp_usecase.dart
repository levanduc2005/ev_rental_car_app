import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  const SendOtpUseCase(this._repository);

  Future<Result<void>> call({required String email}) {
    return _repository.sendOtp(email: email.trim().toLowerCase());
  }
}
