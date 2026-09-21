import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rental_car/core/config/app_config.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';

class AuthInterceptor extends QueuedInterceptor {
  final AuthLocalDataSource _localDataSource;
  final Dio _dio;
  final void Function()? onSessionExpired;

  AuthInterceptor({
    required AuthLocalDataSource localDataSource,
    required Dio dio,
    this.onSessionExpired,
  }) : _localDataSource = localDataSource,
       _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = options.extra['isPublic'] as bool? ?? false;
    if (isPublic) {
      return handler.next(options);
    }

    final token = await _localDataSource.getAccessToken();
    debugPrint('🔑 [SecureStore] AccessToken: $token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final isPublic = err.requestOptions.extra['isPublic'] as bool? ?? false;
    if (response?.statusCode == 401 && !isPublic) {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _clearSession();
        return handler.next(err);
      }

      try {
        // Tạo một Dio riêng để gọi refresh (tránh lặp vào Interceptor)
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(
              milliseconds: AppConfig.apiTimeoutMs,
            ),
            receiveTimeout: const Duration(
              milliseconds: AppConfig.apiTimeoutMs,
            ),
          ),
        );
        // Gọi api lấy token mới
        final response = await refreshDio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
          options: Options(extra: {'isPublic': true}),
        );

        final data = response.data?['data'] as Map<String, dynamic>?;
        final accessToken = data?['token'] as String?;
        final newRefreshToken =
            data?['refreshToken'] as String? ?? refreshToken;

        if (accessToken != null && accessToken.isNotEmpty) {
          // Lưu token mới vào SecureStorage
          await _localDataSource.saveTokens(
            accessToken: accessToken,
            refreshToken: newRefreshToken,
          );
        }

        // Cập nhật token mới vào request cũ và GỬI LẠI (Retry)
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $accessToken';
        return handler.resolve(await _dio.fetch(requestOptions));
      } catch (e) {
        // Refresh thất bại (refreshToken cũng hết hạn) ➔ Xóa session
        await _clearSession();
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  Future<void> _clearSession() async {
    await _localDataSource.clearTokens();
    await _localDataSource.clearUser();
    onSessionExpired?.call();
  }
}
