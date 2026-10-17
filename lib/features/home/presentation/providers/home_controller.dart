import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_home_vehicles_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_brands_usecase.dart';
import 'package:rental_car/features/vehicles/presentation/providers/vehicle_providers.dart';

class HomeState {
  const HomeState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.vehicles = const [],
    this.brands = const [],
    this.selectedBrand,
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final List<VehicleEntity> vehicles;
  final List<String> brands;
  final String? selectedBrand;

  static const Object _sentinel = Object();

  HomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    Object? errorMessage = _sentinel,
    List<VehicleEntity>? vehicles,
    List<String>? brands,
    Object? selectedBrand = _sentinel,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      vehicles: vehicles ?? this.vehicles,
      brands: brands ?? this.brands,
      selectedBrand: identical(selectedBrand, _sentinel)
          ? this.selectedBrand
          : selectedBrand as String?,
    );
  }

  /// Danh sách xe sang / xế xịn
  List<VehicleEntity> get luxuryVehicles {
    var list = vehicles.where((v) => v.isLuxury).toList();
    if (list.isEmpty && vehicles.isNotEmpty && selectedBrand == null) {
      final sorted = List<VehicleEntity>.from(vehicles)
        ..sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
      list = sorted.take(3).toList();
    }
    if (selectedBrand != null) {
      list = list
          .where((v) => v.brand.toUpperCase() == selectedBrand!.toUpperCase())
          .toList();
    }
    return list;
  }

  /// Danh sách xe phổ thông / xe điện gợi ý
  List<VehicleEntity> get recommendedVehicles {
    var list = vehicles.where((v) => !v.isLuxury).toList();
    if (list.isEmpty) list = vehicles;
    if (selectedBrand != null) {
      list = list
          .where((v) => v.brand.toUpperCase() == selectedBrand!.toUpperCase())
          .toList();
    }
    return list;
  }

  /// Kiểm tra có dữ liệu để hiển thị hay không
  bool get hasData => vehicles.isNotEmpty;
}

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
