import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';

void main() {
  group('VehicleFilter duration & unit calculations', () {
    test('calculates duration and unit for 4 hours package', () {
      const filter = VehicleFilter(hourPackage: 4);
      expect(filter.durationHours, 4);
      expect(filter.durationUnitLabel, '4 giờ');
    });

    test('calculates duration and unit for 8 hours package', () {
      const filter = VehicleFilter(hourPackage: 8);
      expect(filter.durationHours, 8);
      expect(filter.durationUnitLabel, '8 giờ');
    });

    test('calculates duration and unit for 12 hours package', () {
      const filter = VehicleFilter(hourPackage: 12);
      expect(filter.durationHours, 12);
      expect(filter.durationUnitLabel, '12 giờ');
    });

    test('calculates duration and unit for 24 hours (1 day)', () {
      const filter = VehicleFilter(hourPackage: 24);
      expect(filter.durationHours, 24);
      expect(filter.durationUnitLabel, 'ngày');
    });

    test('calculates duration and unit from custom startTime and endTime', () {
      final start = DateTime(2026, 9, 28, 8);
      final end = DateTime(2026, 9, 28, 12);
      final filter = VehicleFilter(startTime: start, endTime: end);

      expect(filter.durationHours, 4);
      expect(filter.durationUnitLabel, '4 giờ');
      expect(filter.formattedTimeRange, contains('08:00'));
      expect(filter.formattedTimeRange, contains('12:00'));
      expect(filter.formattedTimeRange, contains('→'));
    });
  });

  group('VehicleEntityPricingX', () {
    const vehicle = VehicleEntity(
      id: 1,
      name: 'VinFast VF e34',
      brand: 'VINFAST',
      pricePer4Hours: 450000,
      pricePer8Hours: 700000,
      pricePer12Hours: 850000,
      pricePerDay: 1000000,
    );

    test('returns exact 4-hour price when duration is 4 hours', () {
      final priceK = vehicle.priceKForDuration(4);
      expect(priceK, 450); // 450.000đ / 1000 = 450K
    });

    test('returns exact 8-hour price when duration is 8 hours', () {
      final priceK = vehicle.priceKForDuration(8);
      expect(priceK, 700); // 700.000đ / 1000 = 700K
    });

    test('returns exact 12-hour price when duration is 12 hours', () {
      final priceK = vehicle.priceKForDuration(12);
      expect(priceK, 850); // 850.000đ / 1000 = 850K
    });

    test('returns daily price when duration is 24 hours', () {
      final priceK = vehicle.priceKForDuration(24);
      expect(priceK, 1000); // 1.000.000đ / 1000 = 1000K
    });

    test('scales price proportionally for multi-day rentals', () {
      final priceK = vehicle.priceKForDuration(48); // 2 days
      expect(priceK, 2000); // 1000K * 2
    });
  });
}
