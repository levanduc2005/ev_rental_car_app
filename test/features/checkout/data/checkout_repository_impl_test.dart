import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_overview_model.dart';
import 'package:rental_car/features/checkout/data/models/vehicle_log_model.dart';
import 'package:rental_car/features/checkout/data/repositories/checkout_repository_impl.dart';

class MockCheckoutRemoteDataSource extends Mock
    implements CheckoutRemoteDataSource {}

void main() {
  late MockCheckoutRemoteDataSource remoteDataSource;
  late CheckoutRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockCheckoutRemoteDataSource();
    repository = CheckoutRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('CheckoutRepositoryImpl', () {
    const checklist = RentalChecklistModel(
      id: 1,
      rentalId: 10,
      type: 'CHECK_OUT',
      currentBattery: 80,
    );

    const vehicleLog = VehicleLogModel(
      id: 2,
      rentalId: 10,
      vehicleId: 5,
      cost: 500000,
    );

    const overview = RentalOverviewModel(
      rentalId: 10,
      reservationDeposit: 500000,
      rentalDeposit: 3000000,
    );

    test('getChecklistsByRentalId returns list of checklists', () async {
      when(
        () => remoteDataSource.getChecklistsByRentalId(10),
      ).thenAnswer((_) async => [checklist]);

      final result = await repository.getChecklistsByRentalId(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) => expect(list.length, 1),
        err: (_) => fail('Expected ok'),
      );
    });

    test('createChecklist delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.createChecklist(
          rentalId: 10,
          type: 'CHECK_OUT',
          currentBattery: 80,
          img: 'img.jpg',
          staffEmail: 'staff@test.com',
        ),
      ).thenAnswer((_) async => checklist);

      final result = await repository.createChecklist(
        rentalId: 10,
        type: 'CHECK_OUT',
        currentBattery: 80,
        img: 'img.jpg',
        staffEmail: 'staff@test.com',
      );

      expect(result.isOk, isTrue);
    });

    test('updateChecklist delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.updateChecklist(
          id: 1,
          rentalId: 10,
          type: 'CHECK_OUT',
          currentBattery: 80,
          img: 'img.jpg',
          staffEmail: 'staff@test.com',
        ),
      ).thenAnswer((_) async => checklist);

      final result = await repository.updateChecklist(
        id: 1,
        rentalId: 10,
        type: 'CHECK_OUT',
        currentBattery: 80,
        img: 'img.jpg',
        staffEmail: 'staff@test.com',
      );

      expect(result.isOk, isTrue);
    });

    test('getVehicleLogByRentalId returns vehicle log', () async {
      when(
        () => remoteDataSource.getVehicleLogByRentalId(10),
      ).thenAnswer((_) async => vehicleLog);

      final result = await repository.getVehicleLogByRentalId(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (log) => expect(log?.id, 2),
        err: (_) => fail('Expected ok'),
      );
    });

    test('createOrUpdateVehicleLog delegates to remoteDataSource', () async {
      when(
        () => remoteDataSource.createOrUpdateVehicleLog(
          rentalId: 10,
          vehicleId: 5,
          repairItems: [],
          imgs: [],
          staffId: 1,
        ),
      ).thenAnswer((_) async => vehicleLog);

      final result = await repository.createOrUpdateVehicleLog(
        rentalId: 10,
        vehicleId: 5,
        repairItems: [],
        imgs: [],
        staffId: 1,
      );

      expect(result.isOk, isTrue);
    });

    test('getRentalOverview returns overview entity', () async {
      when(
        () => remoteDataSource.getRentalOverview(10),
      ).thenAnswer((_) async => overview);

      final result = await repository.getRentalOverview(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (ov) => expect(ov.rentalId, 10),
        err: (_) => fail('Expected ok'),
      );
    });

    test('processCheckoutPayment returns response map', () async {
      when(
        () => remoteDataSource.processCheckoutPayment(10),
      ).thenAnswer((_) async => {'status': 'OK'});

      final result = await repository.processCheckoutPayment(10);

      expect(result.isOk, isTrue);
    });

    test('createRentalCompensationPaymentLink returns PayOS entity', () async {
      const payosModel = PayOSPaymentInfoModel(
        orderCode: 'ORD-COMP',
        amount: 200000,
        description: 'Bồi thường',
        accountNumber: '123',
        accountName: 'EMOTION',
        qrCodeUrl: 'https://qr.png',
      );

      when(
        () => remoteDataSource.createRentalCompensationPaymentLink(
          10,
          amount: 200000,
        ),
      ).thenAnswer((_) async => payosModel);

      final result = await repository.createRentalCompensationPaymentLink(
        10,
        amount: 200000,
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.orderCode, 'ORD-COMP'),
        err: (_) => fail('Expected ok'),
      );
    });

    test(
      'checkRentalCompensationPayment delegates to remoteDataSource',
      () async {
        when(
          () => remoteDataSource.checkRentalCompensationPayment(10),
        ).thenAnswer((_) async => true);

        final result = await repository.checkRentalCompensationPayment(10);

        expect(result.isOk, isTrue);
        result.when(
          ok: (val) => expect(val, isTrue),
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test(
      'returns ServerFailure when remoteDataSource throws ServerException',
      () async {
        when(
          () => remoteDataSource.getRentalOverview(10),
        ).thenThrow(const ServerException(message: 'Error'));

        final result = await repository.getRentalOverview(10);

        expect(result.isErr, isTrue);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (f) => expect(f, isA<ServerFailure>()),
        );
      },
    );
  });
}
