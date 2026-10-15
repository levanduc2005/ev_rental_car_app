import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/emergency/data/models/sos_report_model.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';

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
}
