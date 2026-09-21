import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String email,
    String? fullName,
    String? phone,
    @Default('ROLE_USER') String role,
    @Default(0) int point,
    @Default(false) bool isBlocked,
    DateTime? createdAt,
  }) = _UserEntity;
}
