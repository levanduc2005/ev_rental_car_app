import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/profile/data/models/rental_detail_model.dart';
import 'package:rental_car/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:rental_car/features/staff/data/models/renter_model.dart';
import 'package:rental_car/features/staff/data/models/staff_station_model.dart';
import 'package:rental_car/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class MockStaffRemoteDataSource extends Mock implements StaffRemoteDataSource {}

void main() {
  late MockStaffRemoteDataSource mockRemoteDataSource;
  late StaffRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockStaffRemoteDataSource();
    repository = StaffRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('StaffRepositoryImpl', () {
    test('getStaffProfile returns ok when data source succeeds', () async {
      const profileModel = StaffProfileModel(
        email: 'staff@emotion.vn',
        fullName: 'Nguyen Staff',
        phone: '0901234567',
        role: 'ROLE_STAFF',
        staffId: 10,
      );

      when(
        () => mockRemoteDataSource.getStaffProfile(),
      ).thenAnswer((_) async => profileModel);

      final result = await repository.getStaffProfile();

      expect(result.isOk, true);
      result.when(
        ok: (profile) {
          expect(profile.staffId, 10);
          expect(profile.email, 'staff@emotion.vn');
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('getStaffProfile maps NetworkException to NetworkFailure', () async {
      when(
        () => mockRemoteDataSource.getStaffProfile(),
      ).thenThrow(const NetworkException('No internet'));

      final result = await repository.getStaffProfile();

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<NetworkFailure>()),
      );
    });

    test('filterReservations returns mapped entities on success', () async {
      final models = [
        const ReservationModel(
          id: 1,
          code: 'RES-001',
          status: 'PENDING',
          vehicleName: 'VF 5',
          stationName: 'Trạm 1',
        ),
      ];

      when(
        () => mockRemoteDataSource.filterReservations(
          search: 'RES',
          status: ['PENDING'],
        ),
      ).thenAnswer((_) async => models);

      final result = await repository.filterReservations(
        search: 'RES',
        status: ['PENDING'],
      );

      expect(result.isOk, true);
      result.when(
        ok: (entities) {
          expect(entities.length, 1);
          expect(entities.first.code, 'RES-001');
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('filterRentals returns mapped entities on success', () async {
      final models = [
        RentalDetailModel(
          id: 10,
          status: 'ACTIVE',
          vehicleName: 'VF 8',
          rentFee: 1500000,
          rentalDepositAmount: 500000,
          createdAt: DateTime(2026, 10, 16),
          seatCapacity: 5,
          batteryCapacity: 87,
        ),
      ];

      when(
        () => mockRemoteDataSource.filterRentals(
          search: 'VF',
          status: ['ACTIVE'],
        ),
      ).thenAnswer((_) async => models);

      final result = await repository.filterRentals(
        search: 'VF',
        status: ['ACTIVE'],
      );

      expect(result.isOk, true);
      result.when(
        ok: (entities) {
          expect(entities.length, 1);
          expect(entities.first.vehicleName, 'VF 8');
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('getStationVehicles returns mapped entities on success', () async {
      final entities = [
        const VehicleEntity(
          id: 1,
          name: 'VF e34',
          brand: 'VinFast',
          pricePerDay: 800000,
          batteryCapacity: 42,
        ),
      ];

      when(
        () => mockRemoteDataSource.getStationVehicles(5),
      ).thenAnswer((_) async => entities);

      final result = await repository.getStationVehicles(5);

      expect(result.isOk, true);
      result.when(
        ok: (res) {
          expect(res.length, 1);
          expect(res.first.name, 'VF e34');
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('getCheckInPaymentUrl returns payment url on success', () async {
      const url = 'https://pay.payos.vn/123';
      when(
        () => mockRemoteDataSource.getCheckInPaymentUrl(rentalId: 10),
      ).thenAnswer((_) async => url);

      final result = await repository.getCheckInPaymentUrl(rentalId: 10);

      expect(result.isOk, true);
      result.when(
        ok: (payUrl) => expect(payUrl, url),
        err: (_) => fail('Expected ok'),
      );
    });

    test('submitCheckInChecklist returns mapped entity on success', () async {
      final model = RentalChecklistModel(
        id: 1,
        rentalId: 10,
        type: 'CHECK_IN',
        currentBattery: 90.0,
        createdAt: DateTime(2026, 10, 16),
      );

      when(
        () => mockRemoteDataSource.submitCheckInChecklist(
          rentalId: 10,
          staffEmail: 'staff@emotion.vn',
          currentBattery: 90,
          img: 'url1|url2',
        ),
      ).thenAnswer((_) async => model);

      final result = await repository.submitCheckInChecklist(
        rentalId: 10,
        staffEmail: 'staff@emotion.vn',
        currentBattery: 90,
        img: 'url1|url2',
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.id, 1);
          expect(entity.currentBattery, 90.0);
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('getChecklists returns list on success', () async {
      final models = [
        RentalChecklistModel(
          id: 1,
          rentalId: 10,
          type: 'CHECK_IN',
          currentBattery: 90.0,
          createdAt: DateTime(2026, 10, 16),
        ),
      ];

      when(
        () => mockRemoteDataSource.getChecklists(),
      ).thenAnswer((_) async => models);

      final result = await repository.getChecklists();

      expect(result.isOk, true);
      result.when(
        ok: (entities) => expect(entities.length, 1),
        err: (_) => fail('Expected ok'),
      );
    });

    test('updateRentalStatus returns ok on success', () async {
      when(
        () => mockRemoteDataSource.updateRentalStatus(
          rentalId: 10,
          status: 'ACTIVE',
        ),
      ).thenAnswer((_) async => {});

      final result = await repository.updateRentalStatus(
        rentalId: 10,
        status: 'ACTIVE',
      );

      expect(result.isOk, true);
    });

    test(
      'convertReservationToRental returns mapped entity on success',
      () async {
        final rentalModel = RentalDetailModel(
          id: 200,
          status: 'PENDING',
          vehicleName: 'VF e34',
          rentFee: 1000000,
          rentalDepositAmount: 300000,
          createdAt: DateTime(2026, 10, 15),
          seatCapacity: 5,
          batteryCapacity: 42,
        );

        when(
          () => mockRemoteDataSource.convertReservationToRental(
            reservationCode: 'RES-001',
            staffId: 10,
          ),
        ).thenAnswer((_) async => rentalModel);

        final result = await repository.convertReservationToRental(
          reservationCode: 'RES-001',
          staffId: 10,
        );

        expect(result.isOk, true);
        result.when(
          ok: (entity) {
            expect(entity.id, 200);
            expect(entity.vehicleName, 'VF e34');
          },
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test('generateContract maps ServerException to ServerFailure', () async {
      when(
        () => mockRemoteDataSource.generateContract(200),
      ).thenThrow(const ServerException(message: 'Contract generation failed'));

      final result = await repository.generateContract(200);

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<ServerFailure>()),
      );
    });

    test('getRenterByEmail returns mapped entity on success', () async {
      const renterModel = RenterModel(
        email: 'renter@test.com',
        fullName: 'Test Renter',
        phone: '0912345678',
        point: 50,
      );

      when(
        () => mockRemoteDataSource.getRenterByEmail('renter@test.com'),
      ).thenAnswer((_) async => renterModel);

      final result = await repository.getRenterByEmail('renter@test.com');

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.email, 'renter@test.com');
          expect(entity.fullName, 'Test Renter');
          expect(entity.point, 50);
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('createRental returns mapped entity on success', () async {
      final startTime = DateTime(2026, 10, 25, 8);
      final endTime = DateTime(2026, 10, 25, 16);
      const rentalModel = RentalDetailModel(
        id: 301,
        status: 'PENDING',
        vehicleName: 'VF 9',
        rentFee: 1800000,
        rentalDepositAmount: 5000000,
        seatCapacity: 7,
        batteryCapacity: 123.0,
      );

      when(
        () => mockRemoteDataSource.createRental(
          startTime: startTime,
          endTime: endTime,
          vehicleId: 15,
          email: 'renter@test.com',
          staffId: 2,
        ),
      ).thenAnswer((_) async => rentalModel);

      final result = await repository.createRental(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 15,
        email: 'renter@test.com',
        staffId: 2,
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.id, 301);
          expect(entity.vehicleName, 'VF 9');
          expect(entity.status, 'PENDING');
        },
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
