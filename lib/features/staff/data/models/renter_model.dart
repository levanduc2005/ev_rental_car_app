import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';

class RenterModel extends RenterEntity {
  const RenterModel({
    required super.email,
    required super.fullName,
    super.phone,
    super.point = 0,
    super.blocked = false,
    super.role,
  });

  factory RenterModel.fromJson(Map<String, dynamic> json) {
    return RenterModel(
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? 'Khách hàng',
      phone: json['phone'] as String?,
      point: json['point'] as int? ?? 0,
      blocked: json['blocked'] as bool? ?? false,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'fullName': fullName,
    'phone': phone,
    'point': point,
    'blocked': blocked,
    'role': role,
  };

  RenterEntity toEntity() => RenterEntity(
    email: email,
    fullName: fullName,
    phone: phone,
    point: point,
    blocked: blocked,
    role: role,
  );
}
