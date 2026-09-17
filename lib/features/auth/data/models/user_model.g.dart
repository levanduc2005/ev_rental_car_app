// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  email: json['email'] as String,
  fullName: json['fullName'] as String,
  role: json['role'] as String?,
  phone: json['phone'] as String?,
  point: (json['point'] as num?)?.toInt() ?? 0,
  blocked: json['blocked'] as bool? ?? false,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'role': instance.role,
      'phone': instance.phone,
      'point': instance.point,
      'blocked': instance.blocked,
      'createdAt': instance.createdAt,
    };
