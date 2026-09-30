import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/home/data/datasources/home_remote_data_source.dart';
import 'package:rental_car/features/home/data/repositories/home_repository_impl.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';
import 'package:rental_car/features/home/domain/usecases/get_stations_by_city_usecase.dart';
import 'package:rental_car/features/home/presentation/providers/home_controller.dart';
import 'package:rental_car/features/home/presentation/providers/home_state.dart';
import 'package:rental_car/features/vehicles/domain/entities/station_entity.dart';

// --- Data Layer Providers ---
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    remoteDataSource: ref.watch(homeRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final getStationsByCityUseCaseProvider = Provider<GetStationsByCityUseCase>((
  ref,
) {
  return GetStationsByCityUseCase(
    repository: ref.watch(homeRepositoryProvider),
  );
});

/// Provider lấy danh sách trạm theo tên thành phố (vd: 'Hà Nội', 'Hồ Chí Minh')
final stationsByCityProvider =
    FutureProvider.family<List<StationEntity>, String>((ref, city) async {
      final useCase = ref.watch(getStationsByCityUseCaseProvider);
      final result = await useCase(city);
      return result.when(
        ok: (stations) => stations,
        err: (failure) => const <StationEntity>[],
      );
    });

// --- Presentation Layer Controller Provider ---
final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);
