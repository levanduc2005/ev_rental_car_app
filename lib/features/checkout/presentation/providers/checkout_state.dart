import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';

class CheckoutState {
  const CheckoutState({
    this.rentalId,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
    this.checkInChecklist,
    this.checkOutChecklist,
    this.overview,
    this.stationName,
    this.stationAddress,
    this.currentLatitude,
    this.currentLongitude,
    this.stationLatitude,
    this.stationLongitude,
    this.distanceInMeters,
    this.isLocationChecking = false,
    this.locationError,
    this.vehicleId,
    this.staffId,
    this.vehicleLog,
    this.damageItems = const [],
    this.damagePhotos = const [],
    this.isVehicleDamaged = false,
    this.isCheckoutCompleted = false,
    this.paymentUrl,
  });

  final int? rentalId;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  // Dữ liệu biên bản
  final RentalChecklistEntity? checkInChecklist;
  final RentalChecklistEntity? checkOutChecklist;
  final RentalOverviewEntity? overview;

  // Trạm trả xe & Định vị Geofence
  final String? stationName;
  final String? stationAddress;
  final double? currentLatitude;
  final double? currentLongitude;
  final double? stationLatitude;
  final double? stationLongitude;
  final double? distanceInMeters;
  final bool isLocationChecking;
  final String? locationError;

  bool get isLocationValid =>
      distanceInMeters != null && distanceInMeters! <= 100.0;


  // Thông tin xe & Nhân viên
  final int? vehicleId;
  final int? staffId;

  // Biên bản nhật ký xe & Hư hại (VehicleLog)
  final VehicleLogEntity? vehicleLog;
  final List<VehicleDamageItemEntity> damageItems;
  final List<String> damagePhotos;
  final bool isVehicleDamaged;

  double get totalDamageCost =>
      damageItems.fold(0.0, (acc, item) => acc + item.cost);

  // Kết quả thanh toán
  final bool isCheckoutCompleted;
  final String? paymentUrl;

  CheckoutState copyWith({
    int? rentalId,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
    RentalChecklistEntity? checkInChecklist,
    RentalChecklistEntity? checkOutChecklist,
    RentalOverviewEntity? overview,
    String? stationName,
    String? stationAddress,
    double? currentLatitude,
    double? currentLongitude,
    double? stationLatitude,
    double? stationLongitude,
    double? distanceInMeters,
    bool? isLocationChecking,
    String? locationError,
    int? vehicleId,
    int? staffId,
    VehicleLogEntity? vehicleLog,
    List<VehicleDamageItemEntity>? damageItems,
    List<String>? damagePhotos,
    bool? isVehicleDamaged,
    bool? isCheckoutCompleted,
    String? paymentUrl,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearLocationError = false,
  }) {
    return CheckoutState(
      rentalId: rentalId ?? this.rentalId,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      checkInChecklist: checkInChecklist ?? this.checkInChecklist,
      checkOutChecklist: checkOutChecklist ?? this.checkOutChecklist,
      overview: overview ?? this.overview,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      stationLatitude: stationLatitude ?? this.stationLatitude,
      stationLongitude: stationLongitude ?? this.stationLongitude,
      distanceInMeters: distanceInMeters ?? this.distanceInMeters,
      isLocationChecking: isLocationChecking ?? this.isLocationChecking,
      locationError: clearLocationError
          ? null
          : (locationError ?? this.locationError),
      vehicleId: vehicleId ?? this.vehicleId,
      staffId: staffId ?? this.staffId,
      vehicleLog: vehicleLog ?? this.vehicleLog,
      damageItems: damageItems ?? this.damageItems,
      damagePhotos: damagePhotos ?? this.damagePhotos,
      isVehicleDamaged: isVehicleDamaged ?? this.isVehicleDamaged,
      isCheckoutCompleted: isCheckoutCompleted ?? this.isCheckoutCompleted,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }
}
