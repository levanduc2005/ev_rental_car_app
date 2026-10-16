import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/confirm_contract_signed_usecase.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  late MockCheckinRepository repository;
  late ConfirmContractSignedUseCase useCase;

  setUp(() {
    repository = MockCheckinRepository();
    useCase = ConfirmContractSignedUseCase(repository);
  });

  group('ConfirmContractSignedUseCase', () {
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
      final entity = ContractConfirmResultEntity(
        rentalId: 10,
        status: 'ACTIVE',
        contractStatus: 'SIGNED',
        activatedAt: DateTime(2026, 10, 16),
      );
      when(
        () => repository.confirmContractSigned(10),
      ).thenAnswer((_) async => Result.ok(entity));

      final result = await useCase(10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (res) {
          expect(res.rentalId, 10);
          expect(res.isActive, isTrue);
        },
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.confirmContractSigned(10)).called(1);
    });
  });
}
