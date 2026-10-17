import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';

class VehicleLogEntity {
  const VehicleLogEntity({
    this.id,
    this.repairItems = const [],
    this.cost = 0.0,
    this.imgs = const [],
    this.createdAt,
    this.vehicleId,
    this.staffId,
    this.rentalId,
  });

  final int? id;
  final List<VehicleDamageItemEntity> repairItems;
  final double cost;
  final List<String> imgs;
  final DateTime? createdAt;
  final int? vehicleId;
  final int? staffId;
  final int? rentalId;

  bool get hasDamages => repairItems.isNotEmpty && cost > 0;
}
