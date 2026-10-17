import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/generate_contract_usecase.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  late MockCheckinRepository mockRepository;
  late GenerateContractUseCase useCase;

  setUp(() {
    mockRepository = MockCheckinRepository();
    useCase = GenerateContractUseCase(mockRepository);
  });

  group('GenerateContractUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(0);

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('delegates to repository when rentalId is valid', () async {
      const contract = DocuSealContractEntity(
        rentalId: 105,
        contractId: 32,
        contractCode: 'HD-105',
        contractStatus: 'PENDING_SIGNATURE',
        signingUrl: 'https://docuseal.com/s/123',
      );

      when(
        () => mockRepository.generateContract(105),
      ).thenAnswer((_) async => const Result.ok(contract));

      final result = await useCase(105);

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.rentalId, 105);
          expect(entity.contractId, 32);
        },
        err: (_) => fail('Expected ok'),
      );
    });
  });
}
