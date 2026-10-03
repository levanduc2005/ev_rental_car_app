import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:rental_car/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_booking_fees_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_home_vehicles_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_brands_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_detail_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_schedule_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicles_paginated_usecase.dart';
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

final getHomeVehiclesUseCaseProvider = Provider<GetHomeVehiclesUseCase>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetHomeVehiclesUseCase(repository);
});

final getVehicleBrandsUseCaseProvider = Provider<GetVehicleBrandsUseCase>((
  ref,
) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetVehicleBrandsUseCase(repository);
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

final getBookingFeesUseCaseProvider = Provider<GetBookingFeesUseCase>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetBookingFeesUseCase(repository);
});

final getVehicleScheduleUseCaseProvider = Provider<GetVehicleScheduleUseCase>((
  ref,
) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return GetVehicleScheduleUseCase(repository);
});

final getVehiclesPaginatedUseCaseProvider =
    Provider<GetVehiclesPaginatedUseCase>((ref) {
      final repository = ref.watch(vehicleRepositoryProvider);
      return GetVehiclesPaginatedUseCase(repository);
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

/// Controller lấy danh sách xe phản ứng theo filter (tương thích ngược)
final vehicleListControllerProvider = FutureProvider<List<VehicleEntity>>((
  ref,
) async {
  final filter = ref.watch(vehicleFilterProvider);
  final useCase = ref.watch(getVehiclesUseCaseProvider);
  final result = await useCase(filter);
  return result.when(
    ok: (list) {
      var filtered = list;
      if (filter.brand != 'Tất cả' && filter.brand.trim().isNotEmpty) {
        filtered = filtered
            .where(
              (v) => v.brand.toUpperCase() == filter.brand.trim().toUpperCase(),
            )
            .toList();
      }
      if (filter.sort.isEmpty || filter.sort == 'Tất cả') return filtered;
      final sorted = List<VehicleEntity>.from(filtered);
      switch (filter.sort) {
        case 'Giá thấp đến cao':
          sorted.sort((a, b) => a.salePriceK.compareTo(b.salePriceK));
          break;
        case 'Giá cao đến thấp':
          sorted.sort((a, b) => b.salePriceK.compareTo(a.salePriceK));
          break;
        case 'Phổ biến nhất':
          sorted.sort((a, b) => b.viewingCount.compareTo(a.viewingCount));
          break;
        default:
          break;
      }
      return sorted;
    },
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

/// Model tham số tính phí booking từ BE
class BookingFeeParams {
  const BookingFeeParams({
    required this.vehicleId,
    required this.startTime,
    required this.endTime,
  });

  final int vehicleId;
  final DateTime startTime;
  final DateTime endTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingFeeParams &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => Object.hash(vehicleId, startTime, endTime);
}

/// Controller lấy bảng phí booking bóc tách từ BE (POST /vehicles/booking)
final vehicleBookingFeeControllerProvider =
    FutureProvider.family<BookingFeeBreakdown?, BookingFeeParams>((
      ref,
      params,
    ) async {
      final useCase = ref.watch(getBookingFeesUseCaseProvider);
      final result = await useCase(
        vehicleId: params.vehicleId,
        startTime: params.startTime,
        endTime: params.endTime,
      );
      return result.when(ok: (breakdown) => breakdown, err: (_) => null);
    });

/// Controller lấy lịch bận của xe từ BE (GET /vehicles/{id}/schedule)
final vehicleScheduleControllerProvider =
    FutureProvider.family<List<VehicleScheduleSlot>, int>((
      ref,
      vehicleId,
    ) async {
      final useCase = ref.watch(getVehicleScheduleUseCaseProvider);
      final result = await useCase(vehicleId);
      return result.when(ok: (slots) => slots, err: (_) => const []);
    });

/// Trạng thái phân trang danh sách xe
class PaginatedVehicleState {
  const PaginatedVehicleState({
    this.vehicles = const [],
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  final List<VehicleEntity> vehicles;
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get hasMore => currentPage < totalPages;

  PaginatedVehicleState copyWith({
    List<VehicleEntity>? vehicles,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaginatedVehicleState(
      vehicles: vehicles ?? this.vehicles,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier quản lý phân trang và infinite scroll danh sách xe
class PaginatedVehicleNotifier extends Notifier<PaginatedVehicleState> {
  int _currentRequestId = 0;

  @override
  PaginatedVehicleState build() {
    final filter = ref.watch(vehicleFilterProvider);
    Future.microtask(() => loadInitial(filter));
    return const PaginatedVehicleState(isLoading: true);
  }

  Future<void> loadInitial(VehicleFilter filter) async {
    final requestId = ++_currentRequestId;
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(getVehiclesPaginatedUseCaseProvider);
    final result = await useCase(filter: filter, limit: 10);
    if (requestId != _currentRequestId) return;
    result.when(
      ok: (paginated) {
        var vehicles = paginated.vehicles;
        if (filter.brand != 'Tất cả' && filter.brand.trim().isNotEmpty) {
          vehicles = vehicles
              .where(
                (v) =>
                    v.brand.toUpperCase() == filter.brand.trim().toUpperCase(),
              )
              .toList();
        }
        state = PaginatedVehicleState(
          vehicles: _applySort(vehicles, filter.sort),
          currentPage: paginated.currentPage,
          totalPages: paginated.totalPages,
        );
      },
      err: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final requestId = ++_currentRequestId;
    state = state.copyWith(isLoadingMore: true);
    final filter = ref.read(vehicleFilterProvider);
    final useCase = ref.read(getVehiclesPaginatedUseCaseProvider);
    final nextPage = state.currentPage + 1;
    final result = await useCase(filter: filter, page: nextPage, limit: 10);
    if (requestId != _currentRequestId) return;
    result.when(
      ok: (paginated) {
        var newVehicles = paginated.vehicles;
        if (filter.brand != 'Tất cả' && filter.brand.trim().isNotEmpty) {
          newVehicles = newVehicles
              .where(
                (v) =>
                    v.brand.toUpperCase() == filter.brand.trim().toUpperCase(),
              )
              .toList();
        }
        final combined = [...state.vehicles, ...newVehicles];
        state = state.copyWith(
          vehicles: _applySort(combined, filter.sort),
          currentPage: paginated.currentPage,
          totalPages: paginated.totalPages,
          isLoadingMore: false,
        );
      },
      err: (failure) {
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  List<VehicleEntity> _applySort(List<VehicleEntity> list, String sort) {
    if (sort.isEmpty || sort == 'Tất cả') return list;
    final sorted = List<VehicleEntity>.from(list);
    switch (sort) {
      case 'Giá thấp đến cao':
        sorted.sort((a, b) => a.salePriceK.compareTo(b.salePriceK));
        break;
      case 'Giá cao đến thấp':
        sorted.sort((a, b) => b.salePriceK.compareTo(a.salePriceK));
        break;
      case 'Phổ biến nhất':
        sorted.sort((a, b) => b.viewingCount.compareTo(a.viewingCount));
        break;
      default:
        break;
    }
    return sorted;
  }
}

final paginatedVehicleListControllerProvider =
    NotifierProvider<PaginatedVehicleNotifier, PaginatedVehicleState>(
      PaginatedVehicleNotifier.new,
    );
