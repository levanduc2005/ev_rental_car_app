import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/check_license_status_usecase.dart';

class MockCheckinRepository extends Mock implements CheckinRepository {}

void main() {
  late MockCheckinRepository repository;
  late CheckLicenseStatusUseCase useCase;

  setUp(() {
    repository = MockCheckinRepository();
    useCase = CheckLicenseStatusUseCase(repository);
  });

  group('CheckLicenseStatusUseCase', () {
    test('delegates to repository.getLicenseStatus() on success', () async {
      const entity = LicenseStatusEntity(
        userId: 1,
        licenseStatus: 'APPROVED',
        licenseNumber: 'B2-123456',
      );
      when(
        () => repository.getLicenseStatus(),
      ).thenAnswer((_) async => const Result.ok(entity));

      final result = await useCase();

      expect(result.isOk, isTrue);
      result.when(
        ok: (status) {
          expect(status.userId, 1);
          expect(status.isApproved, isTrue);
        },
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.getLicenseStatus()).called(1);
    });

    test('returns failure when repository fails', () async {
      when(() => repository.getLicenseStatus()).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Lỗi máy chủ')),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<ServerFailure>()),
      );
      verify(() => repository.getLicenseStatus()).called(1);
    });
  });
}
