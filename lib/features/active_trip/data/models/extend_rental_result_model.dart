import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';

class ExtendRentalResultModel {
  const ExtendRentalResultModel({required this.url, this.qrCode});

  final String url;
  final String? qrCode;

  factory ExtendRentalResultModel.fromJson(Map<String, dynamic> json) {
    return ExtendRentalResultModel(
      url: json['url'] as String? ?? '',
      qrCode: json['qrCode'] as String?,
    );
  }

  ExtendRentalResultEntity toEntity() =>
      ExtendRentalResultEntity(url: url, qrCode: qrCode);
}
