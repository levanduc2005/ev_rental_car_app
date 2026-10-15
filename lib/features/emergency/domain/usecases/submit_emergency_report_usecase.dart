import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';

class SubmitEmergencyReportUseCase {
  const SubmitEmergencyReportUseCase(this._repository);

  final EmergencyRepository _repository;

  Future<Result<SosReportEntity>> call({
    required EmergencyType type,
    required String description,
    String? title,
    String? imageUrl,
    double? latitude,
    double? longitude,
    int? rentalId,
    String? userEmail,
  }) {
    final trimmedDesc = description.trim();
    if (trimmedDesc.isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Vui lòng nhập mô tả chi tiết sự cố gặp phải.'),
        ),
      );
    }

    final effectiveTitle = (title != null && title.trim().isNotEmpty)
        ? title.trim()
        : '[SOS] ${type.displayName}';

    return _repository.submitEmergencyReport(
      type: type,
      description: trimmedDesc,
      title: effectiveTitle,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      rentalId: rentalId,
      userEmail: userEmail,
    );
  }
}
