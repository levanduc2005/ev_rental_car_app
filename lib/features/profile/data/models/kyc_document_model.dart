import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

part 'kyc_document_model.freezed.dart';
part 'kyc_document_model.g.dart';

@freezed
abstract class KycDocumentModel with _$KycDocumentModel {
  const factory KycDocumentModel({
    required int id,
    required String imgUrl,
    required String type,
    required String number,
    String? email,
    String? licenseClass,
    String? expiryDate,
    String? status,
    String? rejectReason,
  }) = _KycDocumentModel;

  factory KycDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$KycDocumentModelFromJson(json);
}

extension KycDocumentModelX on KycDocumentModel {
  KycDocumentEntity toEntity() {
    final docType = type.toUpperCase() == 'LICENSE'
        ? DocumentType.license
        : DocumentType.cccd;

    KycStatus kycStatus = KycStatus.approved;
    if (status != null) {
      switch (status!.toUpperCase()) {
        case 'APPROVED':
          kycStatus = KycStatus.approved;
        case 'PENDING':
          kycStatus = KycStatus.pending;
        case 'REJECTED':
          kycStatus = KycStatus.rejected;
        default:
          kycStatus = KycStatus.approved;
      }
    }

    DateTime? parsedExpiry;
    if (expiryDate != null && expiryDate!.isNotEmpty) {
      parsedExpiry = DateTime.tryParse(expiryDate!);
    }

    return KycDocumentEntity(
      id: id,
      imgUrl: imgUrl,
      type: docType,
      number: number,
      email: email,
      licenseClass: licenseClass,
      expiryDate: parsedExpiry,
      status: kycStatus,
      rejectReason: rejectReason,
    );
  }
}
