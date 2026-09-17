import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String email,
    required String fullName,
    String? role,
    String? phone,
    @Default(0) int point,
    @Default(false) bool blocked,
    String? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullName: fullName,
      role: role ?? 'ROLE_USER',
      phone: phone,
      point: point,
      isBlocked: blocked,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }
}
