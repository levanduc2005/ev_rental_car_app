import 'package:dio/dio.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/auth/data/models/auth_tokens_model.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<void> sendOtp({required String email});
  Future<AuthTokensModel> verifyOtp({
    required String email,
    required String otp,
  });
  Future<UserModel> completeProfile({required String fullName});
  Future<UserModel> getCurrentUser();
  Future<void> logout();
  Future<AuthTokensModel> refreshToken({required String refreshToken});
}

class AuthRemoteDataSourceimpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceimpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserModel> completeProfile({required String fullName}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/users/me/update-profile',
        data: {'fullName': fullName},
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    });
  }

  @override
  Future<UserModel> getCurrentUser() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/api/users/me');

      final data = response.data!['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    });
  }

  @override
  Future<void> logout() {
    return guardApiCall(() async {
      await _dio.post<void>('/api/auth/logout');
    });
  }

  @override
  Future<AuthTokensModel> refreshToken({required String refreshToken}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return AuthTokensModel.fromJson(data);
    });
  }

  @override
  Future<void> sendOtp({required String email}) async {
    return guardApiCall(() async {
      await _dio.post<void>('/api/auth/resend', data: {'email': email});
    });
  }

  @override
  Future<AuthTokensModel> verifyOtp({
    required String email,
    required String otp,
  }) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/verify',
        data: {'email': email, 'verificationCode': otp},
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return AuthTokensModel.fromJson(data);
    });
  }
}
