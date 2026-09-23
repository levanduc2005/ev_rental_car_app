import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

enum KycStepStatus { idle, uploadingImage, verifyingOcr, success, failure }

class KycState {
  const KycState({
    this.stepStatus = KycStepStatus.idle,
    this.selectedImagePath,
    this.documentType = DocumentType.license,
    this.documentNumber = '',
    this.licenseClass = 'B2',
    this.expiryDate,
    this.uploadedDocument,
    this.errorMessage,
  });

  final KycStepStatus stepStatus;
  final String? selectedImagePath;
  final DocumentType documentType;
  final String documentNumber;
  final String licenseClass;
  final DateTime? expiryDate;
  final KycDocumentEntity? uploadedDocument;
  final String? errorMessage;

  bool get isSubmitting =>
      stepStatus == KycStepStatus.uploadingImage ||
      stepStatus == KycStepStatus.verifyingOcr;

  KycState copyWith({
    KycStepStatus? stepStatus,
    String? selectedImagePath,
    DocumentType? documentType,
    String? documentNumber,
    String? licenseClass,
    DateTime? expiryDate,
    KycDocumentEntity? uploadedDocument,
    String? errorMessage,
    bool clearError = false,
    bool clearImage = false,
  }) {
    return KycState(
      stepStatus: stepStatus ?? this.stepStatus,
      selectedImagePath: clearImage
          ? null
          : (selectedImagePath ?? this.selectedImagePath),
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      licenseClass: licenseClass ?? this.licenseClass,
      expiryDate: expiryDate ?? this.expiryDate,
      uploadedDocument: uploadedDocument ?? this.uploadedDocument,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
