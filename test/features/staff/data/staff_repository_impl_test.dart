import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/profile/data/models/rental_detail_model.dart';
import 'package:rental_car/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:rental_car/features/staff/data/models/staff_station_model.dart';
import 'package:rental_car/features/staff/data/repositories/staff_repository_impl.dart';

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

    test('convertReservationToRental returns mapped entity on success', () async {
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
    });

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
  });
}
