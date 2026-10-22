import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/cancel_staff_rental_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late CancelStaffRentalUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = CancelStaffRentalUseCase(repository);
  });

  group('CancelStaffRentalUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(0);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository when rentalId is valid', () async {
      when(
        () => repository.cancelRental(10),
      ).thenAnswer((_) async => const Result.ok(true));

      final result = await useCase(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (success) => expect(success, isTrue),
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.cancelRental(10)).called(1);
    });
  });
}
