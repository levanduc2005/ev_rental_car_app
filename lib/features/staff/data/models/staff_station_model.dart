import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';

class StaffStationModel extends StaffStationEntity {
  const StaffStationModel({
    required super.id,
    required super.name,
    super.address,
    super.city,
    super.latitude,
    super.longitude,
    super.status,
  });

  factory StaffStationModel.fromJson(Map<String, dynamic> json) {
    return StaffStationModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Trạm sạc e-Motion',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
  };
}

class StaffProfileModel extends StaffProfileEntity {
  const StaffProfileModel({
    required super.email,
    required super.fullName,
    super.phone,
    required super.role,
    required super.staffId,
    super.station,
  });

  factory StaffProfileModel.fromJson(Map<String, dynamic> json) {
    StaffStationModel? stationModel;
    if (json['station'] is Map<String, dynamic>) {
      stationModel = StaffStationModel.fromJson(
        json['station'] as Map<String, dynamic>,
      );
    }

    return StaffProfileModel(
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? 'Nhân viên',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'ROLE_STAFF',
      staffId: json['staffId'] as int? ?? json['id'] as int? ?? 0,
      station: stationModel,
    );
  }
}
