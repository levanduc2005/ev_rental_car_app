import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/generate_staff_contract_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late GenerateStaffContractUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = GenerateStaffContractUseCase(repository);
  });

  group('GenerateStaffContractUseCase', () {
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
      const url = 'https://docuseal.co/sign/abc';
      when(
        () => repository.generateContract(15),
      ).thenAnswer((_) async => const Result.ok(url));

      final result = await useCase(15);

      expect(result.isOk, isTrue);
      result.when(
        ok: (signingUrl) => expect(signingUrl, url),
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.generateContract(15)).called(1);
    });
  });
}
