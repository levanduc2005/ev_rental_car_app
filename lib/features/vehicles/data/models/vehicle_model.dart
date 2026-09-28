import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
abstract class VehicleModel with _$VehicleModel {
  const factory VehicleModel({
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
    String? stationName,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  factory VehicleModel.fromBackendJson(Map<String, dynamic> json) {
    // 1. Phân tích ảnh chính và danh sách ảnh
    List<String> imgList = [];
    if (json['images'] is List) {
      for (final img in json['images'] as List) {
        if (img is Map<String, dynamic> && img['url'] is String) {
          imgList.add(img['url'] as String);
        } else if (img is String && img.isNotEmpty) {
          imgList.add(img);
        }
      }
    }

    const fallbackImg =
        'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1000&auto=format&fit=crop';
    final mainImg = json['main'] as String?;
    final primaryImg = (mainImg != null && mainImg.isNotEmpty)
        ? mainImg
        : (imgList.isNotEmpty ? imgList.first : fallbackImg);

    if (imgList.isEmpty) {
      imgList = [primaryImg];
    }

    // 2. Phân tích địa điểm từ trạm
    String loc = 'Thành Phố Thủ Đức';
    String? stName;
    if (json['station'] is Map<String, dynamic>) {
      final st = json['station'] as Map<String, dynamic>;
      loc = st['address'] as String? ?? st['name'] as String? ?? loc;
      stName = st['name'] as String?;
    } else if (json['stationName'] != null) {
      stName = json['stationName'] as String?;
    }

    // 3. Phân tích giá cả & Đơn vị theo số giờ thuê từ backend
    final pDay =
        (json['pricePerDay'] as num?)?.toDouble() ??
        (json['priceRate'] as num?)?.toDouble() ??
        1560000.0;
    final defaultDailyK = (pDay / 1000).round();

    final p4h =
        (json['pricePer4Hours'] as num?)?.toDouble() ??
        (defaultDailyK * 1000 * 0.45).roundToDouble();
    final p8h =
        (json['pricePer8Hours'] as num?)?.toDouble() ??
        (defaultDailyK * 1000 * 0.70).roundToDouble();
    final p12h =
        (json['pricePer12Hours'] as num?)?.toDouble() ??
        (defaultDailyK * 1000 * 0.85).roundToDouble();

    final hourRate = (json['hourRate'] as num?)?.toInt();
    final priceRate = (json['priceRate'] as num?)?.toDouble();

    final double activePrice;
    final String activeUnit;
    final String activeDuration;

    if (priceRate != null && hourRate != null && hourRate < 24) {
      activePrice = priceRate;
      activeUnit = '$hourRate giờ';
      activeDuration = '≈ $hourRate giờ';
    } else {
      activePrice = priceRate ?? pDay;
      activeUnit = 'ngày';
      activeDuration = '≈ 24 giờ';
    }
    final saleK = (activePrice / 1000).round();
    final origK = (saleK * 1.15).round();

    // 4. Nhiên liệu / Pin
    final batteryLvl = (json['batteryLevel'] as num?)?.toInt();
    final isEv = batteryLvl != null || json['batteryCapacity'] != null;
    final fuel = isEv ? 'Điện (${batteryLvl ?? 100}% Pin)' : 'Xăng';

    // 5. Phân khúc & Hạng sang
    final brandStr = (json['brand'] ?? '').toString().toUpperCase();
    final catStr = (json['category'] ?? '').toString().toUpperCase();
    final isLux =
        brandStr.contains('MERCEDES') ||
        brandStr.contains('BMW') ||
        brandStr.contains('AUDI') ||
        brandStr.contains('LEXUS') ||
        catStr.contains('SUV');

    final deposit = (json['depositFee'] as num?)?.toDouble() ?? 3000000.0;

    String formatVnd(double val) {
      final str = val.round().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
      return '$strđ';
    }

    num? holdFeeNum;
    final rawHold =
        json['holdFee'] ?? json['holdFeeValue'] ?? json['holdingDeposit'];
    if (rawHold is num) {
      holdFeeNum = rawHold;
    } else if (rawHold is String) {
      final cleaned = rawHold.replaceAll(RegExp(r'[^0-9.]'), '');
      holdFeeNum = num.tryParse(cleaned);
    }
    final holdFeeVal = holdFeeNum?.toDouble() ?? 5000.0;

    return VehicleModel(
      id: (json['id'] ?? '').toString(),
      name: json['name'] as String? ?? 'Xe điện E-Motion',
      location: loc,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 11.9,
      originalPriceK: origK,
      salePriceK: saleK,
      priceUnit: activeUnit,
      estimatedDuration: activeDuration,
      viewingCount: (json['point'] as num?)?.toInt() ?? 4,
      seats: (json['seats'] as num?)?.toInt() ?? 5,
      transmission: 'Số tự động',
      fuelType: fuel,
      imageUrl: primaryImg,
      discountText: 'Giảm 12%',
      deliveryType: 'Gặp chủ xe',
      isLuxury: isLux,
      luxuryTag: isLux ? 'Xế xịn' : 'Phổ biến',
      consumption: json['consumptionRate'] != null
          ? '${json['consumptionRate']} ${isEv ? 'kWh' : 'L'}/100km'
          : '6.3L / 100km',
      description:
          json['description'] as String? ??
          'Xe được kiểm định kỹ thuật định kỳ, bảo dưỡng chính hãng, đầy đủ bảo hiểm và sẵn sàng di chuyển.',
      imageUrls: imgList,
      rentalFee: formatVnd(pDay * 2.18),
      insuranceFee: '132.821đ',
      discountAmount: '-287.000đ',
      vatAmount: '257.582đ',
      totalRental: formatVnd(pDay * 2.18 + 132821 - 287000 + 257582),
      holdingDeposit: formatVnd(holdFeeVal),
      collateralDeposit: formatVnd(deposit),
      pricePer4Hours: p4h,
      pricePer8Hours: p8h,
      pricePer12Hours: p12h,
      pricePerDay: pDay,
      stationName: stName,
    );
  }
}

extension VehicleModelX on VehicleModel {
  VehicleEntity toEntity() => VehicleEntity(
    id: id,
    name: name,
    location: location,
    distanceKm: distanceKm,
    originalPriceK: originalPriceK,
    salePriceK: salePriceK,
    priceUnit: priceUnit,
    estimatedDuration: estimatedDuration,
    viewingCount: viewingCount,
    seats: seats,
    transmission: transmission,
    fuelType: fuelType,
    imageUrl: imageUrl,
    discountText: discountText,
    deliveryType: deliveryType,
    isLuxury: isLuxury,
    luxuryTag: luxuryTag,
    consumption: consumption,
    description: description,
    imageUrls: imageUrls,
    rentalFee: rentalFee,
    insuranceFee: insuranceFee,
    discountAmount: discountAmount,
    vatAmount: vatAmount,
    totalRental: totalRental,
    holdingDeposit: holdingDeposit,
    collateralDeposit: collateralDeposit,
    pricePer4Hours: pricePer4Hours,
    pricePer8Hours: pricePer8Hours,
    pricePer12Hours: pricePer12Hours,
    pricePerDay: pricePerDay,
    stationName: stationName,
  );
}
