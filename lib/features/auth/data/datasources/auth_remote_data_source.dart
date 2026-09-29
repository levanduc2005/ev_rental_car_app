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
  Future<AuthTokensModel> loginWithGoogle({required String idToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserModel> completeProfile({required String fullName}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/users/me/update-profile',
        data: {'fullName': fullName},
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    });
  }

  @override
  Future<UserModel> getCurrentUser() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');

      final data = response.data!['data'] as Map<String, dynamic>;
      return UserModel.fromJson(data);
    });
  }

  @override
  Future<void> logout() {
    return guardApiCall(() async {
      await _dio.post<void>('/auth/logout');
    });
  }

  @override
  Future<AuthTokensModel> refreshToken({required String refreshToken}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'isPublic': true}),
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return AuthTokensModel.fromJson(data);
    });
  }

  @override
  Future<void> sendOtp({required String email}) async {
    return guardApiCall(() async {
      await _dio.post<void>(
        '/auth/send-otp',
        data: {'email': email},
        options: Options(extra: {'isPublic': true}),
      );
    });
  }

  @override
  Future<AuthTokensModel> verifyOtp({
    required String email,
    required String otp,
  }) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/verify-otp',
        data: {'email': email, 'verificationCode': otp},
        options: Options(extra: {'isPublic': true}),
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return AuthTokensModel.fromJson(data);
    });
  }

  @override
  Future<AuthTokensModel> loginWithGoogle({required String idToken}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/google',
        data: {'idToken': idToken},
        options: Options(extra: {'isPublic': true}),
      );

      final data = response.data!['data'] as Map<String, dynamic>;
      return AuthTokensModel.fromJson(data);
    });
  }
}
