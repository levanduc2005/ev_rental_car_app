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

extension UserEntityX on UserEntity {
  bool get isStaff {
    final r = role.toUpperCase();
    if (r == 'ROLE_STAFF' ||
        r == 'STAFF' ||
        r == 'ROLE_ADMIN' ||
        r == 'ADMIN') {
      return true;
    }
    final em = email.toLowerCase();
    return em.startsWith('staff.') ||
        em.contains('staff') ||
        em.startsWith('admin');
  }

  bool get isAdmin {
    final r = role.toUpperCase();
    return r == 'ROLE_ADMIN' ||
        r == 'ADMIN' ||
        email.toLowerCase().startsWith('admin');
  }
}
