// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'RENTER',
      point: (json['point'] as num?)?.toInt() ?? 0,
      blocked: json['blocked'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      documents:
          (json['documents'] as List<dynamic>?)
              ?.map((e) => KycDocumentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'role': instance.role,
      'point': instance.point,
      'blocked': instance.blocked,
      'createdAt': instance.createdAt,
      'avatarUrl': instance.avatarUrl,
      'documents': instance.documents,
    };
