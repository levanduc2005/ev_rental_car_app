import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/vehicles/domain/entities/station_entity.dart';

part 'vehicle_entity.freezed.dart';

@freezed
abstract class VehicleEntity with _$VehicleEntity {
  const factory VehicleEntity({
    required int id,
    required String name,
    @Default('AVAILABLE') String status,
    String? category,
    required String brand,
    String? plateNumber,
    @Default(4) int seats,
    @Default(0.0) double pricePer4Hours,
    @Default(0.0) double pricePer8Hours,
    @Default(0.0) double pricePer12Hours,
    @Default(0.0) double pricePerDay,
    @Default(0.0) double priceRate,
    @Default(0.0) double hourRate,
    double? consumptionRate,
    double? batteryCapacity,
    @Default(0) int batteryLevel,
    StationEntity? station,
    String? stationName,
    String? mainImage,
    List<String>? imageUrls,
    String? description,
    @Default(5) int point,
    @Default(0.0) double distanceKm,
    double? depositFee,
    double? holdFee,
  }) = _VehicleEntity;

  const VehicleEntity._();

  /// Chuỗi ID dạng String tiện dụng khi truyền qua Router
  String get stringId => id.toString();

  /// Kiểm tra xem có phải xe điện không
  bool get isElectric =>
      (batteryCapacity != null && batteryCapacity! > 0) ||
      batteryLevel > 0 ||
      brand.toUpperCase() == 'VINFAST' ||
      brand.toUpperCase() == 'TESLA' ||
      brand.toUpperCase() == 'BYD';

  /// Kiểm tra xe phân khúc cao cấp / xe sang
  bool get isLuxury =>
      pricePerDay >= 1500000 ||
      priceRate >= 1500000 ||
      brand.toUpperCase().contains('MERCEDES') ||
      brand.toUpperCase().contains('BMW') ||
      brand.toUpperCase().contains('AUDI') ||
      brand.toUpperCase().contains('LEXUS');

  /// Điểm đánh giá dạng số thực (ví dụ 4.9, 5.0)
  double get rating => point > 0 ? point.toDouble() : 5.0;

  /// Hiển thị địa chỉ / trạm lấy xe
  String get locationDisplay => station != null
      ? '${station!.name}, ${station!.address}'
      : (stationName ?? 'Hà Nội');

  /// Alias cho location
  String get location => locationDisplay;

  /// Hiển thị loại nhiên liệu
  String get fuelTypeDisplay =>
      isElectric ? 'Điện ($batteryLevel% Pin)' : 'Xăng';

  /// Alias cho fuelType
  String get fuelType => fuelTypeDisplay;

  /// Ảnh chính của xe
  String get imageUrl =>
      mainImage ??
      (imageUrls != null && imageUrls!.isNotEmpty ? imageUrls!.first : '');

  String get transmission => 'Số tự động';
  String get deliveryType => 'Tự nhận xe';
  String get discountText => 'Giảm 12%';
  String get luxuryTag => isLuxury ? 'Xế xịn' : 'Phổ biến';
  int get viewingCount => point;

  String get consumption => consumptionRate != null
      ? '$consumptionRate ${isElectric ? 'kWh' : 'L'}/100km'
      : (isElectric ? '18 kWh / 100km' : '6.3L / 100km');

  /// Giá theo ngày (đơn vị K: nghìn đồng)
  int get salePriceK {
    if (pricePerDay > 0) return (pricePerDay / 1000).round();
    if (priceRate > 0) return (priceRate / 1000).round();
    return 1560;
  }

  /// Giá gốc dự kiến (trước khuyến mãi)
  int get originalPriceK => (salePriceK * 1.15).round();
  String get priceUnit => 'ngày';
  String get estimatedDuration => '≈ 24 giờ';

  /// Tiền cọc & Giữ chỗ
  double get effectiveDepositFee => depositFee ?? 3000000.0;
  double get effectiveHoldFee => holdFee ?? 5000.0;

  static String formatAmount(double amount) {
    if (amount <= 0) return '0K';
    final inThousands = (amount / 1000).round();
    if (inThousands >= 1000) {
      final millions = inThousands ~/ 1000;
      final remainder = (inThousands % 1000).toString().padLeft(3, '0');
      return '$millions.${remainder}K';
    }
    return '${inThousands}K';
  }

  static String formatVnd(double val) {
    final str = val.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '$strđ';
  }

  String get collateralDeposit => formatVnd(effectiveDepositFee);
  String get holdingDeposit => formatVnd(effectiveHoldFee);
  String get rentalFee =>
      formatVnd(pricePerDay > 0 ? pricePerDay * 2.18 : 3400000.0);
  String get insuranceFee => '132.821đ';
  String get discountAmount => '-287.000đ';
  String get vatAmount => '257.582đ';
  String get totalRental => formatVnd(
    (pricePerDay > 0 ? pricePerDay * 2.18 : 3400000.0) +
        132821 -
        287000 +
        257582,
  );

  /// Giá gói 4 tiếng
  String get formattedPrice4h =>
      formatAmount(pricePer4Hours > 0 ? pricePer4Hours : priceRate);

  /// Giá gói 8 tiếng
  String get formattedPrice8h => formatAmount(pricePer8Hours);

  /// Giá gói 12 tiếng
  String get formattedPrice12h => formatAmount(pricePer12Hours);

  /// Giá gói 1 ngày (24 tiếng)
  String get formattedPriceDay =>
      formatAmount(pricePerDay > 0 ? pricePerDay : (priceRate * 2.0));

  /// Alias cho giá 24h
  String get formattedPrice24h => formattedPriceDay;

  /// Lấy giá bán (đơn vị K: nghìn đồng) dựa theo số giờ thuê
  int priceKForDuration(int hours) {
    if (hours <= 4) {
      if (pricePer4Hours > 0) {
        return (pricePer4Hours / 1000).round();
      }
      return (salePriceK * 0.45).round();
    } else if (hours <= 8) {
      if (pricePer8Hours > 0) {
        return (pricePer8Hours / 1000).round();
      }
      return (salePriceK * 0.70).round();
    } else if (hours <= 12) {
      if (pricePer12Hours > 0) {
        return (pricePer12Hours / 1000).round();
      }
      return (salePriceK * 0.85).round();
    } else if (hours <= 24) {
      if (pricePerDay > 0) {
        return (pricePerDay / 1000).round();
      }
      return salePriceK;
    } else {
      final days = (hours / 24).ceil();
      final dailyK = pricePerDay > 0
          ? (pricePerDay / 1000).round()
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
