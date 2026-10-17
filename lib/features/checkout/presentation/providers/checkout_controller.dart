import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_checklists_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_rental_overview_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/process_checkout_payment_usecase.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_providers.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

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

class CheckoutController extends Notifier<CheckoutState> {
  GetRentalOverviewUseCase get _getRentalOverviewUseCase =>
      ref.read(getRentalOverviewUseCaseProvider);

  ProcessCheckoutPaymentUseCase get _processCheckoutPaymentUseCase =>
      ref.read(processCheckoutPaymentUseCaseProvider);

  GetChecklistsByRentalIdUseCase get _getChecklistsByRentalIdUseCase =>
      ref.read(getChecklistsByRentalIdUseCaseProvider);

  @override
  CheckoutState build() {
    return const CheckoutState();
  }

  /// Khởi tạo dữ liệu trả xe cho chuyến đi
  Future<void> initialize(
    int rentalId, {
    int? vehicleId,
    int? staffId,
    String? stationName,
    String? stationAddress,
    double? stationLat,
    double? stationLng,
  }) async {
    state = state.copyWith(
      rentalId: rentalId,
      vehicleId: vehicleId,
      staffId: staffId,
      stationName: stationName,
      stationAddress: stationAddress,
      stationLatitude: stationLat,
      stationLongitude: stationLng,
      isLoading: true,
      clearError: true,
    );

    // Tải bảng kê tài chính và biên bản nhận xe từ UseCases
    await Future.wait([loadRentalOverview(rentalId), loadChecklists(rentalId)]);

    // Sau khi nạp thông tin trạm thực tế từ backend, thực hiện xác thực tọa độ GPS
    await verifyLocation();

    state = state.copyWith(isLoading: false);
  }

  /// Xác thực vị trí trả xe GPS Geofencing (<= 100m)
  Future<void> verifyLocation() async {
    state = state.copyWith(isLocationChecking: true, clearLocationError: true);

    try {
      final targetLat = state.stationLatitude;
      final targetLng = state.stationLongitude;

      if (targetLat == null || targetLng == null) {
        state = state.copyWith(
          isLocationChecking: false,
          locationError: 'Chưa có thông tin tọa độ trạm trả xe quy định.',
        );
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLocationChecking: false,
          locationError:
              'Dịch vụ định vị GPS trên thiết bị đang tắt. Vui lòng bật vị trí để tiếp tục.',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isLocationChecking: false,
            locationError:
                'Ứng dụng chưa được cấp quyền vị trí. Vui lòng cho phép truy cập để xác thực.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isLocationChecking: false,
          locationError:
              'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng mở Cài đặt thiết bị để cấp quyền.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );

      state = state.copyWith(
        isLocationChecking: false,
        currentLatitude: position.latitude,
        currentLongitude: position.longitude,
        distanceInMeters: distance,
      );
    } catch (e) {
      String friendlyMessage;
      final errorStr = e.toString().toLowerCase();

      if (errorStr.contains('missingpluginexception')) {
        friendlyMessage =
            'Chưa kết nối được dịch vụ GPS của thiết bị. Vui lòng kiểm tra quyền vị trí trên máy.';
      } else if (errorStr.contains('locationservicedisabled') ||
          errorStr.contains('service is disabled')) {
        friendlyMessage =
            'Dịch vụ định vị GPS trên thiết bị đang tắt. Vui lòng bật vị trí trong cài đặt thiết bị.';
      } else if (errorStr.contains('permission')) {
        friendlyMessage =
            'Ứng dụng chưa được cấp quyền truy cập vị trí. Vui lòng cấp quyền trong cài đặt thiết bị.';
      } else if (errorStr.contains('timeout')) {
        friendlyMessage =
            'Không thể nhận tín hiệu GPS sau 10 giây. Vui lòng thử lại tại khu vực thoáng hơn.';
      } else {
        friendlyMessage =
            'Không thể xác định vị trí hiện tại. Vui lòng kiểm tra định vị GPS và thử lại.';
      }

      state = state.copyWith(
        isLocationChecking: false,
        locationError: friendlyMessage,
      );
    }
  }

  /// Lấy biên bản nhận xe CHECK_IN qua UseCase
  Future<void> loadChecklists(int rentalId) async {
    final result = await _getChecklistsByRentalIdUseCase(rentalId);

    result.when(
      ok: (checklists) {
        final checkIn = checklists.where((c) => c.isCheckIn).firstOrNull;
        state = state.copyWith(checkInChecklist: checkIn);
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  /// Tải bảng kê tài chính quyết toán qua UseCase
  Future<void> loadRentalOverview([int? overrideRentalId]) async {
    final rentalId = overrideRentalId ?? state.rentalId;
    if (rentalId == null) return;

    if (overrideRentalId != null && state.rentalId != overrideRentalId) {
      state = state.copyWith(rentalId: overrideRentalId);
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getRentalOverviewUseCase(rentalId);

    result.when(
      ok: (overview) {
        state = state.copyWith(
          overview: overview,
          isLoading: false,
          stationName: state.stationName ?? overview.stationName,
          stationAddress: state.stationAddress ?? overview.stationAddress,
          stationLatitude: state.stationLatitude ?? overview.stationLatitude,
          stationLongitude: state.stationLongitude ?? overview.stationLongitude,
          damageItems: overview.vehicleDamages,
          damagePhotos: overview.vehicleDamageImages,
          isVehicleDamaged:
              overview.vehicleDamageFee > 0 ||
              overview.vehicleDamages.isNotEmpty,
        );
      },
      err: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  /// Xác nhận trả xe và quyết toán cọc qua UseCase
  Future<bool> confirmCheckoutAndSettle() async {
    final rentalId = state.rentalId;
    if (rentalId == null) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    final result = await _processCheckoutPaymentUseCase(rentalId);

    return result.when(
      ok: (data) {
        final paymentUrl = data['paymentUrl'] as String?;
        state = state.copyWith(
          isSubmitting: false,
          isCheckoutCompleted: true,
          paymentUrl: paymentUrl,
          successMessage: 'Quyết toán trả xe thành công!',
        );
        ref.invalidate(rentalHistoryControllerProvider);
        ref.invalidate(myReservationsControllerProvider);
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);
