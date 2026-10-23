import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_detail_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository repository;
  late GetRentalDetailUseCase useCase;

  setUp(() {
    repository = MockProfileRepository();
    useCase = GetRentalDetailUseCase(repository);
  });

  group('GetRentalDetailUseCase', () {
    test('delegates to repository.getRentalDetail', () async {
      final detail = RentalDetailEntity(
        id: 1,
        reservationCode: 'RNT-01',
        status: 'COMPLETED',
        vehicleName: 'VF8',
        startTime: DateTime(2026, 10),
        endTime: DateTime(2026, 10, 2),
      );

      when(
        () => repository.getRentalDetail(1),
      ).thenAnswer((_) async => Result.ok(detail));

      final result = await useCase(1);

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.id, 1),
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.getRentalDetail(1)).called(1);
    });

    test('returns Failure when repository fails', () async {
      when(() => repository.getRentalDetail(1)).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Not found')),
      );

      final result = await useCase(1);

      expect(result.isErr, isTrue);
      verify(() => repository.getRentalDetail(1)).called(1);
    });
  });
}
