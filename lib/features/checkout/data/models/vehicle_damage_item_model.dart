import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';

class VehicleDamageItemModel extends VehicleDamageItemEntity {
  const VehicleDamageItemModel({
    required super.description,
    required super.cost,
  });

  factory VehicleDamageItemModel.fromJson(Map<String, dynamic> json) {
    return VehicleDamageItemModel(
      description: json['description'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
