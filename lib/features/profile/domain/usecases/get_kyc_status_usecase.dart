import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class GetKycStatusUseCase {
  const GetKycStatusUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<KycDocumentEntity>>> call(String email) {
    return _repository.getKycDocuments(email);
  }
}
