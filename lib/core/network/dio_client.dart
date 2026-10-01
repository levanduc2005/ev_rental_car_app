import 'package:dio/dio.dart';
import 'package:rental_car/core/config/app_config.dart';
import 'package:rental_car/core/network/logging_interceptor.dart';

/// Builds a configured [Dio] instance for the app.
///
/// Centralizing Dio construction keeps timeouts, base URL, headers and
/// interceptors consistent, and makes the client trivial to override in
/// tests (see `test/` for examples that inject a mock adapter).
abstract final class DioClient {
  static Dio create({List<Interceptor>? interceptors}) {
    const rawBaseUrl = AppConfig.apiBaseUrl;
    final baseUrl = rawBaseUrl.endsWith('/') ? rawBaseUrl : '$rawBaseUrl/';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: AppConfig.apiTimeoutMs),
        receiveTimeout: const Duration(milliseconds: AppConfig.apiTimeoutMs),
        sendTimeout: const Duration(milliseconds: AppConfig.apiTimeoutMs),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Let us handle non-2xx responses ourselves instead of throwing
        // opaque DioExceptions for every status code.
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Strip leading slash if path is relative so it doesn't overwrite baseUrl's subpath.
          if (!options.path.startsWith('http://') &&
              !options.path.startsWith('https://') &&
              options.path.startsWith('/')) {
            options.path = options.path.substring(1);
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.addAll([
      ...?interceptors,
      if (AppConfig.enableLogging) LoggingInterceptor(),
    ]);

    return dio;
  }
}
