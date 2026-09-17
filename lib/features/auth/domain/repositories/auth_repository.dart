import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/entities/auth_tokens.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  /// Gửi mã OTP đến email user
  Future<Result<void>> sendOtp({required String email});

  /// Xác thực mã OTP và nhận thông tin User
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Hoàn thiện thông tin cá nhân
  Future<Result<UserEntity>> completeProfile({required String fullName});

  /// Lấy thông tin current user
  Future<Result<UserEntity?>> getCurrentUser();

  /// Đăng xuất, xóa toàn bộ token và phiên làm việc
  Future<Result<void>> logout();

  /// Refresh Access Token
  Future<Result<AuthTokens>> refreshToken();
}
