import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/staff/data/models/staff_station_model.dart';

void main() {
  group('StaffStationModel', () {
    test('parses from JSON correctly', () {
      final json = {
        'id': 5,
        'name': 'Trạm Quận 1',
        'address': '123 Lê Lợi',
        'city': 'Hồ Chí Minh',
        'latitude': 10.7769,
        'longitude': 106.7009,
        'status': 'ACTIVE',
      };

      final model = StaffStationModel.fromJson(json);

      expect(model.id, 5);
      expect(model.name, 'Trạm Quận 1');
      expect(model.address, '123 Lê Lợi');
      expect(model.city, 'Hồ Chí Minh');
      expect(model.latitude, 10.7769);
      expect(model.longitude, 106.7009);
      expect(model.status, 'ACTIVE');
    });

    test('toJson returns map with expected keys', () {
      const model = StaffStationModel(
        id: 5,
        name: 'Trạm Quận 1',
        address: '123 Lê Lợi',
        city: 'Hồ Chí Minh',
      );

      final map = model.toJson();
      expect(map['id'], 5);
      expect(map['name'], 'Trạm Quận 1');
      expect(map['address'], '123 Lê Lợi');
      expect(map['city'], 'Hồ Chí Minh');
    });
  });

  group('StaffProfileModel', () {
    test('parses from JSON with nested station correctly', () {
      final json = {
        'email': 'staff@emotion.vn',
        'fullName': 'Nguyen Van A',
        'phone': '0901234567',
        'role': 'ROLE_STAFF',
        'staffId': 42,
        'station': {
          'id': 2,
          'name': 'Trạm Landmark 81',
          'address': '720A Điện Biên Phủ',
          'city': 'Hồ Chí Minh',
        },
      };

      final model = StaffProfileModel.fromJson(json);

      expect(model.email, 'staff@emotion.vn');
      expect(model.fullName, 'Nguyen Van A');
      expect(model.role, 'ROLE_STAFF');
      expect(model.staffId, 42);
      expect(model.station, isNotNull);
      expect(model.station?.id, 2);
      expect(model.station?.name, 'Trạm Landmark 81');
    });

    test('handles fallback to id when staffId is missing', () {
      final json = {
        'id': 99,
        'email': 'staff@emotion.vn',
        'fullName': 'Tran Staff',
      };

      final model = StaffProfileModel.fromJson(json);
      expect(model.staffId, 99);
      expect(model.role, 'ROLE_STAFF');
    });
  });
}
