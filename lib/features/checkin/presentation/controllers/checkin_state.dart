import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

enum CheckInStep { inspection, contractSigning, completed }

enum CarAngle {
  front('Đầu xe', 'Chụp rõ mặt trước xe & biển số'),
  back('Đuôi xe', 'Chụp rõ cản sau & cốp xe'),
  left('Sườn trái', 'Chụp toàn bộ hông xe bên lái'),
  right('Sườn phải', 'Chụp toàn bộ hông xe bên phụ');

  const CarAngle(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

/// Một ảnh chụp xe trong danh sách ảnh kiểm tra nhận xe
class CheckInPhoto {
  const CheckInPhoto({
    required this.id,
    this.localPath,
    this.uploadedUrl = '',
    this.isUploading = false,
  });

  final String id;
  final String? localPath;
  final String uploadedUrl;
  final bool isUploading;

  bool get isUploaded => uploadedUrl.trim().isNotEmpty;

  CheckInPhoto copyWith({
    String? id,
    String? localPath,
    String? uploadedUrl,
    bool? isUploading,
  }) {
    return CheckInPhoto(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class CheckInState {
  const CheckInState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isSigning = false,
    this.isUploadingPhoto = false,
    this.uploadingAngle,
    this.errorMessage,
    this.rentalDetail,
    this.licenseStatus,
    this.currentStep = CheckInStep.inspection,
    this.photos = const [],
    this.frontImagePath,
    this.frontUrl = '',
    this.backImagePath,
    this.backUrl = '',
    this.leftImagePath,
    this.leftUrl = '',
    this.rightImagePath,
    this.rightUrl = '',
    this.odometer,
    this.batteryPercentage = 95,
    this.accessories = const AccessoryChecklistEntity(),
    this.note,
    this.createdChecklist,
    this.contract,
    this.isContractSigned = false,
  });

  final bool isLoading;
  final bool isSubmitting;
  final bool isSigning;
  final bool isUploadingPhoto;
  final CarAngle? uploadingAngle;
  final String? errorMessage;
  final RentalDetailEntity? rentalDetail;
  final LicenseStatusEntity? licenseStatus;
  final CheckInStep currentStep;

  // Danh sách ảnh chụp xe tự do (không cần chia góc)
  final List<CheckInPhoto> photos;

  // Legacy ảnh 4 góc (để tương thích ngược)
  final String? frontImagePath;
  final String frontUrl;
  final String? backImagePath;
  final String backUrl;
  final String? leftImagePath;
  final String leftUrl;
  final String? rightImagePath;
  final String rightUrl;

  // Thông số xe
  final int? odometer;
  final int batteryPercentage;
  final AccessoryChecklistEntity accessories;
  final String? note;

  // Kết quả
  final PickupChecklistEntity? createdChecklist;
  final DocuSealContractEntity? contract;
  final bool isContractSigned;

  bool get hasAllPhotos =>
      frontUrl.trim().isNotEmpty &&
      backUrl.trim().isNotEmpty &&
      leftUrl.trim().isNotEmpty &&
      rightUrl.trim().isNotEmpty;

  /// Đã có ít nhất 1 ảnh tải lên thành công (tự do hoặc 4 góc)
  bool get hasPhotos =>
      photos.any((p) => p.isUploaded) ||
      hasAllPhotos ||
      frontUrl.trim().isNotEmpty;

  int get uploadedPhotosCount {
    if (photos.isNotEmpty) {
      return photos.where((p) => p.isUploaded).length;
    }
    var count = 0;
    if (frontUrl.trim().isNotEmpty) count++;
    if (backUrl.trim().isNotEmpty) count++;
    if (leftUrl.trim().isNotEmpty) count++;
    if (rightUrl.trim().isNotEmpty) count++;
    return count;
  }

  bool get isInspectionFormValid =>
      hasPhotos &&
      odometer != null &&
      odometer! > 0 &&
      batteryPercentage > 0 &&
      batteryPercentage <= 100;

  CheckInState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isSigning,
    bool? isUploadingPhoto,
    CarAngle? Function()? uploadingAngle,
    String? Function()? errorMessage,
    RentalDetailEntity? rentalDetail,
    LicenseStatusEntity? licenseStatus,
    CheckInStep? currentStep,
    List<CheckInPhoto>? photos,
    String? Function()? frontImagePath,
    String? frontUrl,
    String? Function()? backImagePath,
    String? backUrl,
    String? Function()? leftImagePath,
    String? leftUrl,
    String? Function()? rightImagePath,
    String? rightUrl,
    int? Function()? odometer,
    int? batteryPercentage,
    AccessoryChecklistEntity? accessories,
    String? Function()? note,
    PickupChecklistEntity? createdChecklist,
    DocuSealContractEntity? contract,
    bool? isContractSigned,
  }) {
    return CheckInState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSigning: isSigning ?? this.isSigning,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      uploadingAngle: uploadingAngle != null
          ? uploadingAngle()
          : this.uploadingAngle,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      rentalDetail: rentalDetail ?? this.rentalDetail,
      licenseStatus: licenseStatus ?? this.licenseStatus,
      currentStep: currentStep ?? this.currentStep,
      photos: photos ?? this.photos,
      frontImagePath: frontImagePath != null
          ? frontImagePath()
          : this.frontImagePath,
      frontUrl: frontUrl ?? this.frontUrl,
      backImagePath: backImagePath != null
          ? backImagePath()
          : this.backImagePath,
      backUrl: backUrl ?? this.backUrl,
      leftImagePath: leftImagePath != null
          ? leftImagePath()
          : this.leftImagePath,
      leftUrl: leftUrl ?? this.leftUrl,
      rightImagePath: rightImagePath != null
          ? rightImagePath()
          : this.rightImagePath,
      rightUrl: rightUrl ?? this.rightUrl,
      odometer: odometer != null ? odometer() : this.odometer,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      accessories: accessories ?? this.accessories,
      note: note != null ? note() : this.note,
      createdChecklist: createdChecklist ?? this.createdChecklist,
      contract: contract ?? this.contract,
      isContractSigned: isContractSigned ?? this.isContractSigned,
    );
  }
}
