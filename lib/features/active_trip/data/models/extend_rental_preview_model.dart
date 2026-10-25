import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';

class ExtendRentalPreviewModel {
  const ExtendRentalPreviewModel({
    required this.additionalFee,
    required this.newRentFee,
    required this.currentRentFee,
    required this.additionalHours,
    required this.newReturnTime,
  });

  final double additionalFee;
  final double newRentFee;
  final double currentRentFee;
  final int additionalHours;
  final DateTime newReturnTime;

  factory ExtendRentalPreviewModel.fromJson(Map<String, dynamic> json) {
    return ExtendRentalPreviewModel(
      additionalFee: (json['additionalFee'] as num?)?.toDouble() ?? 0.0,
      newRentFee: (json['newRentFee'] as num?)?.toDouble() ?? 0.0,
      currentRentFee: (json['currentRentFee'] as num?)?.toDouble() ?? 0.0,
      additionalHours: (json['additionalHours'] as num?)?.toInt() ?? 0,
      newReturnTime: json['newReturnTime'] != null
          ? DateTime.tryParse(json['newReturnTime'].toString()) ??
                DateTime.now()
          : DateTime.now(),
    );
  }

  ExtendRentalPreviewEntity toEntity() => ExtendRentalPreviewEntity(
    additionalFee: additionalFee,
    newRentFee: newRentFee,
    currentRentFee: currentRentFee,
    additionalHours: additionalHours,
    newReturnTime: newReturnTime,
  );
}
