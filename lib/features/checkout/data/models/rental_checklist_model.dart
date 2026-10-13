import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';

class RentalChecklistModel extends RentalChecklistEntity {
  const RentalChecklistModel({
    required super.id,
    required super.type,
    required super.currentBattery,
    super.fee = 0.0,
    super.img = '',
    super.createdAt,
  });

  factory RentalChecklistModel.fromJson(Map<String, dynamic> json) {
    return RentalChecklistModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? 'CHECK_IN',
      currentBattery: (json['currentBattery'] as num?)?.toDouble() ?? 0.0,
      fee: (json['fee'] as num?)?.toDouble() ??
          (json['penaltyFee'] as num?)?.toDouble() ??
          0.0,
      img: json['img'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
