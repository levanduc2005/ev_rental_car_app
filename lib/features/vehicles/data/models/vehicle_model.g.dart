// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) =>
    _VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      originalPriceK: (json['originalPriceK'] as num).toInt(),
      salePriceK: (json['salePriceK'] as num).toInt(),
      priceUnit: json['priceUnit'] as String,
      estimatedDuration: json['estimatedDuration'] as String,
      viewingCount: (json['viewingCount'] as num).toInt(),
      seats: (json['seats'] as num).toInt(),
      transmission: json['transmission'] as String,
      fuelType: json['fuelType'] as String,
      imageUrl: json['imageUrl'] as String,
      discountText: json['discountText'] as String,
      deliveryType: json['deliveryType'] as String,
      isLuxury: json['isLuxury'] as bool,
      luxuryTag: json['luxuryTag'] as String,
      consumption: json['consumption'] as String?,
      description: json['description'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rentalFee: json['rentalFee'] as String?,
      insuranceFee: json['insuranceFee'] as String?,
      discountAmount: json['discountAmount'] as String?,
      vatAmount: json['vatAmount'] as String?,
      totalRental: json['totalRental'] as String?,
      holdingDeposit: json['holdingDeposit'] as String?,
      collateralDeposit: json['collateralDeposit'] as String?,
      pricePer4Hours: (json['pricePer4Hours'] as num?)?.toDouble(),
      pricePer8Hours: (json['pricePer8Hours'] as num?)?.toDouble(),
      pricePer12Hours: (json['pricePer12Hours'] as num?)?.toDouble(),
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehicleModelToJson(_VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'distanceKm': instance.distanceKm,
      'originalPriceK': instance.originalPriceK,
      'salePriceK': instance.salePriceK,
      'priceUnit': instance.priceUnit,
      'estimatedDuration': instance.estimatedDuration,
      'viewingCount': instance.viewingCount,
      'seats': instance.seats,
      'transmission': instance.transmission,
      'fuelType': instance.fuelType,
      'imageUrl': instance.imageUrl,
      'discountText': instance.discountText,
      'deliveryType': instance.deliveryType,
      'isLuxury': instance.isLuxury,
      'luxuryTag': instance.luxuryTag,
      'consumption': instance.consumption,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'rentalFee': instance.rentalFee,
      'insuranceFee': instance.insuranceFee,
      'discountAmount': instance.discountAmount,
      'vatAmount': instance.vatAmount,
      'totalRental': instance.totalRental,
      'holdingDeposit': instance.holdingDeposit,
      'collateralDeposit': instance.collateralDeposit,
      'pricePer4Hours': instance.pricePer4Hours,
      'pricePer8Hours': instance.pricePer8Hours,
      'pricePer12Hours': instance.pricePer12Hours,
      'pricePerDay': instance.pricePerDay,
    };
