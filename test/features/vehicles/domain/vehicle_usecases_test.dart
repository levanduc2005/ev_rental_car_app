import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/paginated_vehicles.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_booking_fees_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicle_schedule_usecase.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_vehicles_paginated_usecase.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository repository;

  setUp(() {
    repository = MockVehicleRepository();
  });

  group('GetBookingFeesUseCase', () {
    test('delegates to repository.getBookingFees', () async {
      final useCase = GetBookingFeesUseCase(repository);
      final start = DateTime(2026, 10, 1, 8);
      final end = DateTime(2026, 10, 1, 16);
      const breakdown = BookingFeeBreakdown(
        totalAmount: 1000000,
        fees: [
          BookingFee(
            feeType: 'BOOKING_FEE',
            value: 1000000,
            description: 'Tien thue',
          ),
        ],
      );

      when(
        () => repository.getBookingFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).thenAnswer((_) async => const Result.ok(breakdown));

      final result = await useCase(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
      verify(
        () => repository.getBookingFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).called(1);
    });
  });

  group('GetVehicleScheduleUseCase', () {
    test('delegates to repository.getVehicleSchedule', () async {
      final useCase = GetVehicleScheduleUseCase(repository);
      final start = DateTime(2026, 10, 1, 8);
      final end = DateTime(2026, 10, 1, 12);
      final slot = VehicleScheduleSlot(startTime: start, endTime: end);

      when(
        () => repository.getVehicleSchedule(1),
      ).thenAnswer((_) async => Result.ok([slot]));

      final result = await useCase(1);

      expect(result.isOk, isTrue);
      verify(() => repository.getVehicleSchedule(1)).called(1);
    });
  });

  group('GetVehiclesPaginatedUseCase', () {
    test('delegates to repository.getVehiclesPaginated', () async {
      final useCase = GetVehiclesPaginatedUseCase(repository);
      const paginated = PaginatedVehicles(
        vehicles: [],
        currentPage: 1,
        totalPages: 1,
      );

      when(
        () => repository.getVehiclesPaginated(filter: any(named: 'filter')),
      ).thenAnswer((_) async => const Result.ok(paginated));

      final result = await useCase();

      expect(result.isOk, isTrue);
      verify(
        () => repository.getVehiclesPaginated(filter: any(named: 'filter')),
      ).called(1);
    });
  });
}
