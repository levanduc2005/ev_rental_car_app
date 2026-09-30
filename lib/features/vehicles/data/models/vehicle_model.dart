import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/vehicles/data/models/station_model.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

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
    String? stationName,
    String? main,
    List<String>? images,
    String? description,
    @Default(5) int point,
    @Default(0.0) double distanceKm,
    double? depositFee,
    double? holdFee,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  factory VehicleModel.fromBackendJson(Map<String, dynamic> json) {
    // 1. Phân tích ảnh chính và danh sách ảnh
    final List<String> imgList = [];
    if (json['images'] is List) {
      for (final img in json['images'] as List) {
        if (img is Map<String, dynamic> && img['url'] is String) {
          imgList.add(img['url'] as String);
        } else if (img is String && img.isNotEmpty) {
          imgList.add(img);
        }
      }
    }

    final mainImg = json['main'] as String?;
    final primaryImg = (mainImg != null && mainImg.isNotEmpty)
        ? mainImg
        : (imgList.isNotEmpty ? imgList.first : null);

    if (primaryImg != null && !imgList.contains(primaryImg)) {
      imgList.insert(0, primaryImg);
    }

    // 2. Parse ID dạng int
    final rawId = json['id'];
    final int parsedId;
    if (rawId is num) {
      parsedId = rawId.toInt();
    } else {
      parsedId = int.tryParse(rawId?.toString() ?? '') ?? 0;
    }

    // 3. Parse Station
    StationModel? parsedStation;
    String? stName;
    if (json['station'] is Map<String, dynamic>) {
      parsedStation = StationModel.fromJson(
        json['station'] as Map<String, dynamic>,
      );
      stName = parsedStation.name;
    } else if (json['stationName'] is String) {
      stName = json['stationName'] as String?;
    }

    // 4. Parse cọc và giữ chỗ
    num? holdFeeNum;
    final rawHold =
        json['holdFee'] ?? json['holdFeeValue'] ?? json['holdingDeposit'];
    if (rawHold is num) {
      holdFeeNum = rawHold;
    } else if (rawHold is String) {
      final cleaned = rawHold.replaceAll(RegExp(r'[^0-9.]'), '');
      holdFeeNum = num.tryParse(cleaned);
    }

    final depFee = (json['depositFee'] as num?)?.toDouble() ?? 3000000.0;
    final hFee = holdFeeNum?.toDouble() ?? 5000.0;

    return VehicleModel(
      id: parsedId,
      name: json['name'] as String? ?? 'Xe điện E-Motion',
      status: json['status'] as String? ?? 'AVAILABLE',
      category: json['category'] as String?,
      brand: (json['brand'] ?? 'E-MOTION').toString().toUpperCase(),
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
      station: parsedStation,
      stationName: stName,
      main: primaryImg,
      images: imgList.isNotEmpty ? imgList : null,
      description: json['description'] as String?,
      point: (json['point'] as num?)?.toInt() ?? 5,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      depositFee: depFee,
      holdFee: hFee,
    );
  }
}

extension VehicleModelX on VehicleModel {
  VehicleEntity toEntity() {
    final p4h =
        pricePer4Hours ??
        (hourRate > 1000 ? hourRate : (priceRate > 0 ? priceRate * 0.45 : 0.0));
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
      stationName: stationName ?? station?.name,
      mainImage: main,
      imageUrls: images,
      description: description,
      point: point,
      distanceKm: distanceKm,
      depositFee: depositFee,
      holdFee: holdFee,
    );
  }
}
