import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';

class SosReportModel {
  const SosReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.status = 'PENDING',
    this.createdAt,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.rentalId,
    this.userEmail,
  });

  final int? id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String? createdAt;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final int? rentalId;
  final String? userEmail;

  factory SosReportModel.fromJson(Map<String, dynamic> json) {
    return SosReportModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Báo cáo sự cố',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'TECHNICAL_FAULT',
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['createdAt'] as String?,
      imageUrl: json['imageUrl'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rentalId: json['rentalId'] as int?,
      userEmail: json['userEmail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': ?id,
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'imageUrl': ?imageUrl,
      'latitude': ?latitude,
      'longitude': ?longitude,
      'rentalId': ?rentalId,
      'userEmail': ?userEmail,
    };
  }

  SosReportEntity toEntity() {
    return SosReportEntity(
      id: id,
      title: title,
      description: description,
      type: EmergencyType.fromCode(type),
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      rentalId: rentalId,
      userEmail: userEmail,
      status: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}
