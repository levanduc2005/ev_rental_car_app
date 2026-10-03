import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/presentation/providers/home_state.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_home_vehicles_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_brands_usecase.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';

class HomeController extends Notifier<HomeState> {
  GetHomeVehiclesUseCase get _getHomeVehiclesUseCase =>
      ref.read(getHomeVehiclesUseCaseProvider);
  GetVehicleBrandsUseCase get _getVehicleBrandsUseCase =>
      ref.read(getVehicleBrandsUseCaseProvider);

  @override
  HomeState build() {
    Future.microtask(loadHomeData);

    return const HomeState(isLoading: true);
  }

  /// Tải dữ liệu ban đầu cho trang chủ (xe nổi bật + danh sách hãng xe)
  Future<void> loadHomeData() => _fetchHomeData(isRefresh: false);

  /// Kéo để làm mới dữ liệu trang chủ (Pull-to-refresh)
  Future<void> refresh() => _fetchHomeData(isRefresh: true);

  Future<void> _fetchHomeData({required bool isRefresh}) async {
    state = isRefresh
        ? state.copyWith(isRefreshing: true, errorMessage: null)
        : state.copyWith(isLoading: true, errorMessage: null);

    final results = await Future.wait([
      _getHomeVehiclesUseCase(),
      _getVehicleBrandsUseCase(),
    ]);

    final vehiclesResult = results[0] as Result<List<VehicleEntity>>;
    final brandsResult = results[1] as Result<List<String>>;

    final vehicles = vehiclesResult.when(
      ok: (v) => v,
      err: (_) => state.vehicles,
    );
    final brands = brandsResult.when(ok: (b) => b, err: (_) => state.brands);
    final error = vehiclesResult.when(ok: (_) => null, err: (f) => f.message);

    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      vehicles: vehicles,
      brands: brands,
      errorMessage: error,
    );
  }

  /// Chọn / Bỏ chọn lọc theo hãng xe
  void selectBrand(String? brand) {
    if (state.selectedBrand == brand) {
      state = state.copyWith(selectedBrand: null);
    } else {
      state = state.copyWith(selectedBrand: brand);
    }
  }
}
