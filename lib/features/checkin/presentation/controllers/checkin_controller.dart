import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';
import 'package:rental_car/features/checkin/domain/usecases/check_license_status_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/confirm_contract_signed_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/generate_contract_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/submit_pickup_checklist_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_state.dart';
import 'package:rental_car/features/checkin/presentation/providers/checkin_providers.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_detail_usecase.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class CheckInController extends Notifier<CheckInState> {
  GetRentalDetailUseCase? _injectedGetRentalDetailUseCase;
  CheckLicenseStatusUseCase? _injectedCheckLicenseStatusUseCase;
  UploadCarImageUseCase? _injectedUploadCarImageUseCase;
  SubmitPickupChecklistUseCase? _injectedSubmitPickupChecklistUseCase;
  GenerateContractUseCase? _injectedGenerateContractUseCase;
  ConfirmContractSignedUseCase? _injectedConfirmContractSignedUseCase;
  ImagePicker? _injectedImagePicker;

  GetRentalDetailUseCase get _getRentalDetailUseCase =>
      _injectedGetRentalDetailUseCase ??
      ref.read(getRentalDetailUseCaseProvider);

  CheckLicenseStatusUseCase get _checkLicenseStatusUseCase =>
      _injectedCheckLicenseStatusUseCase ??
      ref.read(checkLicenseStatusUseCaseProvider);

  UploadCarImageUseCase get _uploadCarImageUseCase =>
      _injectedUploadCarImageUseCase ?? ref.read(uploadCarImageUseCaseProvider);

  SubmitPickupChecklistUseCase get _submitPickupChecklistUseCase =>
      _injectedSubmitPickupChecklistUseCase ??
      ref.read(submitPickupChecklistUseCaseProvider);

  GenerateContractUseCase get _generateContractUseCase =>
      _injectedGenerateContractUseCase ??
      ref.read(generateContractUseCaseProvider);

  ConfirmContractSignedUseCase get _confirmContractSignedUseCase =>
      _injectedConfirmContractSignedUseCase ??
      ref.read(confirmContractSignedUseCaseProvider);

  ImagePicker get _imagePicker => _injectedImagePicker ?? ImagePicker();

  void injectDependencies({
    GetRentalDetailUseCase? getRentalDetailUseCase,
    CheckLicenseStatusUseCase? checkLicenseStatusUseCase,
    UploadCarImageUseCase? uploadCarImageUseCase,
    SubmitPickupChecklistUseCase? submitPickupChecklistUseCase,
    GenerateContractUseCase? generateContractUseCase,
    ConfirmContractSignedUseCase? confirmContractSignedUseCase,
    ImagePicker? imagePicker,
  }) {
    _injectedGetRentalDetailUseCase = getRentalDetailUseCase;
    _injectedCheckLicenseStatusUseCase = checkLicenseStatusUseCase;
    _injectedUploadCarImageUseCase = uploadCarImageUseCase;
    _injectedSubmitPickupChecklistUseCase = submitPickupChecklistUseCase;
    _injectedGenerateContractUseCase = generateContractUseCase;
    _injectedConfirmContractSignedUseCase = confirmContractSignedUseCase;
    _injectedImagePicker = imagePicker;
  }

  @override
  CheckInState build() => const CheckInState();

  /// Khởi tạo dữ liệu đơn thuê và kiểm tra trạng thái KYC bằng lái
  Future<void> init(int rentalId, [RentalDetailEntity? initialRental]) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: () => null,
      rentalDetail: initialRental,
    );

    // 1. Nạp chi tiết đơn thuê nếu chưa có
    RentalDetailEntity? currentRental = initialRental;
    if (currentRental == null) {
      final rentalResult = await _getRentalDetailUseCase(rentalId);
      rentalResult.when(
        ok: (data) => currentRental = data,
        err: (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: () => failure.message,
          );
        },
      );
    }

    if (currentRental != null) {
      final initialBattery =
          currentRental?.currentBattery?.toInt() ?? state.batteryPercentage;
      state = state.copyWith(
        rentalDetail: currentRental,
        batteryPercentage: initialBattery > 0 ? initialBattery : 95,
      );
    }

    // 2. Kiểm tra điều kiện bằng lái xe KYC
    final licenseResult = await _checkLicenseStatusUseCase();
    licenseResult.when(
      ok: (license) {
        state = state.copyWith(isLoading: false, licenseStatus: license);
      },
      err: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
    );
  }

  /// Làm mới trạng thái bằng lái xe KYC
  Future<bool> refreshLicenseStatus() async {
    final licenseResult = await _checkLicenseStatusUseCase();
    return licenseResult.when(
      ok: (license) {
        state = state.copyWith(licenseStatus: license);
        return license.isApproved;
      },
      err: (_) => false,
    );
  }

  /// Chụp ảnh hoặc chọn ảnh tự do cho nhân viên (không bắt buộc chia góc)
  Future<void> pickAndUploadPhotos({required ImageSource source}) async {
    try {
      if (source == ImageSource.camera) {
        final picked = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1200,
        );
        if (picked != null) {
          await _uploadSinglePhoto(picked.path);
        }
      } else {
        // Cho phép chọn nhiều ảnh một lúc từ thư viện
        final pickedList = await _imagePicker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1600,
          maxHeight: 1200,
        );
        if (pickedList.isNotEmpty) {
          for (final picked in pickedList) {
            await _uploadSinglePhoto(picked.path);
          }
        }
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: () => 'Không thể mở máy ảnh hoặc thư viện: $e',
      );
    }
  }

  Future<void> _uploadSinglePhoto(String path) async {
    final photoId = DateTime.now().microsecondsSinceEpoch.toString();
    final newPhoto = CheckInPhoto(
      id: photoId,
      localPath: path,
      isUploading: true,
    );

    // Thêm ảnh vào danh sách ngay lập tức để hiển thị preview cho người dùng
    state = state.copyWith(
      photos: [...state.photos, newPhoto],
      isUploadingPhoto: true,
      errorMessage: () => null,
    );

    final uploadResult = await _uploadCarImageUseCase(path);
    uploadResult.when(
      ok: (url) {
        final updatedPhotos = state.photos.map((p) {
          if (p.id == photoId) {
            return p.copyWith(uploadedUrl: url, isUploading: false);
          }
          return p;
        }).toList();

        state = state.copyWith(
          photos: updatedPhotos,
          isUploadingPhoto: updatedPhotos.any((p) => p.isUploading),
        );
      },
      err: (failure) {
        final updatedPhotos = state.photos
            .where((p) => p.id != photoId)
            .toList();
        state = state.copyWith(
          photos: updatedPhotos,
          isUploadingPhoto: updatedPhotos.any((p) => p.isUploading),
          errorMessage: () => 'Tải ảnh thất bại: ${failure.message}',
        );
      },
    );
  }

  /// Xóa ảnh trong danh sách ảnh tự do
  void removePhoto(String photoId) {
    final updatedPhotos = state.photos.where((p) => p.id != photoId).toList();
    state = state.copyWith(photos: updatedPhotos);
  }

  /// Legacy: Chụp hoặc chọn ảnh cho một góc xe (tương thích ngược)
  Future<void> pickAndUploadImage(CarAngle angle, ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1200,
      );
      if (picked == null) return;

      _setLocalImagePath(angle, picked.path);
      state = state.copyWith(
        uploadingAngle: () => angle,
        errorMessage: () => null,
      );

      final uploadResult = await _uploadCarImageUseCase(picked.path);
      uploadResult.when(
        ok: (url) {
          _setUploadedUrl(angle, url);
          state = state.copyWith(uploadingAngle: () => null);
        },
        err: (failure) {
          state = state.copyWith(
            uploadingAngle: () => null,
            errorMessage: () =>
                'Tải ảnh ${angle.title} thất bại: ${failure.message}',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        uploadingAngle: () => null,
        errorMessage: () => 'Không thể mở máy ảnh hoặc thư viện: $e',
      );
    }
  }

  void _setLocalImagePath(CarAngle angle, String path) {
    switch (angle) {
      case CarAngle.front:
        state = state.copyWith(frontImagePath: () => path);
        break;
      case CarAngle.back:
        state = state.copyWith(backImagePath: () => path);
        break;
      case CarAngle.left:
        state = state.copyWith(leftImagePath: () => path);
        break;
      case CarAngle.right:
        state = state.copyWith(rightImagePath: () => path);
        break;
    }
  }

  void _setUploadedUrl(CarAngle angle, String url) {
    switch (angle) {
      case CarAngle.front:
        state = state.copyWith(frontUrl: url);
        break;
      case CarAngle.back:
        state = state.copyWith(backUrl: url);
        break;
      case CarAngle.left:
        state = state.copyWith(leftUrl: url);
        break;
      case CarAngle.right:
        state = state.copyWith(rightUrl: url);
        break;
    }
  }

  /// Legacy: Gỡ bỏ ảnh đã chụp của một góc
  void removeImage(CarAngle angle) {
    switch (angle) {
      case CarAngle.front:
        state = state.copyWith(frontImagePath: () => null, frontUrl: '');
        break;
      case CarAngle.back:
        state = state.copyWith(backImagePath: () => null, backUrl: '');
        break;
      case CarAngle.left:
        state = state.copyWith(leftImagePath: () => null, leftUrl: '');
        break;
      case CarAngle.right:
        state = state.copyWith(rightImagePath: () => null, rightUrl: '');
        break;
    }
  }

  void setOdometer(int? odo) {
    state = state.copyWith(odometer: () => odo);
  }

  void setBatteryPercentage(int battery) {
    state = state.copyWith(batteryPercentage: battery.clamp(1, 100));
  }

  void updateAccessory({
    bool? hasPortableCharger,
    bool? hasTireRepairKit,
    bool? hasChargingCard,
  }) {
    state = state.copyWith(
      accessories: state.accessories.copyWith(
        hasPortableCharger: hasPortableCharger,
        hasTireRepairKit: hasTireRepairKit,
        hasChargingCard: hasChargingCard,
      ),
    );
  }

  void setNote(String? note) {
    state = state.copyWith(note: () => note);
  }

  /// Gửi biên bản kiểm tra nhận xe (PICKUP) và chuyển sang bước ký hợp đồng
  Future<bool> submitChecklist(int rentalId) async {
    if (!state.isInspectionFormValid) {
      state = state.copyWith(
        errorMessage: () => 'Vui lòng điền ODO, Pin và chụp ít nhất 1 ảnh xe.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);

    final uploadedUrls = state.photos
        .where((p) => p.isUploaded)
        .map((p) => p.uploadedUrl)
        .toList();

    final carImages = uploadedUrls.isNotEmpty
        ? CarImagesEntity(urls: uploadedUrls)
        : CarImagesEntity(
            frontUrl: state.frontUrl,
            backUrl: state.backUrl,
            leftSideUrl: state.leftUrl,
            rightSideUrl: state.rightUrl,
          );

    final result = await _submitPickupChecklistUseCase(
      rentalId: rentalId,
      odometer: state.odometer!,
      batteryPercentage: state.batteryPercentage,
      accessories: state.accessories,
      images: carImages,
      note: state.note,
    );

    return result.when(
      ok: (checklist) async {
        state = state.copyWith(
          isSubmitting: false,
          createdChecklist: checklist,
        );
        // Tự động khởi tạo link hợp đồng DocuSeal
        final contractSuccess = await requestContractSigning(rentalId);
        if (contractSuccess) {
          state = state.copyWith(currentStep: CheckInStep.contractSigning);
          return true;
        }
        return false;
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Tạo hoặc lấy link ký hợp đồng DocuSeal
  Future<bool> requestContractSigning(int rentalId) async {
    state = state.copyWith(isSigning: true, errorMessage: () => null);

    final result = await _generateContractUseCase(rentalId);
    return result.when(
      ok: (contract) {
        state = state.copyWith(isSigning: false, contract: contract);
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSigning: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  /// Xác nhận đã hoàn tất ký hợp đồng số DocuSeal (Webhook hoặc Fallback callback)
  Future<bool> confirmContractSigned(int rentalId) async {
    state = state.copyWith(isSigning: true, errorMessage: () => null);

    final result = await _confirmContractSignedUseCase(rentalId);
    return result.when(
      ok: (confirmResult) {
        state = state.copyWith(
          isSigning: false,
          isContractSigned: true,
          currentStep: CheckInStep.completed,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isSigning: false,
          errorMessage: () => failure.message,
        );
        return false;
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }
}
