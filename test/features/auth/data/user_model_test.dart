import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity & UserEntityX', () {
    test('isStaff identifies staff role and staff email prefixes', () {
      const u1 = UserEntity(email: 'user@test.com', role: 'ROLE_STAFF');
      expect(u1.isStaff, isTrue);

      const u2 = UserEntity(email: 'user@test.com', role: 'ADMIN');
      expect(u2.isStaff, isTrue);

      const u3 = UserEntity(email: 'staff.hn@test.com');
      expect(u3.isStaff, isTrue);

      const u4 = UserEntity(email: 'customer@test.com');
      expect(u4.isStaff, isFalse);
    });

    test('isAdmin identifies admin role and admin email prefixes', () {
      const u1 = UserEntity(email: 'admin@test.com');
      expect(u1.isAdmin, isTrue);

      const u2 = UserEntity(email: 'user@test.com', role: 'ROLE_ADMIN');
      expect(u2.isAdmin, isTrue);

      const u3 = UserEntity(email: 'user@test.com', role: 'ADMIN');
      expect(u3.isAdmin, isTrue);

      const u4 = UserEntity(email: 'user@test.com');
      expect(u4.isAdmin, isFalse);
    });
  });

  group('UserModel & UserModelX', () {
    test('fromJson and toEntity parse user and resolve role accurately', () {
      final json = {
        'email': 'staff.hcm@emotion.vn',
        'fullName': 'Staff One',
        'role': 'ROLE_USER',
        'phone': '0901234567',
        'point': 50,
        'blocked': false,
        'createdAt': '2026-10-01T08:00:00Z',
      };

      final model = UserModel.fromJson(json);

      expect(model.email, 'staff.hcm@emotion.vn');
      expect(model.fullName, 'Staff One');
      expect(model.point, 50);

      final entity = model.toEntity();
      expect(entity.role, 'ROLE_STAFF');
      expect(entity.isStaff, isTrue);
      expect(entity.createdAt, isNotNull);
    });

    test('toEntity resolves admin role from email prefix', () {
      const model = UserModel(
        email: 'admin.manager@gmail.com',
        fullName: 'Admin Guy',
      );

      final entity = model.toEntity();
      expect(entity.role, 'ROLE_ADMIN');
      expect(entity.isAdmin, isTrue);
    });
  });
}
