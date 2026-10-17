import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';

void main() {
  group('ActiveRentalEntity', () {
    final now = DateTime.now();

    test('correctly identifies isActive status', () {
      final activeTrip = ActiveRentalEntity(
        id: 1,
        status: 'IN_PROGRESS',
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now.add(const Duration(hours: 3)),
        rentFee: 500000,
        vehicleId: 10,
        vehicleName: 'VinFast VF 5 Plus',
        vehicleBrand: 'VINFAST',
        vehiclePlate: '29A-123.45',
      );

      final completedTrip = activeTrip.copyWith(status: 'COMPLETED');

      expect(activeTrip.isActive, isTrue);
      expect(completedTrip.isActive, isFalse);
    });

    test('calculates elapsed, remaining duration and overdue flag', () {
      final activeTrip = ActiveRentalEntity(
        id: 1,
        status: 'IN_PROGRESS',
        startTime: now.subtract(const Duration(hours: 2)),
        endTime: now.add(const Duration(hours: 2)),
        rentFee: 500000,
        vehicleId: 10,
        vehicleName: 'VinFast VF 5 Plus',
        vehicleBrand: 'VINFAST',
        vehiclePlate: '29A-123.45',
      );

      expect(activeTrip.elapsedDuration.inMinutes, greaterThanOrEqualTo(119));
      expect(activeTrip.remainingDuration.inMinutes, greaterThanOrEqualTo(119));
      expect(activeTrip.isOverdue, isFalse);

      final overdueTrip = activeTrip.copyWith(
        endTime: now.subtract(const Duration(minutes: 10)),
      );
      expect(overdueTrip.isOverdue, isTrue);
      expect(overdueTrip.remainingDuration, Duration.zero);
    });
  });
}
