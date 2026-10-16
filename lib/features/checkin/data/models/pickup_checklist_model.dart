import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

class PickupChecklistModel extends PickupChecklistEntity {
  const PickupChecklistModel({
    required super.checklistId,
    required super.rentalId,
    required super.type,
    required super.odometer,
    required super.batteryPercentage,
    super.hasPortableCharger,
    super.hasTireRepairKit,
    super.hasChargingCard,
    super.photoCount,
    super.createdAt,
  });

  factory PickupChecklistModel.fromJson(Map<String, dynamic> json) {
    return PickupChecklistModel(
      checklistId: json['checklistId'] as int? ?? json['id'] as int? ?? 0,
      rentalId: json['rentalId'] as int? ?? 0,
      type:
          json['type'] as String? ??
          json['checklistType'] as String? ??
          'PICKUP',
      odometer: json['odometer'] as int? ?? 0,
      batteryPercentage: json['batteryPercentage'] as int? ?? 0,
      hasPortableCharger: json['hasPortableCharger'] as bool? ?? true,
      hasTireRepairKit: json['hasTireRepairKit'] as bool? ?? true,
      hasChargingCard: json['hasChargingCard'] as bool? ?? true,
      photoCount: json['photoCount'] as int? ?? 4,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'checklistId': checklistId,
    'rentalId': rentalId,
    'type': type,
    'odometer': odometer,
    'batteryPercentage': batteryPercentage,
    'hasPortableCharger': hasPortableCharger,
    'hasTireRepairKit': hasTireRepairKit,
    'hasChargingCard': hasChargingCard,
    'photoCount': photoCount,
    'createdAt': createdAt?.toIso8601String(),
  };
}
