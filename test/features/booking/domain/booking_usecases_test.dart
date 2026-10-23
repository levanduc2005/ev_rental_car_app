import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/domain/usecases/calculate_booking_fees_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/cancel_reservation_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/confirm_payos_payment_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/create_reservation_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_booking_vehicle_summary_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_my_reservations_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_reservation_detail_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_supported_banks_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late MockBookingRepository repository;

  setUp(() {
    repository = MockBookingRepository();
  });

  group('CalculateBookingFeesUseCase', () {
    test('delegates to repository.calculateFees', () async {
      final useCase = CalculateBookingFeesUseCase(repository);
      const fee = BookingFeeEntity(
        bookingFee: 500000,
        depositFee: 3000000,
        holdCarFee: 500000,
        totalAmount: 3500000,
      );

      final start = DateTime(2026, 10, 1, 8);
      final end = DateTime(2026, 10, 1, 16);

      when(
        () => repository.calculateFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).thenAnswer((_) async => const Result.ok(fee));

      final result = await useCase(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
      verify(
        () => repository.calculateFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).called(1);
    });
  });

  group('CreateReservationUseCase', () {
    test('delegates to repository.createReservation', () async {
      final useCase = CreateReservationUseCase(repository);
      const reservation = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'PENDING',
      );

      final start = DateTime(2026, 10, 1, 8);
      final end = DateTime(2026, 10, 1, 16);

      when(
        () => repository.createReservation(
          userEmail: 'user@test.com',
          vehicleId: 2,
          stationId: 3,
          startTime: start,
          endTime: end,
        ),
      ).thenAnswer((_) async => const Result.ok(reservation));

      final result = await useCase(
        userEmail: 'user@test.com',
        vehicleId: 2,
        stationId: 3,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
      verify(
        () => repository.createReservation(
          userEmail: 'user@test.com',
          vehicleId: 2,
          stationId: 3,
          startTime: start,
          endTime: end,
        ),
      ).called(1);
    });
  });

  group('GetBookingVehicleSummaryUseCase', () {
    test('delegates to repository.getVehicleDetail', () async {
      final useCase = GetBookingVehicleSummaryUseCase(repository);
      const vehicle = VehicleBookingSummary(id: 5, name: 'VF5');

      when(
        () => repository.getVehicleDetail(5),
      ).thenAnswer((_) async => const Result.ok(vehicle));

      final result = await useCase(5);

      expect(result.isOk, isTrue);
      verify(() => repository.getVehicleDetail(5)).called(1);
    });
  });

  group('GetMyReservationsUseCase', () {
    test('delegates to repository.getMyReservations', () async {
      final useCase = GetMyReservationsUseCase(repository);
      const reservation = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'PENDING',
      );

      when(
        () => repository.getMyReservations(
          email: 'user@test.com',
          status: any(named: 'status'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        ),
      ).thenAnswer((_) async => const Result.ok([reservation]));

      final result = await useCase(email: 'user@test.com');

      expect(result.isOk, isTrue);
      verify(
        () => repository.getMyReservations(
          email: 'user@test.com',
          status: any(named: 'status'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        ),
      ).called(1);
    });
  });

  group('GetSupportedBanksUseCase', () {
    test('delegates to repository.getSupportedBanks', () async {
      final useCase = GetSupportedBanksUseCase(repository);
      const bank = BankAppItem(
        appId: 'mb',
        code: 'MB',
        name: 'MBBank',
        shortName: 'MBBank',
        logoUrl: 'url',
      );

      when(
        () => repository.getSupportedBanks(),
      ).thenAnswer((_) async => const Result.ok([bank]));

      final result = await useCase();

      expect(result.isOk, isTrue);
      verify(() => repository.getSupportedBanks()).called(1);
    });
  });

  group('CancelReservationUseCase', () {
    test('delegates to repository.cancelReservation', () async {
      final useCase = CancelReservationUseCase(repository);

      when(
        () => repository.cancelReservation(
          code: 'RES-01',
          reason: 'Change of plans',
        ),
      ).thenAnswer((_) async => const Result.ok(true));

      final result = await useCase(code: 'RES-01', reason: 'Change of plans');

      expect(result.isOk, isTrue);
      verify(
        () => repository.cancelReservation(
          code: 'RES-01',
          reason: 'Change of plans',
        ),
      ).called(1);
    });
  });

  group('ConfirmPayOSPaymentUseCase', () {
    test('delegates to repository.confirmPayOSPayment', () async {
      final useCase = ConfirmPayOSPaymentUseCase(repository);

      when(
        () => repository.confirmPayOSPayment('RES-01'),
      ).thenAnswer((_) async => const Result.ok(true));

      final result = await useCase('RES-01');

      expect(result.isOk, isTrue);
      verify(() => repository.confirmPayOSPayment('RES-01')).called(1);
    });
  });

  group('GetReservationDetailUseCase', () {
    test('delegates to repository.getReservationDetail', () async {
      final useCase = GetReservationDetailUseCase(repository);
      const reservation = ReservationEntity(
        id: 1,
        code: 'RES-01',
        status: 'CONFIRMED',
      );

      when(
        () => repository.getReservationDetail(1),
      ).thenAnswer((_) async => const Result.ok(reservation));

      final result = await useCase(1);

      expect(result.isOk, isTrue);
      verify(() => repository.getReservationDetail(1)).called(1);
    });
  });
}
