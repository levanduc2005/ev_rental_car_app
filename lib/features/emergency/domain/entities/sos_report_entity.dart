import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';

class SosReportEntity {
  const SosReportEntity({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.rentalId,
    this.userEmail,
    this.status = 'PENDING',
    this.createdAt,
  });

  final int? id;
  final String title;
  final String description;
  final EmergencyType type;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final int? rentalId;
  final String? userEmail;
  final String status;
  final DateTime? createdAt;

  SosReportEntity copyWith({
    int? id,
    String? title,
    String? description,
    EmergencyType? type,
    String? imageUrl,
    double? latitude,
    double? longitude,
    int? rentalId,
    String? userEmail,
    String? status,
    DateTime? createdAt,
  }) {
    return SosReportEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rentalId: rentalId ?? this.rentalId,
      userEmail: userEmail ?? this.userEmail,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SosReportEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          type == other.type &&
          imageUrl == other.imageUrl &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          rentalId == other.rentalId;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    type,
    imageUrl,
    latitude,
    longitude,
    rentalId,
  );
}
