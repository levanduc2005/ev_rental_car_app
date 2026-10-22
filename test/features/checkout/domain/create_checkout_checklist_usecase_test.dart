import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_checkout_checklist_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;
  late CreateCheckoutChecklistUseCase useCase;

  setUp(() {
    repository = MockCheckoutRepository();
    useCase = CreateCheckoutChecklistUseCase(repository);
  });

  group('CreateCheckoutChecklistUseCase', () {
    test('returns DataFailure when rentalId is invalid', () async {
      final result = await useCase(
        rentalId: 0,
        currentBattery: 85,
        img: 'https://image.com/1.jpg',
      );

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected error'),
        err: (f) => expect(f, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('returns DataFailure when battery is out of range', () async {
      final result = await useCase(
        rentalId: 10,
        currentBattery: 105,
        img: 'https://image.com/1.jpg',
      );

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected error'),
        err: (f) => expect(f, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository on valid parameters', () async {
      const checklist = RentalChecklistEntity(
        id: 1,
        type: 'CHECK_OUT',
        currentBattery: 85,
        img: 'https://image.com/1.jpg',
      );

      when(
        () => repository.createChecklist(
          rentalId: 10,
          type: 'CHECK_OUT',
          currentBattery: 85,
          img: 'https://image.com/1.jpg',
          staffEmail: 'staff@example.com',
        ),
      ).thenAnswer((_) async => const Result.ok(checklist));

      final result = await useCase(
        rentalId: 10,
        currentBattery: 85,
        img: 'https://image.com/1.jpg',
        staffEmail: 'staff@example.com',
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (data) {
          expect(data.id, 1);
          expect(data.isCheckOut, isTrue);
        },
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.createChecklist(
          rentalId: 10,
          type: 'CHECK_OUT',
          currentBattery: 85,
          img: 'https://image.com/1.jpg',
          staffEmail: 'staff@example.com',
        ),
      ).called(1);
    });
  });
}
