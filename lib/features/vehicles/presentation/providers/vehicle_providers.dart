import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:rental_car/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_detail_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/search_vehicles_filter_usecase.dart';

final vehicleRemoteDataSourceProvider = Provider<VehicleRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return VehicleRemoteDataSourceImpl(dio: dio);
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final remoteDataSource = ref.watch(vehicleRemoteDataSourceProvider);
  return VehicleRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetVehiclesUseCase(repository);
});

final searchVehiclesFilterUseCaseProvider =
    Provider<SearchVehiclesFilterUseCase>((ref) {
      final repository = ref.watch(vehicleRepositoryProvider);
      return SearchVehiclesFilterUseCase(repository);
    });

final getVehicleDetailUseCaseProvider = Provider<GetVehicleDetailUseCase>((
  ref,
) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetVehicleDetailUseCase(repository);
});

/// Quản lý trạng thái bộ lọc xe
final vehicleFilterProvider =
    NotifierProvider<VehicleFilterNotifier, VehicleFilter>(
      VehicleFilterNotifier.new,
    );

class VehicleFilterNotifier extends Notifier<VehicleFilter> {
  @override
  VehicleFilter build() => const VehicleFilter();

  void updateFilter(VehicleFilter filter) {
    state = filter;
  }

  void reset() {
    state = const VehicleFilter();
  }
}

/// Controller lấy danh sách xe phản ứng theo filter
final vehicleListControllerProvider = FutureProvider<List<VehicleEntity>>((
  ref,
) async {
  final filter = ref.watch(vehicleFilterProvider);
  final useCase = ref.watch(getVehiclesUseCaseProvider);
  final result = await useCase(filter);
  return result.when(
    ok: (list) => list,
    err: (failure) => throw Exception(failure.message),
  );
});

/// Controller lấy chi tiết xe theo id
final vehicleDetailControllerProvider =
    FutureProvider.family<VehicleEntity, String>((ref, id) async {
      final useCase = ref.watch(getVehicleDetailUseCaseProvider);
      final result = await useCase(id);
      return result.when(
        ok: (detail) => detail,
        err: (failure) => throw Exception(failure.message),
      );
    });
