import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:rental_car/features/emergency/domain/usecases/upload_incident_image_usecase.dart';

class MockEmergencyRepository extends Mock implements EmergencyRepository {}

void main() {
  late MockEmergencyRepository repository;
  late UploadIncidentImageUseCase useCase;

  setUp(() {
    repository = MockEmergencyRepository();
    useCase = UploadIncidentImageUseCase(repository);
  });

  group('UploadIncidentImageUseCase', () {
    test('returns DataFailure when filePath is empty or blank', () async {
      final res1 = await useCase('');
      expect(res1.isErr, isTrue);
      res1.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<DataFailure>()),
      );

      final res2 = await useCase('   ');
      expect(res2.isErr, isTrue);
      res2.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<DataFailure>()),
      );

      verifyNever(() => repository.uploadIncidentImage(any()));
    });

    test('delegates to repository when filePath is valid', () async {
      when(
        () => repository.uploadIncidentImage('/path/to/image.jpg'),
      ).thenAnswer(
        (_) async => const Result.ok('https://cdn.example.com/image.jpg'),
      );

      final result = await useCase('/path/to/image.jpg');

      expect(result.isOk, isTrue);
      result.when(
        ok: (url) => expect(url, 'https://cdn.example.com/image.jpg'),
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.uploadIncidentImage('/path/to/image.jpg'),
      ).called(1);
    });
  });
}
