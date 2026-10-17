import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/update_rental_status_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late UpdateRentalStatusUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = UpdateRentalStatusUseCase(repository);
  });

  group('UpdateRentalStatusUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(rentalId: 0, status: 'ACTIVE');

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('returns DataFailure when status is blank', () async {
      final result = await useCase(rentalId: 10, status: '   ');

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository when inputs are valid', () async {
      when(
        () => repository.updateRentalStatus(rentalId: 10, status: 'ACTIVE'),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await useCase(rentalId: 10, status: ' ACTIVE ');

      expect(result.isOk, isTrue);
      verify(
        () => repository.updateRentalStatus(rentalId: 10, status: 'ACTIVE'),
      ).called(1);
    });
  });
}
