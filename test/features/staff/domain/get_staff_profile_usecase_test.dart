import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_profile_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late GetStaffProfileUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = GetStaffProfileUseCase(repository);
  });

  group('GetStaffProfileUseCase', () {
    test('delegates to repository.getStaffProfile()', () async {
      const profile = StaffProfileEntity(
        staffId: 5,
        fullName: 'Le Staff',
        email: 'staff@emotion.vn',
        phone: '0901234567',
        role: 'ROLE_STAFF',
      );

      when(
        () => repository.getStaffProfile(),
      ).thenAnswer((_) async => const Result.ok(profile));

      final result = await useCase();

      expect(result.isOk, isTrue);
      result.when(
        ok: (res) {
          expect(res.staffId, 5);
          expect(res.fullName, 'Le Staff');
        },
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.getStaffProfile()).called(1);
    });

    test('returns failure when repository fails', () async {
      when(() => repository.getStaffProfile()).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Error')),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
    });
  });
}
