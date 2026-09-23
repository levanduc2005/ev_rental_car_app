import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

part 'user_profile_entity.freezed.dart';

@freezed
abstract class UserProfileEntity with _$UserProfileEntity {
  const factory UserProfileEntity({
    required String email,
    String? fullName,
    String? phone,
    @Default('RENTER') String role,
    @Default(0) int point,
    @Default(false) bool isBlocked,
    DateTime? createdAt,
    String? avatarUrl,
    @Default([]) List<KycDocumentEntity> documents,
  }) = _UserProfileEntity;

  const UserProfileEntity._();

  /// Kiểm tra xem người dùng đã có bằng lái được duyệt hay chưa
  bool get hasVerifiedLicense => documents.any(
    (doc) =>
        doc.type == DocumentType.license && doc.status == KycStatus.approved,
  );

  /// Lấy tài liệu bằng lái xe (nếu có)
  KycDocumentEntity? get licenseDocument {
    for (final doc in documents) {
      if (doc.type == DocumentType.license) {
        return doc;
      }
    }
    return null;
  }

  /// Trạng thái bằng lái xe tổng quan
  KycStatus get licenseStatus => licenseDocument?.status ?? KycStatus.none;
}
