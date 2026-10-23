import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/staff/data/models/renter_model.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';

void main() {
  group('RenterEntity & RenterModel', () {
    test('fromJson, toJson, and toEntity map fields correctly', () {
      final json = {
        'email': 'customer@test.com',
        'fullName': 'Nguyen Khach',
        'phone': '0912345678',
        'point': 100,
        'blocked': false,
        'role': 'ROLE_USER',
      };

      final model = RenterModel.fromJson(json);

      expect(model.email, 'customer@test.com');
      expect(model.fullName, 'Nguyen Khach');
      expect(model.phone, '0912345678');
      expect(model.point, 100);
      expect(model.blocked, isFalse);

      final outJson = model.toJson();
      expect(outJson['email'], 'customer@test.com');
      expect(outJson['fullName'], 'Nguyen Khach');

      final entity = model.toEntity();
      expect(entity.email, 'customer@test.com');

      const entity2 = RenterEntity(
        email: 'customer@test.com',
        fullName: 'Another Name',
      );
      expect(entity == entity2, isTrue);
      expect(entity.hashCode, entity2.hashCode);
    });
  });

  group('StaffStationEntity & StaffProfileEntity', () {
    test('isActive and isStaff getters compute correctly', () {
      const station = StaffStationEntity(id: 1, name: 'Trạm Landmark 81');
      expect(station.isActive, isTrue);

      const inactiveStation = StaffStationEntity(
        id: 2,
        name: 'Trạm Cu Chi',
        status: 'INACTIVE',
      );
      expect(inactiveStation.isActive, isFalse);

      const staff = StaffProfileEntity(
        email: 'staff@emotion.vn',
        fullName: 'Staff Le',
        role: 'ROLE_STAFF',
        staffId: 10,
        station: station,
      );
      expect(staff.isStaff, isTrue);

      const admin = StaffProfileEntity(
        email: 'admin@emotion.vn',
        fullName: 'Admin Le',
        role: 'ROLE_ADMIN',
        staffId: 1,
      );
      expect(admin.isStaff, isTrue);

      const user = StaffProfileEntity(
        email: 'user@emotion.vn',
        fullName: 'User Le',
        role: 'ROLE_USER',
        staffId: 2,
      );
      expect(user.isStaff, isFalse);
    });
  });
}
