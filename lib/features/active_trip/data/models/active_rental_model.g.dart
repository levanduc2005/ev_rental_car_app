// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_rental_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveRentalModel _$ActiveRentalModelFromJson(Map<String, dynamic> json) =>
    _ActiveRentalModel(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String? ?? 'PENDING',
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      rentFee: (json['rentFee'] as num?)?.toDouble() ?? 0.0,
      discountPoint: (json['discountPoint'] as num?)?.toInt() ?? 0,
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      vehicleName: json['vehicleName'] as String? ?? 'Xe điện E-Motion',
      vehicleBrand: json['vehicleBrand'] as String? ?? 'E-MOTION',
      vehiclePlate: json['vehiclePlate'] as String? ?? '',
      vehicleImageUrl: json['vehicleImageUrl'] as String? ?? '',
      batteryLevel: (json['batteryLevel'] as num?)?.toInt() ?? 0,
      batteryCapacity: (json['batteryCapacity'] as num?)?.toDouble(),
      stationName: json['stationName'] as String?,
      stationAddress: json['stationAddress'] as String?,
      stationLat: (json['stationLat'] as num?)?.toDouble(),
      stationLng: (json['stationLng'] as num?)?.toDouble(),
      contractStatus: json['contractStatus'] as String?,
      contractUrl: json['contractUrl'] as String?,
      rentalDeposit: (json['rentalDeposit'] as num?)?.toDouble(),
      userEmail: json['userEmail'] as String?,
    );

Map<String, dynamic> _$ActiveRentalModelToJson(_ActiveRentalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'rentFee': instance.rentFee,
      'discountPoint': instance.discountPoint,
      'vehicleId': instance.vehicleId,
      'vehicleName': instance.vehicleName,
      'vehicleBrand': instance.vehicleBrand,
      'vehiclePlate': instance.vehiclePlate,
      'vehicleImageUrl': instance.vehicleImageUrl,
      'batteryLevel': instance.batteryLevel,
      'batteryCapacity': instance.batteryCapacity,
      'stationName': instance.stationName,
      'stationAddress': instance.stationAddress,
      'stationLat': instance.stationLat,
      'stationLng': instance.stationLng,
      'contractStatus': instance.contractStatus,
      'contractUrl': instance.contractUrl,
      'rentalDeposit': instance.rentalDeposit,
      'userEmail': instance.userEmail,
    };
