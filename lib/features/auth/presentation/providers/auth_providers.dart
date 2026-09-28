import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rental_car/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:rental_car/features/auth/domain/usecases/check_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/set_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/verify_otp_usecase.dart';

// --- Data Layer Providers ---
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStore = ref.watch(secureStoreProvider);
  final keyValueStore = ref.watch(keyValueStoreProvider);

  return AuthLocalDataSourceImpl(
    secureStore: secureStore,
    keyValueStore: keyValueStore,
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// --- Domain Layer UseCase Providers ---
final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  return SendOtpUseCase(ref.watch(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
});

final completeProfileUseCaseProvider = Provider<CompleteProfileUseCase>((ref) {
  return CompleteProfileUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final checkProfileSetupSkippedUseCaseProvider =
    Provider<CheckProfileSetupSkippedUseCase>((ref) {
      return CheckProfileSetupSkippedUseCase(ref.watch(authRepositoryProvider));
    });

final setProfileSetupSkippedUseCaseProvider =
    Provider<SetProfileSetupSkippedUseCase>((ref) {
      return SetProfileSetupSkippedUseCase(ref.watch(authRepositoryProvider));
    });
