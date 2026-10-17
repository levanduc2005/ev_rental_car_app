import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  late MockCheckinRepository repository;
  late UploadCarImageUseCase useCase;

  setUp(() {
    repository = MockCheckinRepository();
    useCase = UploadCarImageUseCase(repository);
  });

  group('UploadCarImageUseCase', () {
    test('returns DataFailure when filePath is empty or blank', () async {
      final result = await useCase('   ');

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository when filePath is valid', () async {
      const path = '/path/to/car_photo.jpg';
      const expectedUrl = 'https://res.cloudinary.com/image.jpg';
      when(
        () => repository.uploadCarImage(path),
      ).thenAnswer((_) async => const Result.ok(expectedUrl));

      final result = await useCase(path);

      expect(result.isOk, isTrue);
      result.when(
        ok: (url) => expect(url, expectedUrl),
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.uploadCarImage(path)).called(1);
    });
  });
}
