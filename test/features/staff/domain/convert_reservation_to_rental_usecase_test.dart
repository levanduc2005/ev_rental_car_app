import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/convert_reservation_to_rental_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository mockRepository;
  late ConvertReservationToRentalUseCase useCase;

  setUp(() {
    mockRepository = MockStaffRepository();
    useCase = ConvertReservationToRentalUseCase(mockRepository);
  });

  group('ConvertReservationToRentalUseCase', () {
    test('returns DataFailure when reservationCode is empty', () async {
      final result = await useCase(reservationCode: '   ', staffId: 10);

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('returns DataFailure when staffId is <= 0', () async {
      final result = await useCase(reservationCode: 'RES-123', staffId: 0);

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('delegates to repository when inputs are valid', () async {
      const rental = RentalDetailEntity(
        id: 105,
        status: 'PENDING',
        vehicleName: 'VinFast VF8',
        rentFee: 1500000,
        rentalDepositAmount: 500000,
        vehiclePlateNumber: '51K-12345',
        seatCapacity: 5,
        batteryCapacity: 87.7,
        stationName: 'Trạm Landmark 81',
        stationAddress: '720A Điện Biên Phủ',
      );

      when(
        () => mockRepository.convertReservationToRental(
          reservationCode: 'RES-123',
          staffId: 10,
        ),
      ).thenAnswer((_) async => const Result.ok(rental));

      final result = await useCase(
        reservationCode: 'RES-123',
        staffId: 10,
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.id, 105);
          expect(entity.status, 'PENDING');
          expect(entity.vehicleName, 'VinFast VF8');
        },
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
