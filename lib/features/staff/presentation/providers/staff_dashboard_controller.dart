import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/utils/app_logger.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_rentals_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_reservations_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_checklists_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_profile_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_station_vehicles_usecase.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

enum StaffBottomTab {
  reservations, // Đặt trước
  rentals, // Đơn thuê
  scanner, // Quét mã / Chụp ảnh
  checklists, // Biên bản
  vehicles, // Xe trạm
}

/// Backwards compatibility alias
typedef StaffTab = StaffBottomTab;

class StaffDashboardState {
  const StaffDashboardState({
    this.isLoading = false,
    this.isSearching = false,
    this.isLoadingChecklists = false,
    this.isLoadingVehicles = false,
    this.errorMessage,
    this.staffProfile,
    this.selectedTab = StaffBottomTab.reservations,
    this.searchQuery = '',
    this.reservations = const [],
    this.rentals = const [],
    this.searchResults = const [],
    this.checklists = const [],
    this.vehicles = const [],
    this.checklistFilterType,
  });

  final bool isLoading;
  final bool isSearching;
  final bool isLoadingChecklists;
  final bool isLoadingVehicles;
  final String? errorMessage;
  final StaffProfileEntity? staffProfile;
  final StaffBottomTab selectedTab;
  final String searchQuery;

  final List<ReservationEntity> reservations;
  final List<RentalDetailEntity> rentals;
  final List<ReservationEntity> searchResults;
  final List<RentalChecklistEntity> checklists;
  final List<VehicleEntity> vehicles;
  final String? checklistFilterType;

  StaffStationEntity? get currentStation => staffProfile?.station;

  StaffDashboardState copyWith({
    bool? isLoading,
    bool? isSearching,
    bool? isLoadingChecklists,
    bool? isLoadingVehicles,
    String? Function()? errorMessage,
    StaffProfileEntity? staffProfile,
    StaffBottomTab? selectedTab,
    String? searchQuery,
    List<ReservationEntity>? reservations,
    List<RentalDetailEntity>? rentals,
    List<ReservationEntity>? searchResults,
    List<RentalChecklistEntity>? checklists,
    List<VehicleEntity>? vehicles,
    String? Function()? checklistFilterType,
  }) {
    return StaffDashboardState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isLoadingChecklists: isLoadingChecklists ?? this.isLoadingChecklists,
      isLoadingVehicles: isLoadingVehicles ?? this.isLoadingVehicles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      staffProfile: staffProfile ?? this.staffProfile,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      reservations: reservations ?? this.reservations,
      rentals: rentals ?? this.rentals,
      searchResults: searchResults ?? this.searchResults,
      checklists: checklists ?? this.checklists,
      vehicles: vehicles ?? this.vehicles,
      checklistFilterType: checklistFilterType != null
          ? checklistFilterType()
          : this.checklistFilterType,
    );
  }
}

class StaffDashboardController extends Notifier<StaffDashboardState> {
  GetStaffProfileUseCase? _injectedGetStaffProfileUseCase;
  FilterStaffReservationsUseCase? _injectedFilterStaffReservationsUseCase;
  FilterStaffRentalsUseCase? _injectedFilterStaffRentalsUseCase;
  GetStaffChecklistsUseCase? _injectedGetStaffChecklistsUseCase;
  GetStationVehiclesUseCase? _injectedGetStationVehiclesUseCase;

  GetStaffProfileUseCase get _getStaffProfileUseCase =>
      _injectedGetStaffProfileUseCase ??
      ref.read(getStaffProfileUseCaseProvider);

  FilterStaffReservationsUseCase get _filterStaffReservationsUseCase =>
      _injectedFilterStaffReservationsUseCase ??
      ref.read(filterStaffReservationsUseCaseProvider);

  FilterStaffRentalsUseCase get _filterStaffRentalsUseCase =>
      _injectedFilterStaffRentalsUseCase ??
      ref.read(filterStaffRentalsUseCaseProvider);

  GetStaffChecklistsUseCase get _getStaffChecklistsUseCase =>
      _injectedGetStaffChecklistsUseCase ??
      ref.read(getStaffChecklistsUseCaseProvider);

  GetStationVehiclesUseCase get _getStationVehiclesUseCase =>
      _injectedGetStationVehiclesUseCase ??
      ref.read(getStationVehiclesUseCaseProvider);

  void injectDependencies({
    GetStaffProfileUseCase? getStaffProfileUseCase,
    FilterStaffReservationsUseCase? filterStaffReservationsUseCase,
    FilterStaffRentalsUseCase? filterStaffRentalsUseCase,
    GetStaffChecklistsUseCase? getStaffChecklistsUseCase,
    GetStationVehiclesUseCase? getStationVehiclesUseCase,
  }) {
    _injectedGetStaffProfileUseCase = getStaffProfileUseCase;
    _injectedFilterStaffReservationsUseCase = filterStaffReservationsUseCase;
    _injectedFilterStaffRentalsUseCase = filterStaffRentalsUseCase;
    _injectedGetStaffChecklistsUseCase = getStaffChecklistsUseCase;
    _injectedGetStationVehiclesUseCase = getStationVehiclesUseCase;
  }

  @override
  StaffDashboardState build() => const StaffDashboardState();

  Future<void> init() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    // 1. Lấy thông tin trạm và nhân viên
    final profileRes = await _getStaffProfileUseCase();
    profileRes.when(
      ok: (profile) => state = state.copyWith(staffProfile: profile),
      err: (failure) => state = state.copyWith(
        errorMessage: () =>
            'Không thể tải thông tin nhân viên: ${failure.message}',
      ),
    );

    // 2. Tải danh sách đơn đặt, đơn thuê, biên bản và xe
    await refreshData();

    state = state.copyWith(isLoading: false);
  }

  Future<void> refreshData() async {
    // Tải reservations: lấy danh sách đơn đặt tại trạm của nhân viên (bao gồm cả đơn đã hoàn thành)
    final resResult = await _filterStaffReservationsUseCase(limit: 50);
    resResult.when(
      ok: (items) {
        state = state.copyWith(reservations: items);
      },
      err: (failure) =>
          AppLogger.instance.w('Lỗi tải reservations: ${failure.message}'),
    );

    // Tải rentals: lấy tất cả đơn thuê tại trạm của nhân viên
    final rentalResult = await _filterStaffRentalsUseCase(limit: 50);
    rentalResult.when(
      ok: (items) => state = state.copyWith(rentals: items),
      err: (failure) =>
          AppLogger.instance.w('Lỗi tải rentals: ${failure.message}'),
    );

    // Tải checklists
    await fetchChecklists();

    // Tải xe trạm
    await fetchStationVehicles();
  }

  void switchTab(StaffBottomTab tab) {
    state = state.copyWith(selectedTab: tab);
    if (tab == StaffBottomTab.checklists && state.checklists.isEmpty) {
      fetchChecklists();
    } else if (tab == StaffBottomTab.vehicles && state.vehicles.isEmpty) {
      fetchStationVehicles();
    }
  }

  Future<void> fetchChecklists({String? keyword, String? type}) async {
    state = state.copyWith(
      isLoadingChecklists: true,
      checklistFilterType: () => type,
    );

    final result = await _getStaffChecklistsUseCase(
      keyword: keyword,
      type: type,
    );

    result.when(
      ok: (items) =>
          state = state.copyWith(checklists: items, isLoadingChecklists: false),
      err: (failure) {
        AppLogger.instance.w('Lỗi tải checklists: ${failure.message}');
        state = state.copyWith(isLoadingChecklists: false);
      },
    );
  }

  Future<void> fetchStationVehicles() async {
    state = state.copyWith(isLoadingVehicles: true);
    final stationId = state.currentStation?.id ?? 0;

    final result = await _getStationVehiclesUseCase(stationId);
    result.when(
      ok: (items) =>
          state = state.copyWith(vehicles: items, isLoadingVehicles: false),
      err: (failure) {
        AppLogger.instance.w('Lỗi tải vehicles: ${failure.message}');
        state = state.copyWith(isLoadingVehicles: false);
      },
    );
  }

  Future<void> search(String query) async {
    final clean = query.trim();
    if (clean.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        isSearching: false,
        searchResults: const [],
      );
      return;
    }

    state = state.copyWith(
      searchQuery: clean,
      isSearching: true,
      errorMessage: () => null,
    );

    final result = await _filterStaffReservationsUseCase(
      search: clean,
      limit: 10,
    );

    result.when(
      ok: (items) {
        state = state.copyWith(isSearching: false, searchResults: items);
      },
      err: (failure) {
        state = state.copyWith(
          isSearching: false,
          errorMessage: () => failure.message,
        );
      },
    );
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      isSearching: false,
      searchResults: const [],
    );
  }
}
