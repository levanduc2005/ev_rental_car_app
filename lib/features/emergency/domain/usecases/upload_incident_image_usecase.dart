import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';

class UploadIncidentImageUseCase {
  const UploadIncidentImageUseCase(this._repository);

  final EmergencyRepository _repository;

  Future<Result<String>> call(String filePath) {
    if (filePath.trim().isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Đường dẫn ảnh hiện trường không hợp lệ.'),
        ),
      );
    }
    return _repository.uploadIncidentImage(filePath);
  }
}
