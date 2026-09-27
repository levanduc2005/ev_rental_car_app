import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/home/data/models/vehicle_model.dart';

void main() {
  group('VehicleModel & StationModel', () {
    test('fromJson and toEntity parse backend response correctly', () {
      final json = {
        'id': 10,
        'name': 'VinFast VF 8',
        'status': 'AVAILABLE',
        'category': 'SUV',
        'brand': 'VINFAST',
        'plateNumber': '29A-12345',
        'seats': 5,
        'priceRate': 1450000.0,
        'hourRate': 720000.0,
        'consumptionRate': 18.5,
        'batteryCapacity': 87.7,
        'batteryLevel': 95,
        'station': {
          'id': 1,
          'name': 'Trạm Times City',
          'address': '458 Minh Khai, Hai Bà Trưng, Hà Nội',
          'city': 'HANOI',
          'latitude': 20.995,
          'longitude': 105.867,
          'status': 'ACTIVE',
        },
        'main': 'https://res.cloudinary.com/sample/image/upload/vf8.jpg',
        'point': 5,
      };

      final model = VehicleModel.fromJson(json);
      expect(model.id, 10);
      expect(model.name, 'VinFast VF 8');
      expect(model.brand, 'VINFAST');
      expect(model.seats, 5);
      expect(model.priceRate, 1450000.0);
      expect(model.hourRate, 720000.0);
      expect(model.main, isNotNull);
      expect(model.station?.name, 'Trạm Times City');

      final entity = model.toEntity();
      expect(entity.id, 10);
      expect(entity.name, 'VinFast VF 8');
      expect(entity.isElectric, isTrue);
      expect(entity.isLuxury, isFalse);
      expect(entity.formattedPrice4h, '720K');
      expect(entity.formattedPrice24h, '1.450K');
      expect(entity.locationDisplay, contains('Trạm Times City'));
      expect(entity.fuelTypeDisplay, 'Điện');
    });

    test(
      'luxury vehicle calculation identifies luxury brand or high price',
      () {
        final json = {
          'id': 20,
          'name': 'BMW 320i',
          'brand': 'BMW',
          'seats': 5,
          'priceRate': 2100000.0,
          'hourRate': 1650000.0,
        };

        final model = VehicleModel.fromJson(json);
        final entity = model.toEntity();

        expect(entity.isLuxury, isTrue);
        expect(entity.isElectric, isFalse);
        expect(entity.formattedPrice4h, '1.650K');
        expect(entity.formattedPrice24h, '2.100K');
      },
    );

    test('parses explicit 4h, 8h, 12h, 1 day pricing tiers from backend', () {
      final json = {
        'id': 1,
        'name': 'VinFast VF 3 Plus 2024',
        'brand': 'VINFAST',
        'seats': 4,
        'pricePer4Hours': 300000.0,
        'pricePer8Hours': 420000.0,
        'pricePer12Hours': 480000.0,
        'pricePerDay': 600000.0,
      };

      final model = VehicleModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.pricePer4Hours, 300000.0);
      expect(entity.pricePer8Hours, 420000.0);
      expect(entity.pricePer12Hours, 480000.0);
      expect(entity.pricePerDay, 600000.0);
      expect(entity.formattedPrice4h, '300K');
      expect(entity.formattedPrice8h, '420K');
      expect(entity.formattedPrice12h, '480K');
      expect(entity.formattedPriceDay, '600K');
      expect(entity.isLuxury, isFalse);
    });
  });
}
