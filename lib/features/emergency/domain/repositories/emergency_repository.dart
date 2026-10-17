import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';

abstract interface class EmergencyRepository {
  Future<Result<SosReportEntity>> submitEmergencyReport({
    required EmergencyType type,
    required String description,
    String? title,
    String? imageUrl,
    double? latitude,
    double? longitude,
    int? rentalId,
    String? userEmail,
  });

  Future<Result<String>> uploadIncidentImage(String filePath);

  Future<Result<List<SosReportEntity>>> getEmergencyReports();
}
