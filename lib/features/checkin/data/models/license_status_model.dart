import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';

class LicenseStatusModel extends LicenseStatusEntity {
  const LicenseStatusModel({
    required super.userId,
    required super.licenseStatus,
    super.licenseNumber,
    super.licenseExpiryDate,
    super.rejectReason,
  });

  factory LicenseStatusModel.fromJson(Map<String, dynamic> json) {
    return LicenseStatusModel(
      userId: json['userId'] as int? ?? 0,
      licenseStatus:
          (json['licenseStatus'] as String?)?.toUpperCase() ?? 'NOT_SUBMITTED',
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiryDate: json['licenseExpiryDate'] as String?,
      rejectReason: json['rejectReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'licenseStatus': licenseStatus,
    'licenseNumber': licenseNumber,
    'licenseExpiryDate': licenseExpiryDate,
    'rejectReason': rejectReason,
  };
}
