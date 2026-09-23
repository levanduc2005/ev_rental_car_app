import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/usecases/upload_kyc_document_usecase.dart';
import 'package:rental_car/features/profile/presentation/controllers/kyc_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class KycController extends Notifier<KycState> {
  late final UploadKycDocumentUseCase _uploadKycDocumentUseCase;

  @override
  KycState build() {
    _uploadKycDocumentUseCase = ref.watch(uploadKycDocumentUseCaseProvider);
    return const KycState();
  }

  void setImage(String path) {
    state = state.copyWith(selectedImagePath: path, clearError: true);
  }

  void setDocumentType(DocumentType type) {
    state = state.copyWith(documentType: type);
  }

  void setDocumentNumber(String number) {
    state = state.copyWith(documentNumber: number);
  }

  void setLicenseClass(String licenseClass) {
    state = state.copyWith(licenseClass: licenseClass);
  }

  void setExpiryDate(DateTime date) {
    state = state.copyWith(expiryDate: date);
  }

  void reset() {
    state = const KycState();
  }

  Future<bool> submitDocument({required String userEmail}) async {
    if (state.selectedImagePath == null) {
      state = state.copyWith(
        stepStatus: KycStepStatus.failure,
        errorMessage: 'Vui lòng chọn ảnh chụp giấy tờ (GPLX hoặc CCCD).',
      );
      return false;
    }

    if (state.documentNumber.trim().isEmpty) {
      state = state.copyWith(
        stepStatus: KycStepStatus.failure,
        errorMessage: 'Vui lòng nhập số giấy tờ.',
      );
      return false;
    }

    state = state.copyWith(
      stepStatus: KycStepStatus.uploadingImage,
      clearError: true,
    );

    final result = await _uploadKycDocumentUseCase(
      imagePath: state.selectedImagePath!,
      type: state.documentType,
      number: state.documentNumber.trim(),
      licenseClass: state.licenseClass,
      expiryDate: state.expiryDate,
      email: userEmail,
    );

    return result.when(
      ok: (document) {
        state = state.copyWith(
          stepStatus: KycStepStatus.success,
          uploadedDocument: document,
          clearError: true,
        );
        // Làm mới profile để cập nhật trạng thái
        ref.read(profileControllerProvider.notifier).refreshProfile();
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          stepStatus: KycStepStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }

  Future<bool> deleteDocument(int docId) async {
    state = state.copyWith(
      stepStatus: KycStepStatus.uploadingImage,
      clearError: true,
    );
    final deleteUseCase = ref.read(deleteKycDocumentUseCaseProvider);
    final result = await deleteUseCase(docId);
    return result.when(
      ok: (_) {
        state = const KycState();
        ref.read(profileControllerProvider.notifier).refreshProfile();
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          stepStatus: KycStepStatus.failure,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}
