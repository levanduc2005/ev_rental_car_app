// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokensModel _$AuthTokensModelFromJson(Map<String, dynamic> json) =>
    _AuthTokensModel(
      accessToken: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuthTokensModelToJson(_AuthTokensModel instance) =>
    <String, dynamic>{
      'token': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
