import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/paginated_vehicles.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';

void main() {
  group('PaginatedVehicles', () {
    test('hasNextPage returns true when currentPage < totalPages', () {
      const page1 = PaginatedVehicles(
        vehicles: [],
        currentPage: 1,
        totalPages: 3,
      );
      expect(page1.hasNextPage, isTrue);

      const pageLast = PaginatedVehicles(
        vehicles: [],
        currentPage: 3,
        totalPages: 3,
      );
      expect(pageLast.hasNextPage, isFalse);
    });
  });

  group('VehicleScheduleSlot', () {
    test('conflictsWith and containsDate detect overlapping intervals', () {
      final slot = VehicleScheduleSlot(
        startTime: DateTime(2026, 10, 10, 8),
        endTime: DateTime(2026, 10, 10, 18),
      );

      // Overlap inside
      expect(
        slot.conflictsWith(
          DateTime(2026, 10, 10, 10),
          DateTime(2026, 10, 10, 12),
        ),
        isTrue,
      );

      // No overlap before
      expect(
        slot.conflictsWith(
          DateTime(2026, 10, 10, 6),
          DateTime(2026, 10, 10, 8),
        ),
        isFalse,
      );

      // No overlap after
      expect(
        slot.conflictsWith(
          DateTime(2026, 10, 10, 18),
          DateTime(2026, 10, 10, 20),
        ),
        isFalse,
      );

      expect(slot.containsDate(DateTime(2026, 10, 10)), isTrue);
      expect(slot.containsDate(DateTime(2026, 10, 11)), isFalse);
    });
  });

  group('BookingFee & BookingFeeBreakdown', () {
    test('fromFees parses fee types and calculates station remainders', () {
      const fees = [
        BookingFee(
          description: 'Rental',
          feeType: 'BOOKING_FEE',
          value: 800000,
        ),
        BookingFee(description: 'Deposit', feeType: 'DEPOSIT', value: 2000000),
        BookingFee(description: 'Hold', feeType: 'HOLD_CAR', value: 500000),
        BookingFee(
          description: 'Total',
          feeType: 'TOTAL_AMOUNT',
          value: 2800000,
        ),
      ];

      final breakdown = BookingFeeBreakdown.fromFees(fees);

      expect(breakdown.bookingFee, 800000);
      expect(breakdown.deposit, 2000000);
      expect(breakdown.holdCar, 500000);
      expect(breakdown.totalAmount, 2800000);
      expect(breakdown.remainingAtStation, 2300000);
      expect(breakdown.depositAfterHold, 1500000);
    });
  });

  group('VehicleFilter', () {
    test('priceRange calculations evaluate correctly', () {
      const f1 = VehicleFilter(priceRange: 'Dưới 500K');
      expect(f1.effectiveMinPrice, isNull);
      expect(f1.effectiveMaxPrice, 500000.0);

      const f2 = VehicleFilter(priceRange: '500K - 1 Triệu');
      expect(f2.effectiveMinPrice, 500000.0);
      expect(f2.effectiveMaxPrice, 1000000.0);

      const f3 = VehicleFilter(priceRange: 'Trên 1 Triệu');
      expect(f3.effectiveMinPrice, 1000000.0);
      expect(f3.effectiveMaxPrice, isNull);

      const fExplicit = VehicleFilter(minPrice: 200000, maxPrice: 800000);
      expect(fExplicit.effectiveMinPrice, 200000.0);
      expect(fExplicit.effectiveMaxPrice, 800000.0);
    });

    test(
      'durationUnitLabel and formattedTimeRange format strings accurately',
      () {
        final start = DateTime(2026, 10, 1, 8);
        final end4h = DateTime(2026, 10, 1, 12);
        final end8h = DateTime(2026, 10, 1, 16);
        final end12h = DateTime(2026, 10, 1, 20);
        final end24h = DateTime(2026, 10, 2, 8);
        final end36h = DateTime(2026, 10, 2, 20);

        final filter4h = VehicleFilter(startTime: start, endTime: end4h);
        expect(filter4h.durationHours, 4);
        expect(filter4h.durationUnitLabel, '4 giờ');
        expect(filter4h.formattedTimeRange, '08:00, 01/10 → 12:00, 01/10');

        final filter8h = VehicleFilter(startTime: start, endTime: end8h);
        expect(filter8h.durationUnitLabel, '8 giờ');

        final filter12h = VehicleFilter(startTime: start, endTime: end12h);
        expect(filter12h.durationUnitLabel, '12 giờ');

        final filter24h = VehicleFilter(startTime: start, endTime: end24h);
        expect(filter24h.durationUnitLabel, 'ngày');

        final filter36h = VehicleFilter(startTime: start, endTime: end36h);
        expect(filter36h.durationUnitLabel, '1 ngày 12 giờ');

        const filterNoDates = VehicleFilter(hourPackage: 4);
        expect(filterNoDates.formattedTimeRange, 'Gói 4 giờ');
      },
    );

    test('copyWith updates and clears fields correctly', () {
      const filter = VehicleFilter(
        seats: '4 chỗ',
        brand: 'VinFast',
        stationId: 5,
        search: 'VF8',
      );

      final updated = filter.copyWith(
        seats: '7 chỗ',
        clearStation: true,
        clearSearch: true,
      );

      expect(updated.seats, '7 chỗ');
      expect(updated.brand, 'VinFast');
      expect(updated.stationId, isNull);
      expect(updated.search, isNull);
    });
  });
}
