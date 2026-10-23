import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_car/features/booking/data/models/booking_fee_model.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/booking/data/models/vehicle_booking_summary_model.dart';
import 'package:rental_car/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';

class MockBookingRemoteDataSource extends Mock
    implements BookingRemoteDataSource {}

void main() {
  late MockBookingRemoteDataSource remoteDataSource;
  late BookingRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      CreateReservationRequestModel(
        userEmail: 'fallback@test.com',
        vehicleId: 1,
        stationId: 1,
        startTime: DateTime(2026),
        endTime: DateTime(2026, 1, 2),
      ),
    );
  });

  setUp(() {
    remoteDataSource = MockBookingRemoteDataSource();
    repository = BookingRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('BookingRepositoryImpl', () {
    final start = DateTime(2026, 10, 1, 8);
    final end = DateTime(2026, 10, 1, 16);

    test('calculateFees returns BookingFeeEntity on success', () async {
      const model = BookingFeeModel(
        bookingFee: 500000,
        depositFee: 3000000,
        holdCarFee: 500000,
        totalAmount: 3500000,
      );

      when(
        () => remoteDataSource.calculateBookingFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).thenAnswer((_) async => model);

      final result = await repository.calculateFees(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.bookingFee, 500000),
        err: (_) => fail('Expected ok'),
      );
    });

    test('calculateFees returns ServerFailure on ServerException', () async {
      when(
        () => remoteDataSource.calculateBookingFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).thenThrow(const ServerException());

      final result = await repository.calculateFees(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<ServerFailure>()),
      );
    });

    test('createReservation returns ReservationEntity on success', () async {
      const model = ReservationModel(id: 1, code: 'RES-01', status: 'PENDING');

      when(
        () => remoteDataSource.createReservation(any()),
      ).thenAnswer((_) async => model);

      final result = await repository.createReservation(
        userEmail: 'user@test.com',
        vehicleId: 1,
        stationId: 2,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.code, 'RES-01'),
        err: (_) => fail('Expected ok'),
      );
    });

    test(
      'getMyReservations returns list of ReservationEntity on success',
      () async {
        const model = ReservationModel(
          id: 1,
          code: 'RES-01',
          status: 'PENDING',
        );

        when(
          () => remoteDataSource.getMyReservations(
            email: 'user@test.com',
            status: any(named: 'status'),
            page: any(named: 'page'),
            limit: any(named: 'limit'),
            search: any(named: 'search'),
          ),
        ).thenAnswer((_) async => [model]);

        final result = await repository.getMyReservations(
          email: 'user@test.com',
        );

        expect(result.isOk, isTrue);
        result.when(
          ok: (list) => expect(list.length, 1),
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test('getReservationDetail returns entity on success', () async {
      const model = ReservationModel(
        id: 10,
        code: 'RES-10',
        status: 'CONFIRMED',
      );

      when(
        () => remoteDataSource.getReservationDetail(10),
      ).thenAnswer((_) async => model);

      final result = await repository.getReservationDetail(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.id, 10),
        err: (_) => fail('Expected ok'),
      );
    });

    test('cancelReservation delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.cancelReservation('RES-10', reason: 'Change'),
      ).thenAnswer((_) async => true);

      final result = await repository.cancelReservation(
        code: 'RES-10',
        reason: 'Change',
      );

      expect(result.isOk, isTrue);
    });

    test('getVehicleDetail returns VehicleBookingSummary on success', () async {
      const model = VehicleBookingSummaryModel(id: 7, name: 'VF7');

      when(
        () => remoteDataSource.getVehicleDetail(7),
      ).thenAnswer((_) async => model);

      final result = await repository.getVehicleDetail(7);

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.name, 'VF7'),
        err: (_) => fail('Expected ok'),
      );
    });

    test('confirmPayOSPayment delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.confirmPayOSPayment('RES-10'),
      ).thenAnswer((_) async => true);

      final result = await repository.confirmPayOSPayment('RES-10');

      expect(result.isOk, isTrue);
    });

    test('createPayOSPaymentLink returns entity on success', () async {
      const model = PayOSPaymentInfoModel(
        orderCode: 'ORD-1',
        amount: 500000,
        description: 'Deposit',
        accountNumber: '123',
        accountName: 'EMOTION',
        qrCodeUrl: 'https://qr.png',
      );

      when(
        () => remoteDataSource.createPayOSPaymentLink(10),
      ).thenAnswer((_) async => model);

      final result = await repository.createPayOSPaymentLink(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.orderCode, 'ORD-1'),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getSupportedBanks returns bank list', () async {
      const bank = BankAppItem(
        appId: 'mb',
        code: 'MB',
        name: 'MBBank',
        shortName: 'MBBank',
        logoUrl: 'url',
      );

      when(
        () => remoteDataSource.getSupportedBanks(),
      ).thenAnswer((_) async => [bank]);

      final result = await repository.getSupportedBanks();

      expect(result.isOk, isTrue);
      result.when(
        ok: (banks) => expect(banks.first.code, 'MB'),
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
