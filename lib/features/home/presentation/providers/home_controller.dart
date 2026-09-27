import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/home/domain/usecases/get_home_vehicles_usecase.dart';
import 'package:rental_car/features/home/domain/usecases/get_vehicle_brands_usecase.dart';
import 'package:rental_car/features/home/presentation/providers/home_providers.dart';
import 'package:rental_car/features/home/presentation/providers/home_state.dart';

class HomeController extends Notifier<HomeState> {
  late final GetHomeVehiclesUseCase _getHomeVehiclesUseCase;
  late final GetVehicleBrandsUseCase _getVehicleBrandsUseCase;

  @override
  HomeState build() {
    _getHomeVehiclesUseCase = ref.watch(getHomeVehiclesUseCaseProvider);
    _getVehicleBrandsUseCase = ref.watch(getVehicleBrandsUseCaseProvider);

    Future.microtask(loadHomeData);

    return const HomeState(isLoading: true);
  }

  /// Tải dữ liệu ban đầu cho trang chủ (xe nổi bật + danh sách hãng xe)
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final vehiclesResult = await _getHomeVehiclesUseCase();
    final brandsResult = await _getVehicleBrandsUseCase();

    final vehicles = vehiclesResult.when(
      ok: (v) => v,
      err: (_) => state.vehicles,
    );
    final brands = brandsResult.when(ok: (b) => b, err: (_) => state.brands);
    final error = vehiclesResult.when(ok: (_) => null, err: (f) => f.message);

    state = state.copyWith(
      isLoading: false,
      vehicles: vehicles,
      brands: brands,
      errorMessage: error,
    );
  }

  /// Kéo để làm mới dữ liệu trang chủ (Pull-to-refresh)
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);

    final vehiclesResult = await _getHomeVehiclesUseCase();
    final brandsResult = await _getVehicleBrandsUseCase();

    final vehicles = vehiclesResult.when(
      ok: (v) => v,
      err: (_) => state.vehicles,
    );
    final brands = brandsResult.when(ok: (b) => b, err: (_) => state.brands);
    final error = vehiclesResult.when(ok: (_) => null, err: (f) => f.message);

    state = state.copyWith(
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
