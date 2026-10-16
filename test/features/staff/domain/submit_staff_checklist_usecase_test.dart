import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/submit_staff_checklist_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository mockRepository;
  late SubmitStaffCheckListUseCase useCase;

  setUp(() {
    mockRepository = MockStaffRepository();
    useCase = SubmitStaffCheckListUseCase(mockRepository);
  });

  group('SubmitStaffCheckListUseCase', () {
    test('returns DataFailure when rentalId <= 0', () async {
      final result = await useCase(
        rentalId: 0,
        staffEmail: 'staff@example.com',
        currentBattery: 85,
        img: 'https://cloudinary.com/img1.jpg',
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test(
      'returns DataFailure when currentBattery is invalid (<=0 or >100)',
      () async {
        final result1 = await useCase(
          rentalId: 10,
          staffEmail: 'staff@example.com',
          currentBattery: 0,
          img: 'https://cloudinary.com/img1.jpg',
        );
        final result2 = await useCase(
          rentalId: 10,
          staffEmail: 'staff@example.com',
          currentBattery: 101,
          img: 'https://cloudinary.com/img1.jpg',
        );

        expect(result1.isErr, true);
        expect(result2.isErr, true);
      },
    );

    test('returns DataFailure when img is empty', () async {
      final result = await useCase(
        rentalId: 10,
        staffEmail: 'staff@example.com',
        currentBattery: 90,
        img: '   ',
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('delegates to repository when inputs are valid', () async {
      final checklist = RentalChecklistEntity(
        id: 1,
        currentBattery: 90,
        img: 'https://cloudinary.com/img1.jpg|https://cloudinary.com/img2.jpg',
        type: 'CHECK_IN',
        createdAt: DateTime(2026, 10, 15, 10, 30),
      );

      when(
        () => mockRepository.submitCheckInChecklist(
          rentalId: 10,
          staffEmail: 'staff@example.com',
          currentBattery: 90,
          img:
              'https://cloudinary.com/img1.jpg|https://cloudinary.com/img2.jpg',
        ),
      ).thenAnswer((_) async => Result.ok(checklist));

      final result = await useCase(
        rentalId: 10,
        staffEmail: 'staff@example.com',
        currentBattery: 90,
        img: 'https://cloudinary.com/img1.jpg|https://cloudinary.com/img2.jpg',
      );

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.id, 1);
          expect(entity.currentBattery, 90);
          expect(entity.type, 'CHECK_IN');
          expect(entity.imageUrls.length, 2);
        },
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
