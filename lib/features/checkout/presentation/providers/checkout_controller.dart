import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/core/utils/app_logger.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_controller.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/usecases/check_rental_compensation_payment_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_checkout_checklist_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_or_update_vehicle_log_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_rental_compensation_payment_link_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_checklists_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_rental_overview_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_vehicle_log_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/process_checkout_payment_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/update_checkout_checklist_usecase.dart';
import 'package:rental_car/features/checkout/presentation/providers/checkout_providers.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_detail_usecase.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/features/staff/domain/usecases/update_rental_status_usecase.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_providers.dart';

class CheckoutState {
  const CheckoutState({
    this.rentalId,
    this.rentalDetail,
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
    this.photos = const [],
    this.isUploadingPhoto = false,
    this.returnBattery,
    this.returnOdometer,
    this.note = '',
    this.payosPaymentInfo,
    bool? isLoadingPayOS,
  }) : _isLoadingPayOS = isLoadingPayOS;

  final int? rentalId;
  final RentalDetailEntity? rentalDetail;
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

  // Form kiểm tra ngoại quan lúc trả xe (Check-out inspection)
  final List<CheckInPhoto> photos;
  final bool isUploadingPhoto;
  final int? returnBattery;
  final int? returnOdometer;
  final String note;
  final PayOSPaymentInfoEntity? payosPaymentInfo;
  final bool? _isLoadingPayOS;
  bool get isLoadingPayOS => _isLoadingPayOS ?? false;

  bool get isInspectionFormValid =>
      returnBattery != null && returnBattery! >= 0 && returnBattery! <= 100;

  CheckoutState copyWith({
    int? rentalId,
    RentalDetailEntity? rentalDetail,
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
    List<CheckInPhoto>? photos,
    bool? isUploadingPhoto,
    int? returnBattery,
    int? returnOdometer,
    String? note,
    PayOSPaymentInfoEntity? payosPaymentInfo,
    bool? isLoadingPayOS,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearLocationError = false,
    bool clearPayosPaymentInfo = false,
  }) {
    return CheckoutState(
      rentalId: rentalId ?? this.rentalId,
      rentalDetail: rentalDetail ?? this.rentalDetail,
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
      photos: photos ?? this.photos,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      returnBattery: returnBattery ?? this.returnBattery,
      returnOdometer: returnOdometer ?? this.returnOdometer,
      note: note ?? this.note,
      payosPaymentInfo: clearPayosPaymentInfo
          ? null
          : (payosPaymentInfo ?? this.payosPaymentInfo),
      isLoadingPayOS: isLoadingPayOS ?? this.isLoadingPayOS,
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

  CreateCheckoutChecklistUseCase get _createCheckoutChecklistUseCase =>
      ref.read(createCheckoutChecklistUseCaseProvider);

  CreateOrUpdateVehicleLogUseCase get _createOrUpdateVehicleLogUseCase =>
      ref.read(createOrUpdateVehicleLogUseCaseProvider);

  UploadCarImageUseCase get _uploadCarImageUseCase =>
      ref.read(uploadCarImageUseCaseProvider);

  GetRentalDetailUseCase get _getRentalDetailUseCase =>
      ref.read(getRentalDetailUseCaseProvider);

  GetVehicleLogByRentalIdUseCase get _getVehicleLogByRentalIdUseCase =>
      ref.read(getVehicleLogByRentalIdUseCaseProvider);

  UpdateRentalStatusUseCase get _updateRentalStatusUseCase =>
      ref.read(updateRentalStatusUseCaseProvider);

  UpdateCheckoutChecklistUseCase get _updateCheckoutChecklistUseCase =>
      ref.read(updateCheckoutChecklistUseCaseProvider);

  CreateRentalCompensationPaymentLinkUseCase
  get _createRentalCompensationPaymentLinkUseCase =>
      ref.read(createRentalCompensationPaymentLinkUseCaseProvider);

  CheckRentalCompensationPaymentUseCase
  get _checkRentalCompensationPaymentUseCase =>
      ref.read(checkRentalCompensationPaymentUseCaseProvider);

  ImagePicker get _imagePicker => ImagePicker();

  @override
  CheckoutState build() {
    return const CheckoutState();
  }

  /// Khởi tạo dữ liệu trả xe cho chuyến đi (xác thực vị trí & quyết toán)
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

  /// Khởi tạo dữ liệu cho màn hình kiểm tra trả xe (Checkout Inspection)
  Future<void> initCheckoutInspection(
    int rentalId, {
    RentalDetailEntity? initialRental,
  }) async {
    state = state.copyWith(
      rentalId: rentalId,
      rentalDetail: initialRental,
      isLoading: true,
      clearError: true,
    );

    RentalDetailEntity? currentRental = initialRental;
    if (currentRental == null) {
      final rentalRes = await _getRentalDetailUseCase(rentalId);
      rentalRes.when(ok: (detail) => currentRental = detail, err: (_) {});
    }

    await loadChecklists(rentalId);

    // Nếu đã có biên bản CHECK_OUT, khôi phục lại pin và ảnh đã nộp
    int? returnBattery = state.returnBattery;
    List<CheckInPhoto> photos = state.photos;
    if (state.checkOutChecklist != null) {
      final outChecklist = state.checkOutChecklist!;
      returnBattery = outChecklist.currentBattery.toInt();
      if (photos.isEmpty && outChecklist.img.isNotEmpty) {
        final urls = outChecklist.img.split('|');
        photos = urls
            .where((u) => u.trim().isNotEmpty)
            .map(
              (url) => CheckInPhoto(
                id: 'checkout_img_${url.hashCode}',
                uploadedUrl: url.trim(),
              ),
            )
            .toList();
      }
    }

    // Thiết lập pin và ODO mặc định nếu có
    final startBattery =
        state.checkInChecklist?.currentBattery.toInt() ??
        currentRental?.currentBattery?.toInt();

    state = state.copyWith(
      isLoading: false,
      rentalDetail: currentRental,
      vehicleId: currentRental?.vehicleId ?? state.vehicleId,
      stationName: currentRental?.stationName ?? state.stationName,
      returnBattery: returnBattery ?? startBattery ?? 80,
      photos: photos,
    );
  }

  /// Chụp ảnh ngoại quan khi trả xe (Lưu local path trước, tải lên Cloudinary khi bấm gửi biên bản)
  Future<void> pickAndUploadPhotos({
    ImageSource source = ImageSource.camera,
  }) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1200,
      );
      if (picked != null) {
        final photoId = DateTime.now().microsecondsSinceEpoch.toString();
        final newPhoto = CheckInPhoto(id: photoId, localPath: picked.path);

        state = state.copyWith(
          photos: [...state.photos, newPhoto],
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Không thể mở máy ảnh: $e');
    }
  }

  /// Xóa ảnh trong danh sách
  void removePhoto(String photoId) {
    final updatedPhotos = state.photos.where((p) => p.id != photoId).toList();
    state = state.copyWith(photos: updatedPhotos);
  }

  void setReturnBattery(int battery) {
    state = state.copyWith(returnBattery: battery);
  }

  void setReturnOdometer(int? odo) {
    state = state.copyWith(returnOdometer: odo);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  void setIsVehicleDamaged(bool isDamaged) {
    state = state.copyWith(isVehicleDamaged: isDamaged);
  }

  void addDamageItem(String description, double cost) {
    if (description.trim().isEmpty || cost < 0) return;
    final item = VehicleDamageItemEntity(
      description: description.trim(),
      cost: cost,
    );
    state = state.copyWith(damageItems: [...state.damageItems, item]);
  }

  void removeDamageItem(int index) {
    if (index >= 0 && index < state.damageItems.length) {
      final updated = List<VehicleDamageItemEntity>.from(state.damageItems)
        ..removeAt(index);
      state = state.copyWith(damageItems: updated);
    }
  }

  /// Chụp ảnh bằng chứng hư hại xe trực tiếp từ camera (Lưu local path trước)
  Future<void> pickAndUploadDamagePhotos() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1200,
      );
      if (picked != null) {
        state = state.copyWith(
          damagePhotos: [...state.damagePhotos, picked.path],
          clearError: true,
        );
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Không thể mở máy ảnh: $e');
    }
  }

  void removeDamagePhoto(int index) {
    if (index >= 0 && index < state.damagePhotos.length) {
      final updated = List<String>.from(state.damagePhotos)..removeAt(index);
      state = state.copyWith(damagePhotos: updated);
    }
  }

  /// Nộp biên bản trả xe (Check-out checklist) & tạo VehicleLog nếu có hư hại
  Future<bool> submitCheckoutInspection({
    String? staffEmail,
    int? staffId,
  }) async {
    final rentalId = state.rentalId;
    if (rentalId == null) {
      state = state.copyWith(errorMessage: 'Mã đơn thuê không hợp lệ');
      return false;
    }

    if (state.returnBattery == null ||
        state.returnBattery! < 0 ||
        state.returnBattery! > 100) {
      state = state.copyWith(
        errorMessage: 'Vui lòng nhập phần trăm pin hợp lệ (0 - 100%)',
      );
      return false;
    }

    // Kiểm tra tính hợp lệ của biên bản hư hại xe (VehicleLog) nếu có bật
    if (state.isVehicleDamaged) {
      if (state.damageItems.isEmpty) {
        state = state.copyWith(
          errorMessage:
              'Vui lòng thêm ít nhất 1 hạng mục hư hại xe cần sửa chữa, hoặc tắt công tắc ghi nhận sự cố.',
        );
        return false;
      }
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    // 1. Tải các ảnh ngoại quan chưa upload lên Cloudinary
    final updatedPhotos = <CheckInPhoto>[];
    final uploadedUrls = <String>[];

    for (final photo in state.photos) {
      if (photo.isUploaded) {
        updatedPhotos.add(photo);
        uploadedUrls.add(photo.uploadedUrl);
      } else if (photo.localPath != null && photo.localPath!.isNotEmpty) {
        final uploadResult = await _uploadCarImageUseCase(photo.localPath!);
        final String? url = uploadResult.when(
          ok: (resUrl) => resUrl,
          err: (failure) {
            AppLogger.instance.w('Lỗi tải ảnh ngoại quan: ${failure.message}');
            return null;
          },
        );

        if (url != null && url.isNotEmpty) {
          final uploadedPhoto = photo.copyWith(
            uploadedUrl: url,
            isUploading: false,
          );
          updatedPhotos.add(uploadedPhoto);
          uploadedUrls.add(url);
        } else {
          state = state.copyWith(
            isSubmitting: false,
            errorMessage:
                'Không thể tải ảnh ngoại quan xe lên Cloudinary. Vui lòng thử lại.',
          );
          return false;
        }
      }
    }
    state = state.copyWith(photos: updatedPhotos);

    // 2. Tải các ảnh hư hại xe chưa upload lên Cloudinary
    final updatedDamagePhotos = <String>[];
    for (final damagePath in state.damagePhotos) {
      if (damagePath.startsWith('http://') ||
          damagePath.startsWith('https://')) {
        updatedDamagePhotos.add(damagePath);
      } else {
        final uploadResult = await _uploadCarImageUseCase(damagePath);
        final String? url = uploadResult.when(
          ok: (resUrl) => resUrl,
          err: (failure) {
            AppLogger.instance.w('Lỗi tải ảnh hư hại: ${failure.message}');
            return null;
          },
        );

        if (url != null && url.isNotEmpty) {
          updatedDamagePhotos.add(url);
        } else {
          state = state.copyWith(
            isSubmitting: false,
            errorMessage:
                'Không thể tải ảnh sự cố hư hại lên Cloudinary. Vui lòng thử lại.',
          );
          return false;
        }
      }
    }
    state = state.copyWith(damagePhotos: updatedDamagePhotos);

    final imgStr = uploadedUrls.isNotEmpty
        ? uploadedUrls.join('|')
        : (state.photos.isNotEmpty ? (state.photos.first.localPath ?? '') : '');

    // 3. Tạo mới hoặc cập nhật checklist CHECK_OUT nếu đã tồn tại
    RentalChecklistEntity? checklist;
    final existingCheckout = state.checkOutChecklist;

    if (existingCheckout != null && existingCheckout.id > 0) {
      final effectiveStaffEmail =
          staffEmail ?? existingCheckout.staffEmail ?? 'staff@swp391.com';
      final updateResult = await _updateCheckoutChecklistUseCase(
        id: existingCheckout.id,
        rentalId: rentalId,
        currentBattery: state.returnBattery!.toDouble(),
        img: imgStr,
        staffEmail: effectiveStaffEmail,
      );

      updateResult.when(
        ok: (chk) => checklist = chk,
        err: (f) => AppLogger.instance.w('Lỗi update checklist: ${f.message}'),
      );
    }

    if (checklist == null) {
      final checklistResult = await _createCheckoutChecklistUseCase(
        rentalId: rentalId,
        currentBattery: state.returnBattery!.toDouble(),
        img: imgStr,
        staffEmail: staffEmail,
      );

      await checklistResult.when(
        ok: (chk) async {
          checklist = chk;
        },
        err: (failure) async {
          final msg = failure.message.toLowerCase();
          if (msg.contains('đã được trả') ||
              msg.contains('already_checked_out') ||
              msg.contains('already checked out') ||
              msg.contains('already exists') ||
              msg.contains('đã tồn tại')) {
            await loadChecklists(rentalId);
            final currentOut = state.checkOutChecklist;
            if (currentOut != null && currentOut.id > 0) {
              final effectiveStaffEmail =
                  staffEmail ?? currentOut.staffEmail ?? 'staff@swp391.com';
              final retryUpdate = await _updateCheckoutChecklistUseCase(
                id: currentOut.id,
                rentalId: rentalId,
                currentBattery: state.returnBattery!.toDouble(),
                img: imgStr,
                staffEmail: effectiveStaffEmail,
              );
              retryUpdate.when(ok: (chk) => checklist = chk, err: (_) {});
            }
          } else {
            state = state.copyWith(
              isSubmitting: false,
              errorMessage: failure.message,
            );
          }
        },
      );
    }

    if (checklist != null) {
      state = state.copyWith(checkOutChecklist: checklist);
    }

    // 2. Nếu có ghi nhận hư hại, tạo hoặc cập nhật VehicleLog
    int effectiveVehicleId =
        state.rentalDetail?.vehicleId ??
        state.overview?.vehicleId ??
        state.vehicleId ??
        0;

    if (effectiveVehicleId <= 0) {
      final overviewRes = await _getRentalOverviewUseCase(rentalId);
      overviewRes.when(
        ok: (ov) {
          if (ov.vehicleId != null && ov.vehicleId! > 0) {
            effectiveVehicleId = ov.vehicleId!;
          }
        },
        err: (_) {},
      );
    }

    if (effectiveVehicleId <= 0) {
      final rentalRes = await _getRentalDetailUseCase(rentalId);
      rentalRes.when(
        ok: (detail) {
          if (detail.vehicleId != null && detail.vehicleId! > 0) {
            effectiveVehicleId = detail.vehicleId!;
          }
        },
        err: (_) {},
      );
    }

    if (state.isVehicleDamaged &&
        state.damageItems.isNotEmpty &&
        effectiveVehicleId > 0) {
      final repairItemsJson = state.damageItems
          .map(
            (item) => {
              'description': item.description,
              'cost': item.cost.toInt(),
            },
          )
          .toList();

      final damageImageUrls = state.damagePhotos.isNotEmpty
          ? state.damagePhotos
          : (uploadedUrls.isNotEmpty ? uploadedUrls : const <String>[]);

      final logResult = await _createOrUpdateVehicleLogUseCase(
        rentalId: rentalId,
        vehicleId: effectiveVehicleId,
        repairItems: repairItemsJson,
        imgs: damageImageUrls,
        staffId: staffId,
        logId: state.vehicleLog?.id,
      );

      logResult.when(
        ok: (vLog) {
          AppLogger.instance.i('Đã lưu vehicleLog thành công: ID=${vLog.id}');
          state = state.copyWith(vehicleLog: vLog);
        },
        err: (f) {
          AppLogger.instance.e('Lỗi tạo vehicleLog: ${f.message}');
          state = state.copyWith(
            errorMessage: 'Lưu hư hại xe thất bại: ${f.message}',
          );
        },
      );
    }

    // 3. Đảm bảo trạng thái đơn thuê chuyển sang PENDING_FEE theo yêu cầu của backend
    try {
      await _updateRentalStatusUseCase(
        rentalId: rentalId,
        status: 'PENDING_FEE',
      );
    } catch (e) {
      AppLogger.instance.w('Lỗi chuyển trạng thái PENDING_FEE: $e');
    }

    // 4. Tải lại bảng kê quyết toán
    await loadRentalOverview(rentalId);

    state = state.copyWith(
      isSubmitting: false,
      successMessage: 'Tạo biên bản trả xe thành công!',
    );

    ref.invalidate(rentalHistoryControllerProvider);
    ref.invalidate(myReservationsControllerProvider);
    return true;
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

      // 1. Thử lấy lastKnownPosition nhanh
      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition().timeout(
          const Duration(seconds: 2),
        );
      } catch (_) {}

      // 2. Nếu chưa có, lấy vị trí với accuracy medium và timeout nghiêm ngặt
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 4));

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
        final checkOut = checklists.where((c) => c.isCheckOut).firstOrNull;
        state = state.copyWith(
          checkInChecklist: checkIn,
          checkOutChecklist: checkOut,
        );
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
          damageItems: overview.vehicleDamages.isNotEmpty
              ? overview.vehicleDamages
              : state.damageItems,
          damagePhotos: overview.vehicleDamageImages.isNotEmpty
              ? overview.vehicleDamageImages
              : state.damagePhotos,
          isVehicleDamaged:
              overview.vehicleDamageFee > 0 ||
              overview.vehicleDamages.isNotEmpty ||
              state.isVehicleDamaged,
        );
      },
      err: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );

    // Lấy thông tin VehicleLog chi tiết để quyết toán trừ vào tiền cọc
    final logResult = await _getVehicleLogByRentalIdUseCase(rentalId);
    logResult.when(
      ok: (vLog) {
        if (vLog != null) {
          state = state.copyWith(
            vehicleLog: vLog,
            damageItems: vLog.repairItems.isNotEmpty
                ? vLog.repairItems
                : state.damageItems,
            damagePhotos: vLog.imgs.isNotEmpty ? vLog.imgs : state.damagePhotos,
            isVehicleDamaged:
                vLog.cost > 0 ||
                vLog.repairItems.isNotEmpty ||
                state.isVehicleDamaged,
          );
        }
      },
      err: (_) {},
    );
  }

  /// Xác nhận trả xe và quyết toán cọc qua UseCase
  Future<bool> confirmCheckoutAndSettle() async {
    final rentalId = state.rentalId;
    if (rentalId == null) return false;

    state = state.copyWith(isSubmitting: true, clearError: true);

    // Nếu đơn thuê có số tiền âm (cần đền bù), kiểm tra đối soát PayOS trước
    final overview = state.overview;
    final totalDeposits = overview?.totalDeposits ?? 0.0;
    final checkOutFee =
        overview?.checkListFee ?? (state.checkOutChecklist?.fee ?? 0.0);
    final vehicleDamageFee =
        (overview?.vehicleDamageFee != null && overview!.vehicleDamageFee > 0)
        ? overview.vehicleDamageFee
        : (state.vehicleLog?.cost ??
              (state.totalDamageCost > 0 ? state.totalDamageCost : 0.0));
    final balance = totalDeposits - (checkOutFee + vehicleDamageFee);

    if (balance < 0) {
      // Đối soát trực tiếp xem khách đã thanh toán đền bù qua PayOS chưa
      final checkResult = await _checkRentalCompensationPaymentUseCase(
        rentalId,
      );
      final isPaid = checkResult.when(ok: (paid) => paid, err: (_) => false);
      if (isPaid) {
        state = state.copyWith(
          isSubmitting: false,
          isCheckoutCompleted: true,
          successMessage:
              'Thanh toán đền bù thành công! Chuyến đi đã hoàn tất.',
        );
        ref.invalidate(rentalHistoryControllerProvider);
        ref.invalidate(myReservationsControllerProvider);
        return true;
      }
    }

    // Backend processCheckOutPayment bắt buộc: if (!rental.getStatus().equals(RentalStatus.PENDING_FEE)) throw INVALID_RENTAL_STATUS
    // Đảm bảo đơn thuê đã chuyển sang trạng thái PENDING_FEE trước khi xử lý thanh toán / hoàn cọc
    try {
      await _updateRentalStatusUseCase(
        rentalId: rentalId,
        status: 'PENDING_FEE',
      );
    } catch (e) {
      AppLogger.instance.w('Không thể cập nhật status sang PENDING_FEE: $e');
    }

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

  /// Lấy hoặc tạo thông tin thanh toán VietQR PayOS cho tiền đền bù cọc
  Future<void> fetchPayOSPaymentInfo({double? amount}) async {
    final rentalId = state.rentalId ?? 0;
    final cleanAmount = (amount != null && amount > 0)
        ? amount.toInt()
        : ((state.overview != null)
              ? (state.overview!.totalDeposits -
                        (state.overview!.checkListFee +
                            state.overview!.vehicleDamageFee))
                    .abs()
                    .toInt()
              : 0);

    if (cleanAmount <= 0) return;

    state = state.copyWith(isLoadingPayOS: true, clearError: true);

    // 1. Gọi API backend tạo link PayOS đền bù: POST /api/payment/payos/create-link/rental/{rentalId}
    final result = await _createRentalCompensationPaymentLinkUseCase(
      rentalId,
      amount: cleanAmount.toDouble(),
    );

    await result.when(
      ok: (payosInfo) async {
        state = state.copyWith(
          isLoadingPayOS: false,
          payosPaymentInfo: payosInfo,
        );
      },
      err: (failure) async {
        AppLogger.instance.w(
          'Lỗi gọi API create-link rental PayOS: ${failure.message}. Thử tạo mã dự phòng.',
        );

        // Fallback: Nếu backend có sự cố mạng, tạo mã VietQR dự phòng
        final desc = 'DEN BU DON $rentalId';
        const bankName = 'MBBank (Quân Đội)';
        const bin = '970422';
        const accountNumber = '0909123456';
        const accountName = 'CONG TY E-MOTION';
        final realQrUrl =
            'https://img.vietqr.io/image/$bin-$accountNumber-compact2.png?amount=$cleanAmount&addInfo=${Uri.encodeComponent(desc)}&accountName=${Uri.encodeComponent(accountName)}';

        final fallbackPayos = PayOSPaymentInfoEntity(
          orderCode: 'DENBU_$rentalId',
          amount: cleanAmount.toDouble(),
          description: desc,
          accountNumber: accountNumber,
          accountName: accountName,
          bankName: bankName,
          bin: bin,
          qrCodeUrl: realQrUrl,
        );

        state = state.copyWith(
          isLoadingPayOS: false,
          payosPaymentInfo: fallbackPayos,
        );
      },
    );
  }

  /// Kiểm tra và xác nhận trạng thái thanh toán đền bù đơn thuê với PayOS (Active Check)
  Future<bool> checkCompensationPayment() async {
    final rentalId = state.rentalId;
    if (rentalId == null || rentalId <= 0) return false;

    state = state.copyWith(isLoadingPayOS: true, clearError: true);

    final result = await _checkRentalCompensationPaymentUseCase(rentalId);

    return result.when(
      ok: (isPaid) async {
        state = state.copyWith(isLoadingPayOS: false);
        if (isPaid) {
          state = state.copyWith(
            isCheckoutCompleted: true,
            successMessage:
                'Xác nhận thanh toán đền bù thành công! Hợp đồng thuê đã hoàn tất.',
          );
          await loadRentalOverview(rentalId);
          ref.invalidate(rentalHistoryControllerProvider);
          ref.invalidate(myReservationsControllerProvider);
          return true;
        }
        return false;
      },
      err: (failure) {
        state = state.copyWith(
          isLoadingPayOS: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}

final checkoutControllerProvider =
    NotifierProvider<CheckoutController, CheckoutState>(CheckoutController.new);
