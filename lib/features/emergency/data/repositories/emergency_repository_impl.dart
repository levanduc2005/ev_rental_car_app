import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/emergency/data/datasources/emergency_remote_data_source.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  const EmergencyRepositoryImpl({
    required EmergencyRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final EmergencyRemoteDataSource _remoteDataSource;

  @override
  Future<Result<SosReportEntity>> submitEmergencyReport({
    required EmergencyType type,
    required String description,
    String? title,
    String? imageUrl,
    double? latitude,
    double? longitude,
    int? rentalId,
    String? userEmail,
  }) {
    return safeCall(() async {
      final buffer = StringBuffer();
      buffer.writeln('[SỰ CỐ KHẨN CẤP: ${type.displayName.toUpperCase()}]');
      buffer.writeln('Mô tả tình trạng: $description');
      if (rentalId != null) {
        buffer.writeln('Mã chuyến thuê: #$rentalId');
      }
      if (latitude != null && longitude != null) {
        buffer.writeln('Tọa độ GPS: $latitude, $longitude');
        buffer.writeln(
          'Vị trí Google Maps: https://maps.google.com/?q=$latitude,$longitude',
        );
      }
      if (imageUrl != null && imageUrl.isNotEmpty) {
        buffer.writeln('Ảnh chụp hiện trường: $imageUrl');
      }

      final effectiveTitle = title ?? '[SOS] ${type.displayName}';
      final model = await _remoteDataSource.submitReport(
        title: effectiveTitle,
        description: buffer.toString(),
        type: type.code,
        userEmail: userEmail,
      );

      return model.toEntity().copyWith(
        type: type,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
        rentalId: rentalId,
      );
    });
  }

  @override
  Future<Result<String>> uploadIncidentImage(String filePath) {
    return safeCall(() async {
      return await _remoteDataSource.uploadIncidentImage(filePath);
    });
  }

  @override
  Future<Result<List<SosReportEntity>>> getEmergencyReports() {
    return safeCall(() async {
      final models = await _remoteDataSource.getEmergencyReports();
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
