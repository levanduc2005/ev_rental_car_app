import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/home/data/models/station_model.dart';
import 'package:rental_car/features/home/domain/entities/vehicle_entity.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
abstract class VehicleModel with _$VehicleModel {
  const factory VehicleModel({
    required int id,
    required String name,
    @Default('AVAILABLE') String status,
    String? category,
    required String brand,
    String? plateNumber,
    @Default(4) int seats,
    double? pricePer4Hours,
    double? pricePer8Hours,
    double? pricePer12Hours,
    double? pricePerDay,
    @Default(0.0) double priceRate,
    @Default(0.0) double hourRate,
    double? consumptionRate,
    double? batteryCapacity,
    @Default(0) int batteryLevel,
    StationModel? station,
    String? main,
    @Default(5) int point,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
}

extension VehicleModelX on VehicleModel {
  VehicleEntity toEntity() {
    final p4h =
        pricePer4Hours ??
        (hourRate > 1000 ? hourRate : (priceRate > 0 ? priceRate : 0.0));
    final p8h = pricePer8Hours ?? (p4h > 0 ? p4h * 1.4 : 0.0);
    final p12h = pricePer12Hours ?? (p4h > 0 ? p4h * 1.6 : 0.0);
    final pDay =
        pricePerDay ??
        (priceRate > p4h ? priceRate : (p4h > 0 ? p4h * 2.0 : 0.0));

    return VehicleEntity(
      id: id,
      name: name,
      status: status,
      category: category,
      brand: brand,
      plateNumber: plateNumber,
      seats: seats,
      pricePer4Hours: p4h,
      pricePer8Hours: p8h,
      pricePer12Hours: p12h,
      pricePerDay: pDay,
      priceRate: priceRate,
      hourRate: hourRate,
      consumptionRate: consumptionRate,
      batteryCapacity: batteryCapacity,
      batteryLevel: batteryLevel,
      station: station?.toEntity(),
      mainImage: main,
      point: point,
    );
  }
}
