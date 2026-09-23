import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class DeleteKycDocumentUseCase {
  const DeleteKycDocumentUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call(int docId) {
    return _repository.deleteDocument(docId);
  }
}
