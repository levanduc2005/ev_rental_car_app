import 'package:rental_car/features/checkout/data/models/vehicle_damage_item_model.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';

class VehicleLogModel extends VehicleLogEntity {
  const VehicleLogModel({
    super.id,
    super.repairItems,
    super.cost,
    super.imgs,
    super.createdAt,
    super.vehicleId,
    super.staffId,
    super.rentalId,
  });

  factory VehicleLogModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['repairItems'];
    final items = <VehicleDamageItemModel>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(VehicleDamageItemModel.fromJson(item));
        }
      }
    }

    final rawImgs = json['imgs'] ?? json['images'];
    final imgsList = <String>[];
    if (rawImgs is List) {
      for (final img in rawImgs) {
        if (img != null) {
          imgsList.add(img.toString());
        }
      }
    } else if (rawImgs is String && rawImgs.isNotEmpty) {
      imgsList.addAll(rawImgs.split('|').where((s) => s.isNotEmpty));
    }

    final rawCost = json['cost'] ?? json['totalCost'];
    final costVal = (rawCost as num?)?.toDouble() ?? 0.0;

    return VehicleLogModel(
      id: (json['id'] as num? ?? json['logId'] as num?)?.toInt(),
      repairItems: items,
      cost: costVal,
      imgs: imgsList,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      staffId: (json['staffId'] as num?)?.toInt(),
      rentalId: (json['rentalId'] as num?)?.toInt(),
    );
  }
}
