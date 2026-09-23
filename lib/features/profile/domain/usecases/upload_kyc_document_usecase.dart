import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class UploadKycDocumentUseCase {
  const UploadKycDocumentUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<KycDocumentEntity>> call({
    required String imagePath,
    required DocumentType type,
    required String number,
    String? licenseClass,
    DateTime? expiryDate,
    required String email,
  }) {
    return _repository.uploadKycDocument(
      imagePath: imagePath,
      type: type,
      number: number,
      licenseClass: licenseClass,
      expiryDate: expiryDate,
      email: email,
    );
  }
}
