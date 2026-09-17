import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rental_car/features/auth/domain/entities/auth_tokens.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Result<UserEntity>> completeProfile({required String fullName}) {
    // TODO: implement completeProfile
    throw UnimplementedError();
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Result<AuthTokens>> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> sendOtp({required String email}) {
    // TODO: implement sendOtp
    throw UnimplementedError();
  }

  @override
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
  }) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}
