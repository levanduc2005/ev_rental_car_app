import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';
import 'package:rental_car/features/profile/domain/usecases/delete_kyc_document_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late DeleteKycDocumentUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = DeleteKycDocumentUseCase(mockRepository);
  });

  test('DeleteKycDocumentUseCase calls repository.deleteDocument()', () async {
    when(
      () => mockRepository.deleteDocument(123),
    ).thenAnswer((_) async => const Result.ok(null));

    final result = await useCase(123);

    expect(result.isOk, isTrue);
    verify(() => mockRepository.deleteDocument(123)).called(1);
  });
}
