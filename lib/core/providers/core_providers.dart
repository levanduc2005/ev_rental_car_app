import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/network/auth_interceptor.dart';
import 'package:rental_car/core/network/dio_client.dart';
import 'package:rental_car/core/storage/key_value_store.dart';
import 'package:rental_car/core/storage/secure_store.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_providers.dart';

/// The shared [Dio] HTTP client.
final dioProvider = Provider<Dio>((ref) {
  // Lấy localDataSource để truyền vào interceptor
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  // 1. Tạo instance Dio cơ bản
  final dio = DioClient.create();

  // 2. Tạo AuthInterceptor và truyền chính dio này vào (để retry khi 401)
  final authInterceptor = AuthInterceptor(
    localDataSource: localDataSource,
    dio: dio,
    onSessionExpired: () {
      ref.read(authControllerProvider.notifier).logout();
    },
  );

  // 3. Gắn AuthInterceptor lên đầu danh sách interceptors
  dio.interceptors.insert(0, authInterceptor);

  ref.onDispose(dio.close);
  return dio;
});

final keyValueStoreProvider = Provider<KeyValueStore>((ref) {
  throw UnimplementedError(
    'keyValueStoreProvider must be overridden in main() with '
    'SharedPreferencesStore.create().',
  );
});

/// Encrypted storage for sensitive values (tokens, secrets).
final secureStoreProvider = Provider<SecureStore>(
  (ref) => FlutterSecureStore(),
);
