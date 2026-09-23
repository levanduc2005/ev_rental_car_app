import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_document_entity.freezed.dart';

/// Loại giấy tờ xác thực KYC
enum DocumentType { license, cccd }

/// Trạng thái xác thực hồ sơ KYC
enum KycStatus { none, pending, approved, rejected }

@freezed
abstract class KycDocumentEntity with _$KycDocumentEntity {
  const factory KycDocumentEntity({
    required int id,
    required String imgUrl,
    required DocumentType type,
    required String number,
    String? email,
    String? licenseClass,
    DateTime? expiryDate,
    @Default(KycStatus.none) KycStatus status,
    String? rejectReason,
  }) = _KycDocumentEntity;
}
