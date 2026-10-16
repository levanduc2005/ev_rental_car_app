import 'package:rental_car/features/checkout/data/models/vehicle_damage_item_model.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';

class RentalOverviewModel extends RentalOverviewEntity {
  const RentalOverviewModel({
    required super.rentalId,
    super.vehicleId,
    super.vehicleName,
    super.vehiclePlateNumber,
    super.stationName,
    super.stationAddress,
    super.stationLatitude,
    super.stationLongitude,
    super.checkListFee = 0.0,
    super.reservationDeposit = 0.0,
    super.rentalDeposit = 0.0,
    super.vehicleDamages = const [],
    super.vehicleDamageFee = 0.0,
    super.vehicleDamageImages = const [],
    super.refundEligible = true,
  });

  factory RentalOverviewModel.fromJson(Map<String, dynamic> json) {
    final rental = json['rentalResponse'] as Map<String, dynamic>?;
    final vehicle = rental?['vehicle'] as Map<String, dynamic>?;
    final station = rental?['station'] as Map<String, dynamic>?;

    final damagesRaw = json['vehicleDamages'];
    final damages = damagesRaw is List
        ? damagesRaw
              .whereType<Map<String, dynamic>>()
              .map(VehicleDamageItemModel.fromJson)
              .toList()
        : <VehicleDamageItemModel>[];

    final vl = rental?['vehicleLog'] as Map<String, dynamic>?;
    final imgsRaw = vl?['imgs'];
    final damageImgs = <String>[];
    if (imgsRaw is List) {
      for (final img in imgsRaw) {
        if (img != null && img.toString().isNotEmpty) {
          damageImgs.add(img.toString());
        }
      }
    }

    return RentalOverviewModel(
      rentalId: rental?['id'] as int? ?? 0,
      vehicleId: (vehicle?['id'] as num?)?.toInt(),
      vehicleName: vehicle?['name'] as String?,
      vehiclePlateNumber: vehicle?['plateNumber'] as String?,
      stationName: station?['name'] as String?,
      stationAddress: station?['address'] as String?,
      stationLatitude: (station?['latitude'] as num?)?.toDouble(),
      stationLongitude: (station?['longitude'] as num?)?.toDouble(),
      checkListFee: (json['checkListFee'] as num?)?.toDouble() ?? 0.0,
      reservationDeposit:
          (json['reservationDeposit'] as num?)?.toDouble() ?? 0.0,
      rentalDeposit: (json['rentalDeposit'] as num?)?.toDouble() ?? 0.0,
      vehicleDamages: damages,
      vehicleDamageFee: (json['vehicleDamageFee'] as num?)?.toDouble() ?? 0.0,
      vehicleDamageImages: damageImgs,
      refundEligible: json['refundEligible'] as bool? ?? true,
    );
  }
}
