import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/profile/data/models/kyc_document_model.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String email,
    String? fullName,
    String? phone,
    @Default('RENTER') String role,
    @Default(0) int point,
    @Default(false) bool blocked,
    String? createdAt,
    String? avatarUrl,
    @Default([]) List<KycDocumentModel> documents,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

extension UserProfileModelX on UserProfileModel {
  UserProfileEntity toEntity() {
    return UserProfileEntity(
      email: email,
      fullName: fullName,
      phone: phone,
      role: role,
      point: point,
      isBlocked: blocked,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      avatarUrl: avatarUrl,
      documents: documents.map((d) => d.toEntity()).toList(),
    );
  }
}
