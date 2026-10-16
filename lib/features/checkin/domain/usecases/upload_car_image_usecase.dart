import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';

class UploadCarImageUseCase {
  const UploadCarImageUseCase(this._repository);

  final CheckinRepository _repository;

  Future<Result<String>> call(String filePath) {
    if (filePath.trim().isEmpty) {
      return Future.value(
        const Result.err(DataFailure(message: 'Đường dẫn ảnh không hợp lệ')),
      );
    }
    return _repository.uploadCarImage(filePath);
  }
}
