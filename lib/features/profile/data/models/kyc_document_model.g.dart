// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KycDocumentModel _$KycDocumentModelFromJson(Map<String, dynamic> json) =>
    _KycDocumentModel(
      id: (json['id'] as num).toInt(),
      imgUrl: json['imgUrl'] as String,
      type: json['type'] as String,
      number: json['number'] as String,
      email: json['email'] as String?,
      licenseClass: json['licenseClass'] as String?,
      expiryDate: json['expiryDate'] as String?,
      status: json['status'] as String?,
      rejectReason: json['rejectReason'] as String?,
    );

Map<String, dynamic> _$KycDocumentModelToJson(_KycDocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imgUrl': instance.imgUrl,
      'type': instance.type,
      'number': instance.number,
      'email': instance.email,
      'licenseClass': instance.licenseClass,
      'expiryDate': instance.expiryDate,
      'status': instance.status,
      'rejectReason': instance.rejectReason,
    };
