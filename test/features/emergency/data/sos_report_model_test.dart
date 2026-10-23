import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/emergency/data/models/sos_report_model.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';

void main() {
  group('SosReportModel', () {
    test('fromJson and toEntity parse backend response correctly', () {
      final json = <String, dynamic>{
        'id': 20,
        'title': '[SOS] Hết pin giữa đường',
        'description': 'Pin còn 2%, xe chết máy',
        'type': 'OUT_OF_BATTERY',
        'status': 'PENDING',
        'createdAt': '2026-10-12T10:00:00Z',
        'imageUrl': 'https://res.cloudinary.com/test.jpg',
        'latitude': 10.762622,
        'longitude': 106.660172,
        'rentalId': 12,
        'userEmail': 'driver@test.com',
      };

      final model = SosReportModel.fromJson(json);

      expect(model.id, 20);
      expect(model.title, '[SOS] Hết pin giữa đường');
      expect(model.description, 'Pin còn 2%, xe chết máy');
      expect(model.type, 'OUT_OF_BATTERY');
      expect(model.imageUrl, 'https://res.cloudinary.com/test.jpg');
      expect(model.latitude, 10.762622);
      expect(model.longitude, 106.660172);

      final entity = model.toEntity();
      expect(entity.id, 20);
      expect(entity.type, EmergencyType.outOfBattery);
      expect(entity.latitude, 10.762622);
      expect(entity.longitude, 106.660172);
      expect(entity.rentalId, 12);
      expect(entity.userEmail, 'driver@test.com');
    });

    test('toJson creates expected Map', () {
      const model = SosReportModel(
        id: 5,
        title: '[SOS] Tai nạn',
        description: 'Va chạm với xe khác',
        type: 'ACCIDENT',
        imageUrl: 'https://test.jpg',
        rentalId: 8,
      );

      final json = model.toJson();
      expect(json['id'], 5);
      expect(json['title'], '[SOS] Tai nạn');
      expect(json['type'], 'ACCIDENT');
      expect(json['imageUrl'], 'https://test.jpg');
      expect(json['rentalId'], 8);
    });
  });

  group('SosReportEntity', () {
    test('copyWith, equality and hashCode operate correctly', () {
      const entity1 = SosReportEntity(
        id: 1,
        title: 'SOS',
        description: 'Flat tire',
        type: EmergencyType.flatTire,
        rentalId: 10,
      );

      final copied = entity1.copyWith(
        title: 'New SOS',
        description: 'Flat tire 2',
        type: EmergencyType.outOfBattery,
        imageUrl: 'new.jpg',
        latitude: 10.5,
        longitude: 106.5,
        rentalId: 20,
        userEmail: 'sos@test.com',
        status: 'RESOLVED',
        createdAt: DateTime(2026, 10, 15),
      );
      expect(copied.description, 'Flat tire 2');
      expect(copied.title, 'New SOS');
      expect(copied.userEmail, 'sos@test.com');
      expect(copied.status, 'RESOLVED');
      expect(copied.id, 1);

      const entity2 = SosReportEntity(
        id: 1,
        title: 'SOS',
        description: 'Flat tire',
        type: EmergencyType.flatTire,
        rentalId: 10,
      );

      expect(entity1 == entity2, isTrue);
      expect(entity1.hashCode, entity2.hashCode);
      expect(entity1 == entity1, isTrue);
      expect(entity1 == Object(), isFalse);
      expect(entity1 == entity1.copyWith(id: 2), isFalse);
      expect(entity1 == entity1.copyWith(title: 'Other'), isFalse);
      expect(entity1 == entity1.copyWith(description: 'Other'), isFalse);
      expect(
        entity1 == entity1.copyWith(type: EmergencyType.accident),
        isFalse,
      );
      expect(entity1 == entity1.copyWith(imageUrl: 'diff.jpg'), isFalse);
      expect(entity1 == entity1.copyWith(latitude: 1.0), isFalse);
      expect(entity1 == entity1.copyWith(longitude: 2.0), isFalse);
      expect(entity1 == entity1.copyWith(rentalId: 999), isFalse);

      final noChangeCopy = entity1.copyWith();
      expect(noChangeCopy == entity1, isTrue);
    });
  });
}
