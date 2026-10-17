import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/active_trip/data/models/active_rental_model.dart';

void main() {
  group('ActiveRentalModel', () {
    test('fromBackendJson parses nested backend response correctly', () {
      final backendJson = {
        'id': 12,
        'status': 'IN_PROGRESS',
        'startTime': '2026-10-14T08:00:00',
        'endTime': '2026-10-14T16:00:00',
        'rentFee': 700000.0,
        'discountPoint': 20,
        'userEmail': 'duc@example.com',
        'contractStatus': 'SIGNED',
        'contractUrl': 'https://contract.url',
        'rentalDeposit': {'amount': 3000000.0},
        'vehicle': {
          'id': 2,
          'name': 'VinFast VF 5 Plus',
          'brand': 'VINFAST',
          'plateNumber': '30A-999.88',
          'batteryLevel': 88,
          'batteryCapacity': 37.23,
          'main': 'https://image.url/main.jpg',
          'images': [
            {'url': 'https://image.url/sub.jpg'},
          ],
          'station': {
            'id': 1,
            'name': 'Trạm Sạc VinFast Thăng Long',
            'address': 'Số 1 Đại Lộ Thăng Long, Hà Nội',
            'latitude': 21.0031,
            'longitude': 105.7892,
          },
        },
      };

      final model = ActiveRentalModel.fromBackendJson(backendJson);
      expect(model.id, 12);
      expect(model.status, 'IN_PROGRESS');
      expect(model.rentFee, 700000.0);
      expect(model.discountPoint, 20);
      expect(model.vehicleId, 2);
      expect(model.vehicleName, 'VinFast VF 5 Plus');
      expect(model.vehicleBrand, 'VINFAST');
      expect(model.vehiclePlate, '30A-999.88');
      expect(model.vehicleImageUrl, 'https://image.url/main.jpg');
      expect(model.batteryLevel, 88);
      expect(model.batteryCapacity, 37.23);
      expect(model.stationName, 'Trạm Sạc VinFast Thăng Long');
      expect(model.stationAddress, 'Số 1 Đại Lộ Thăng Long, Hà Nội');
      expect(model.stationLat, 21.0031);
      expect(model.stationLng, 105.7892);
      expect(model.rentalDeposit, 3000000.0);

      final entity = model.toEntity();
      expect(entity.id, 12);
      expect(entity.isActive, isTrue);
      expect(entity.vehiclePlate, '30A-999.88');
    });
  });
}
