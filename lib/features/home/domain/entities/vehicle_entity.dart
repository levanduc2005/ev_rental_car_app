import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';

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
    String? mainImage,
    @Default(5) int point,
  }) = _VehicleEntity;

  const VehicleEntity._();

  /// Kiểm tra xem có phải xe điện không
  bool get isElectric =>
      (batteryCapacity != null && batteryCapacity! > 0) ||
      batteryLevel > 0 ||
      brand.toUpperCase() == 'VINFAST' ||
      brand.toUpperCase() == 'TESLA' ||
      brand.toUpperCase() == 'BYD';

  /// Kiểm tra xem có phải phân khúc xe sang không (giá thuê theo ngày >= 1.500.000 VNĐ)
  bool get isLuxury => pricePerDay >= 1500000;

  /// Chuỗi hiển thị đánh giá (ví dụ: "4.9")
  double get rating => point > 0 ? point.toDouble() : 5.0;

  /// Chuỗi hiển thị địa chỉ trạm xe
  String get locationDisplay =>
      station != null ? '${station!.name}, ${station!.address}' : 'Hà Nội';

  /// Chuỗi hiển thị loại nhiên liệu
  String get fuelTypeDisplay => isElectric ? 'Điện' : 'Xăng';

  /// Format giá tiền dạng K (ví dụ: 300K, 1.500K)
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
}
