import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/google_auth_service.dart';
import 'package:rental_car/features/auth/data/models/auth_tokens_model.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';
import 'package:rental_car/features/auth/domain/entities/auth_tokens.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final GoogleAuthService _googleAuthService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    GoogleAuthService? googleAuthService,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _googleAuthService = googleAuthService ?? GoogleAuthServiceImpl();

  @override
  Future<Result<UserEntity>> completeProfile({required String fullName}) {
    return safeCall(() async {
      final userModel = await _remoteDataSource.completeProfile(
        fullName: fullName,
      );
      await _localDataSource.saveUser(userModel);
      return userModel.toEntity();
    });
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() {
    return safeCall(() async {
      final cachedUser = await _localDataSource.getUser();
      if (cachedUser != null) {
        return cachedUser.toEntity();
      }

      final accessToken = await _localDataSource.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        final user = await _remoteDataSource.getCurrentUser();
        await _localDataSource.saveUser(user);
        return user.toEntity();
      }

      return null;
    });
  }

  @override
  Future<Result<void>> logout() {
    return safeCall(() async {
      try {
        await _remoteDataSource.logout();
      } finally {
        await _googleAuthService.signOut();
        await _localDataSource.clearTokens();
        await _localDataSource.clearUser();
      }
    });
  }

  @override
  Future<Result<AuthTokens>> refreshToken() {
    return safeCall(() async {
      final oldRefreshToken = await _localDataSource.getRefreshToken();
      if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
        throw const ServerException(message: 'Không tìm thấy refresh token.');
      }

      final tokens = await _remoteDataSource.refreshToken(
        refreshToken: oldRefreshToken,
      );
      await _localDataSource.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken ?? oldRefreshToken,
      );

      return tokens.toEntity();
    });
  }

  @override
  Future<Result<void>> sendOtp({required String email}) {
    return safeCall(() => _remoteDataSource.sendOtp(email: email));
  }

  @override
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return safeCall(() async {
      final tokens = await _remoteDataSource.verifyOtp(email: email, otp: otp);

      await _localDataSource.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      final userModel = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(userModel);

      return userModel.toEntity();
    });
  }

  @override
  Future<Result<void>> setProfileSetupSkipped(String email) {
    return safeCall(() => _localDataSource.setProfileSetupSkipped(email));
  }

  @override
  Future<Result<bool>> isProfileSetupSkipped(String email) {
    return safeCall(() => _localDataSource.isProfileSetupSkipped(email));
  }

  @override
  Future<Result<UserEntity>> signInWithGoogle() {
    return safeCall(() async {
      final auth = await _googleAuthService.signIn();
      if (auth == null) {
        throw const ServerException(message: 'Đăng nhập Google đã bị hủy.');
      }

      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const ServerException(
          message: 'Không lấy được ID Token từ Google.',
        );
      }

      final tokens = await _remoteDataSource.loginWithGoogle(idToken: idToken);

      await _localDataSource.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      final userModel = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(userModel);

      return userModel.toEntity();
    });
  }
}
