import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';
import 'package:rental_car/features/active_trip/data/repositories/active_rental_repository_impl.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_active_rental_detail_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_current_active_rental_use_case.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';

// --- Data Layer Providers ---
final activeRentalRemoteDataSourceProvider =
    Provider<ActiveRentalRemoteDataSource>((ref) {
      return ActiveRentalRemoteDataSourceImpl(dio: ref.watch(dioProvider));
    });

final activeRentalRepositoryProvider = Provider<ActiveRentalRepository>((ref) {
  return ActiveRentalRepositoryImpl(
    remoteDataSource: ref.watch(activeRentalRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final getActiveRentalDetailUseCaseProvider =
    Provider<GetActiveRentalDetailUseCase>((ref) {
      return GetActiveRentalDetailUseCase(
        repository: ref.watch(activeRentalRepositoryProvider),
      );
    });

final getCurrentActiveRentalUseCaseProvider =
    Provider<GetCurrentActiveRentalUseCase>((ref) {
      return GetCurrentActiveRentalUseCase(
        repository: ref.watch(activeRentalRepositoryProvider),
      );
    });

// --- Controller Providers for Presentation ---
/// Provider lấy chi tiết đơn thuê theo rentalId
final activeRentalDetailControllerProvider =
    FutureProvider.family<ActiveRentalEntity, int>((ref, rentalId) async {
      final useCase = ref.watch(getActiveRentalDetailUseCaseProvider);
      final result = await useCase(rentalId);
      return result.when(
        ok: (data) => data,
        err: (failure) => throw failure,
      );
    });

/// Provider tự động lấy chuyến xe đang chạy của user hiện tại
final currentActiveRentalControllerProvider =
    FutureProvider<ActiveRentalEntity?>((ref) async {
      final user = ref.watch(authControllerProvider).user;
      if (user == null || user.email.isEmpty) return null;

      final useCase = ref.watch(getCurrentActiveRentalUseCaseProvider);
      final result = await useCase(email: user.email);
      return result.when(
        ok: (data) => data,
        err: (failure) => throw failure,
      );
    });
