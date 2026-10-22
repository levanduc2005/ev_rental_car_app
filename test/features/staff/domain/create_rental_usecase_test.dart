import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/create_rental_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository mockRepository;
  late CreateRentalUseCase useCase;

  setUp(() {
    mockRepository = MockStaffRepository();
    useCase = CreateRentalUseCase(mockRepository);
  });

  group('CreateRentalUseCase', () {
    final startTime = DateTime(2026, 10, 25, 10);
    final endTime = DateTime(2026, 10, 25, 18);

    test('returns DataFailure when email is empty', () async {
      final result = await useCase(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 10,
        email: '   ',
        staffId: 5,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('returns DataFailure when vehicleId <= 0', () async {
      final result = await useCase(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 0,
        email: 'customer@gmail.com',
        staffId: 5,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('returns DataFailure when staffId <= 0', () async {
      final result = await useCase(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 10,
        email: 'customer@gmail.com',
        staffId: 0,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('returns DataFailure when endTime <= startTime', () async {
      final result = await useCase(
        startTime: startTime,
        endTime: startTime.subtract(const Duration(hours: 1)),
        vehicleId: 10,
        email: 'customer@gmail.com',
        staffId: 5,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('delegates to repository with provided parameters', () async {
      const rental = RentalDetailEntity(
        id: 201,
        status: 'PENDING',
        vehicleName: 'VinFast VF9',
        rentFee: 2000000,
        rentalDepositAmount: 5000000,
        vehiclePlateNumber: '51K-99999',
        seatCapacity: 7,
        batteryCapacity: 123.0,
        stationName: 'Trạm Thủ Đức',
        stationAddress: '1 Võ Văn Ngân',
      );

      when(
        () => mockRepository.createRental(
          startTime: startTime,
          endTime: endTime,
          vehicleId: 10,
          email: 'customer@gmail.com',
          staffId: 5,
        ),
      ).thenAnswer((_) async => const Result.ok(rental));

      final result = await useCase(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 10,
        email: 'customer@gmail.com',
        staffId: 5,
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.id, 201);
          expect(entity.vehicleName, 'VinFast VF9');
          expect(entity.status, 'PENDING');
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('propagates failure from repository', () async {
      when(
        () => mockRepository.createRental(
          startTime: startTime,
          endTime: endTime,
          vehicleId: 10,
          email: 'customer@gmail.com',
          staffId: 5,
        ),
      ).thenAnswer(
        (_) async => const Result.err(
          ServerFailure(message: 'Xe đang có lịch trùng', statusCode: 400),
        ),
      );

      final result = await useCase(
        startTime: startTime,
        endTime: endTime,
        vehicleId: 10,
        email: 'customer@gmail.com',
        staffId: 5,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<ServerFailure>()),
      );
    });
  });
}
