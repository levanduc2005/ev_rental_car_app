import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_checklists_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late GetStaffChecklistsUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = GetStaffChecklistsUseCase(repository);
  });

  group('GetStaffChecklistsUseCase', () {
    test('delegates to repository.getChecklists()', () async {
      final checklists = [
        RentalChecklistEntity(
          id: 1,
          type: 'CHECK_IN',
          currentBattery: 95.0,
          rentalId: 10,
          createdAt: DateTime(2026, 10, 16),
        ),
      ];

      when(
        () => repository.getChecklists(keyword: 'VF', type: 'CHECK_IN'),
      ).thenAnswer((_) async => Result.ok(checklists));

      final result = await useCase(keyword: 'VF', type: 'CHECK_IN');

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list.first.currentBattery, 95.0);
        },
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.getChecklists(keyword: 'VF', type: 'CHECK_IN'),
      ).called(1);
    });

    test('returns failure when repository fails', () async {
      when(
        () => repository.getChecklists(
          keyword: any(named: 'keyword'),
          type: any(named: 'type'),
        ),
      ).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Error')),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
    });
  });
}
