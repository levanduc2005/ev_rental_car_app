import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';

void main() {
  group('VehicleModel & StationModel in vehicles feature', () {
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

      final model = VehicleModel.fromBackendJson(json);
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
      expect(entity.fuelTypeDisplay, contains('Điện'));
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

        final model = VehicleModel.fromBackendJson(json);
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

      final model = VehicleModel.fromBackendJson(json);
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

    test('VehicleModel.fromJson and toJson work correctly', () {
      final json = {
        'id': 1,
        'name': 'VF e34',
        'status': 'AVAILABLE',
        'brand': 'VINFAST',
        'seats': 5,
        'priceRate': 1000000.0,
        'hourRate': 500000.0,
      };

      final model = VehicleModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'VF e34');

      final serialized = model.toJson();
      expect(serialized['id'], 1);
      expect(serialized['name'], 'VF e34');
    });

    test(
      'fromBackendJson handles complex image lists, string id, and holdFee string formats',
      () {
        final json = {
          'id': '99',
          'name': 'VF 9',
          'brand': 'VinFast',
          'images': [
            {'url': 'https://img1.jpg'},
            'https://img2.jpg',
          ],
          'main': 'https://main.jpg',
          'stationName': 'Trạm Trung Tâm',
          'holdFee': '10,000 đ',
          'status': 'SẴN SÀNG',
        };

        final model = VehicleModel.fromBackendJson(json);
        expect(model.id, 99);
        expect(model.stationName, 'Trạm Trung Tâm');
        expect(model.holdFee, 10000.0);
        expect(model.status, 'AVAILABLE');
        expect(model.images, contains('https://main.jpg'));
      },
    );

    test(
      'fromBackendJson handles various status mappings and fallback holdFee keys',
      () {
        final statuses = [
          {'raw': 'ĐANG THUÊ', 'expected': 'RENTING'},
          {'raw': 'ĐÃ ĐẶT', 'expected': 'RESERVED'},
          {'raw': 'BẢO TRÌ', 'expected': 'MAINTENANCE'},
          {'raw': 'CUSTOM_STATUS', 'expected': 'CUSTOM_STATUS'},
        ];

        for (final s in statuses) {
          final model = VehicleModel.fromBackendJson({
            'id': null,
            'status': s['raw'],
            'holdFeeValue': 20000,
          });
          expect(model.id, 0);
          expect(model.status, s['expected']);
          expect(model.holdFee, 20000.0);
        }

        final modelWithHoldingDeposit = VehicleModel.fromBackendJson({
          'id': 5,
          'holdingDeposit': 15000,
        });
        expect(modelWithHoldingDeposit.holdFee, 15000.0);
      },
    );

    test(
      'toEntity fallback pricing calculates correctly when rates are low or missing',
      () {
        const model = VehicleModel(
          id: 1,
          name: 'Car',
          brand: 'VINFAST',
          hourRate: 500, // <= 1000, triggers priceRate * 0.45
          priceRate: 1000000,
        );

        final entity = model.toEntity();
        expect(entity.pricePer4Hours, 450000.0);
        expect(entity.pricePer8Hours, 450000.0 * 1.4);
        expect(entity.pricePer12Hours, 450000.0 * 1.6);
        expect(entity.pricePerDay, 1000000.0);
      },
    );
  });
}
