import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/submit_pickup_checklist_usecase.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(const AccessoryChecklistEntity());
    registerFallbackValue(const CarImagesEntity());
  });

  late MockCheckinRepository mockRepository;
  late SubmitPickupChecklistUseCase useCase;

  setUp(() {
    mockRepository = MockCheckinRepository();
    useCase = SubmitPickupChecklistUseCase(mockRepository);
  });

  const validImages = CarImagesEntity(
    frontUrl: 'https://img.com/front.jpg',
    backUrl: 'https://img.com/back.jpg',
    leftSideUrl: 'https://img.com/left.jpg',
    rightSideUrl: 'https://img.com/right.jpg',
  );

  group('SubmitPickupChecklistUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(
        rentalId: 0,
        odometer: 1000,
        batteryPercentage: 90,
        accessories: const AccessoryChecklistEntity(),
        images: validImages,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('returns DataFailure when odometer is <= 0', () async {
      final result = await useCase(
        rentalId: 105,
        odometer: 0,
        batteryPercentage: 90,
        accessories: const AccessoryChecklistEntity(),
        images: validImages,
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test(
      'returns DataFailure when batteryPercentage is outside 1-100',
      () async {
        final result = await useCase(
          rentalId: 105,
          odometer: 1000,
          batteryPercentage: 101,
          accessories: const AccessoryChecklistEntity(),
          images: validImages,
        );

        expect(result.isErr, true);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (failure) => expect(failure, isA<DataFailure>()),
        );
      },
    );

    test(
      'returns DataFailure when car exterior images are incomplete',
      () async {
        const incompleteImages = CarImagesEntity(
          frontUrl: 'https://img.com/front.jpg',
          backUrl: 'https://img.com/back.jpg',
        );

        final result = await useCase(
          rentalId: 105,
          odometer: 1000,
          batteryPercentage: 90,
          accessories: const AccessoryChecklistEntity(),
          images: incompleteImages,
        );

        expect(result.isErr, true);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (failure) => expect(failure, isA<DataFailure>()),
        );
      },
    );

    test('delegates to repository when input is valid', () async {
      const expected = PickupChecklistEntity(
        checklistId: 88,
        rentalId: 105,
        type: 'PICKUP',
        odometer: 12540,
        batteryPercentage: 95,
      );

      when(
        () => mockRepository.submitPickupChecklist(
          rentalId: 105,
          odometer: 12540,
          batteryPercentage: 95,
          accessories: any(named: 'accessories'),
          images: validImages,
          note: any(that: anything, named: 'note'),
        ),
      ).thenAnswer((_) async => const Result.ok(expected));

      final result = await useCase(
        rentalId: 105,
        odometer: 12540,
        batteryPercentage: 95,
        accessories: const AccessoryChecklistEntity(),
        images: validImages,
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) => expect(entity.checklistId, 88),
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
