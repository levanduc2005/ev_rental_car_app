import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';

class RentalItemModel {
  const RentalItemModel({
    required this.id,
    required this.vehicleName,
    this.vehicleImage,
    this.stationName,
    required this.status,
    this.createdAt,
    this.paymentUrl,
  });

  final int id;
  final String vehicleName;
  final String? vehicleImage;
  final String? stationName;
  final String status;
  final String? createdAt;
  final String? paymentUrl;

  factory RentalItemModel.fromJson(Map<String, dynamic> json) {
    return RentalItemModel(
      id: json['id'] as int? ?? 0,
      vehicleName: json['vehicleName'] as String? ?? 'Xe điện EV',
      vehicleImage: json['vehicleImage'] as String?,
      stationName: json['stationName'] as String?,
      status: json['status'] as String? ?? 'ONGOING',
      createdAt: json['createdAt'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
    );
  }

  RentalItemEntity toEntity() {
    return RentalItemEntity(
      id: id,
      vehicleName: vehicleName,
      vehicleImage: vehicleImage,
      stationName: stationName,
      status: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      paymentUrl: paymentUrl,
    );
  }
}
