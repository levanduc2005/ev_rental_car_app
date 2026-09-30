// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) =>
    _VehicleModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: json['status'] as String? ?? 'AVAILABLE',
      category: json['category'] as String?,
      brand: json['brand'] as String,
      plateNumber: json['plateNumber'] as String?,
      seats: (json['seats'] as num?)?.toInt() ?? 4,
      pricePer4Hours: (json['pricePer4Hours'] as num?)?.toDouble(),
      pricePer8Hours: (json['pricePer8Hours'] as num?)?.toDouble(),
      pricePer12Hours: (json['pricePer12Hours'] as num?)?.toDouble(),
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble(),
      priceRate: (json['priceRate'] as num?)?.toDouble() ?? 0.0,
      hourRate: (json['hourRate'] as num?)?.toDouble() ?? 0.0,
      consumptionRate: (json['consumptionRate'] as num?)?.toDouble(),
      batteryCapacity: (json['batteryCapacity'] as num?)?.toDouble(),
      batteryLevel: (json['batteryLevel'] as num?)?.toInt() ?? 0,
      station: json['station'] == null
          ? null
          : StationModel.fromJson(json['station'] as Map<String, dynamic>),
      stationName: json['stationName'] as String?,
      main: json['main'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      point: (json['point'] as num?)?.toInt() ?? 5,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      depositFee: (json['depositFee'] as num?)?.toDouble(),
      holdFee: (json['holdFee'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleModelToJson(_VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'category': instance.category,
      'brand': instance.brand,
      'plateNumber': instance.plateNumber,
      'seats': instance.seats,
      'pricePer4Hours': instance.pricePer4Hours,
      'pricePer8Hours': instance.pricePer8Hours,
      'pricePer12Hours': instance.pricePer12Hours,
      'pricePerDay': instance.pricePerDay,
      'priceRate': instance.priceRate,
      'hourRate': instance.hourRate,
      'consumptionRate': instance.consumptionRate,
      'batteryCapacity': instance.batteryCapacity,
      'batteryLevel': instance.batteryLevel,
      'station': instance.station,
      'stationName': instance.stationName,
      'main': instance.main,
      'images': instance.images,
      'description': instance.description,
      'point': instance.point,
      'distanceKm': instance.distanceKm,
      'depositFee': instance.depositFee,
      'holdFee': instance.holdFee,
    };
