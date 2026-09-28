import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_entity.freezed.dart';

@freezed
abstract class VehicleEntity with _$VehicleEntity {
  const factory VehicleEntity({
    required String id,
    required String name,
    required String location,
    required double distanceKm,
    required int originalPriceK,
    required int salePriceK,
    required String priceUnit,
    required String estimatedDuration,
    required int viewingCount,
    required int seats,
    required String transmission,
    required String fuelType,
    required String imageUrl,
    required String discountText,
    required String deliveryType,
    required bool isLuxury,
    required String luxuryTag,
    String? consumption,
    String? description,
    List<String>? imageUrls,
    String? rentalFee,
    String? insuranceFee,
    String? discountAmount,
    String? vatAmount,
    String? totalRental,
    String? holdingDeposit,
    String? collateralDeposit,
    double? pricePer4Hours,
    double? pricePer8Hours,
    double? pricePer12Hours,
    double? pricePerDay,
  }) = _VehicleEntity;
}
