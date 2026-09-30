// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StationModel _$StationModelFromJson(Map<String, dynamic> json) =>
    _StationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      availableVehiclesCount: (json['availableVehiclesCount'] as num?)?.toInt(),
      totalSlots: (json['totalSlots'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StationModelToJson(_StationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'availableVehiclesCount': instance.availableVehiclesCount,
      'totalSlots': instance.totalSlots,
    };
