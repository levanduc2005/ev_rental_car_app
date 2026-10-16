import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
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
