class StaffStationEntity {
  const StaffStationEntity({
    required this.id,
    required this.name,
    this.address = '',
    this.city = '',
    this.latitude,
    this.longitude,
    this.status = 'ACTIVE',
  });

  final int id;
  final String name;
  final String address;
  final String city;
  final double? latitude;
  final double? longitude;
  final String status;

  bool get isActive => status.toUpperCase() == 'ACTIVE';
}

class StaffProfileEntity {
  const StaffProfileEntity({
    required this.email,
    required this.fullName,
    this.phone = '',
    required this.role,
    required this.staffId,
    this.station,
  });

  final String email;
  final String fullName;
  final String phone;
  final String role;
  final int staffId;
  final StaffStationEntity? station;

  bool get isStaff =>
      role.toUpperCase() == 'ROLE_STAFF' || role.toUpperCase() == 'ROLE_ADMIN';
}
