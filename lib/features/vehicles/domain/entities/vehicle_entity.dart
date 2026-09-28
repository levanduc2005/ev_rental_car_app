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

extension VehicleEntityPricingX on VehicleEntity {
  /// Lấy giá bán (đơn vị K: nghìn đồng) dựa theo số giờ thuê
  int priceKForDuration(int hours) {
    if (hours <= 4) {
      if (pricePer4Hours != null && pricePer4Hours! > 0) {
        return (pricePer4Hours! / 1000).round();
      }
      return (salePriceK * 0.45).round();
    } else if (hours <= 8) {
      if (pricePer8Hours != null && pricePer8Hours! > 0) {
        return (pricePer8Hours! / 1000).round();
      }
      return (salePriceK * 0.70).round();
    } else if (hours <= 12) {
      if (pricePer12Hours != null && pricePer12Hours! > 0) {
        return (pricePer12Hours! / 1000).round();
      }
      return (salePriceK * 0.85).round();
    } else if (hours <= 24) {
      if (pricePerDay != null && pricePerDay! > 0) {
        return (pricePerDay! / 1000).round();
      }
      return salePriceK;
    } else {
      // Thuê nhiều ngày
      final days = (hours / 24).ceil();
      final dailyK = (pricePerDay != null && pricePerDay! > 0)
          ? (pricePerDay! / 1000).round()
          : salePriceK;
      return dailyK * days;
    }
  }

  /// Giá gốc (trước khuyến mãi) tương ứng theo số giờ thuê
  int originalPriceKForDuration(int hours) {
    final sale = priceKForDuration(hours);
    return (sale * 1.15).round();
  }
}
