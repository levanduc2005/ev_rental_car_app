import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';

class EmergencyState {
  const EmergencyState({
    this.selectedType = EmergencyType.flatTire,
    this.selectedImagePath,
    this.uploadedImageUrl,
    this.isUploadingImage = false,
    this.latitude,
    this.longitude,
    this.address,
    this.isLoadingLocation = false,
    this.locationError,
    this.isSubmitting = false,
    this.submittedReport,
    this.errorMessage,
  });

  final EmergencyType selectedType;
  final String? selectedImagePath;
  final String? uploadedImageUrl;
  final bool isUploadingImage;
  final double? latitude;
  final double? longitude;
  final String? address;
  final bool isLoadingLocation;
  final String? locationError;
  final bool isSubmitting;
  final SosReportEntity? submittedReport;
  final String? errorMessage;

  bool get hasLocation => latitude != null && longitude != null;

  EmergencyState copyWith({
    EmergencyType? selectedType,
    String? selectedImagePath,
    String? uploadedImageUrl,
    bool? isUploadingImage,
    double? latitude,
    double? longitude,
    String? address,
    bool? isLoadingLocation,
    String? locationError,
    bool? isSubmitting,
    SosReportEntity? submittedReport,
    String? errorMessage,
    bool clearImage = false,
    bool clearLocationError = false,
    bool clearErrorMessage = false,
  }) {
    return EmergencyState(
      selectedType: selectedType ?? this.selectedType,
      selectedImagePath: clearImage
          ? null
          : (selectedImagePath ?? this.selectedImagePath),
      uploadedImageUrl: clearImage
          ? null
          : (uploadedImageUrl ?? this.uploadedImageUrl),
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      locationError: clearLocationError
          ? null
          : (locationError ?? this.locationError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submittedReport: submittedReport ?? this.submittedReport,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
