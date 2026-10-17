import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';

part 'active_rental_model.freezed.dart';
part 'active_rental_model.g.dart';

@freezed
abstract class ActiveRentalModel with _$ActiveRentalModel {
  const factory ActiveRentalModel({
    required int id,
    @Default('PENDING') String status,
    required DateTime startTime,
    required DateTime endTime,
    @Default(0.0) double rentFee,
    @Default(0) int discountPoint,
    @Default(0) int vehicleId,
    @Default('Xe điện E-Motion') String vehicleName,
    @Default('E-MOTION') String vehicleBrand,
    @Default('') String vehiclePlate,
    @Default('') String vehicleImageUrl,
    @Default(0) int batteryLevel,
    double? batteryCapacity,
    String? stationName,
    String? stationAddress,
    double? stationLat,
    double? stationLng,
    String? contractStatus,
    String? contractUrl,
    double? rentalDeposit,
    String? userEmail,
  }) = _ActiveRentalModel;

  const ActiveRentalModel._();

  factory ActiveRentalModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveRentalModelFromJson(json);

  /// Mapper thông minh phân tích JSON thực tế trả về từ Spring Boot /api/rentals/me/details/{id}
  factory ActiveRentalModel.fromBackendJson(Map<String, dynamic> json) {
    final v = json['vehicle'] as Map<String, dynamic>?;
    final st = v?['station'] as Map<String, dynamic>?;
    final dep = json['rentalDeposit'] as Map<String, dynamic>?;

    // Phân tích ảnh xe
    String imgUrl = '';
    final main = v?['main'] as String?;
    if (main != null && main.isNotEmpty) {
      imgUrl = main;
    } else if (v?['images'] is List) {
      final imgList = v!['images'] as List;
      if (imgList.isNotEmpty) {
        final first = imgList.first;
        if (first is Map<String, dynamic> && first['url'] is String) {
          imgUrl = first['url'] as String;
        } else if (first is String) {
          imgUrl = first;
        }
      }
    }

    DateTime parseDt(dynamic val, DateTime fallback) {
      if (val == null) return fallback;
      if (val is String) {
        return DateTime.tryParse(val) ?? fallback;
      }
      return fallback;
    }

    final now = DateTime.now();

    return ActiveRentalModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'PENDING',
      startTime: parseDt(json['startTime'], now),
      endTime: parseDt(json['endTime'], now.add(const Duration(hours: 4))),
      rentFee: (json['rentFee'] as num?)?.toDouble() ?? 0.0,
      discountPoint: (json['discountPoint'] as num?)?.toInt() ?? 0,
      vehicleId: (v?['id'] as num?)?.toInt() ?? 0,
      vehicleName: v?['name'] as String? ?? 'Xe điện E-Motion',
      vehicleBrand: (v?['brand'] ?? 'E-MOTION').toString().toUpperCase(),
      vehiclePlate: v?['plateNumber'] as String? ?? '',
      vehicleImageUrl: imgUrl,
      batteryLevel: (v?['batteryLevel'] as num?)?.toInt() ?? 0,
      batteryCapacity: (v?['batteryCapacity'] as num?)?.toDouble(),
      stationName: st?['name'] as String?,
      stationAddress: st?['address'] as String?,
      stationLat: (st?['latitude'] as num?)?.toDouble(),
      stationLng: (st?['longitude'] as num?)?.toDouble(),
      contractStatus: json['contractStatus']?.toString(),
      contractUrl: json['contractUrl'] as String?,
      rentalDeposit: (dep?['amount'] as num?)?.toDouble(),
      userEmail: json['userEmail'] as String?,
    );
  }

  ActiveRentalEntity toEntity() {
    return ActiveRentalEntity(
      id: id,
      status: status,
      startTime: startTime,
      endTime: endTime,
      rentFee: rentFee,
      discountPoint: discountPoint,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      vehicleBrand: vehicleBrand,
      vehiclePlate: vehiclePlate,
      vehicleImageUrl: vehicleImageUrl,
      batteryLevel: batteryLevel,
      batteryCapacity: batteryCapacity,
      stationName: stationName,
      stationAddress: stationAddress,
      stationLat: stationLat,
      stationLng: stationLng,
      contractStatus: contractStatus,
      contractUrl: contractUrl,
      rentalDeposit: rentalDeposit,
      userEmail: userEmail,
    );
  }
}
