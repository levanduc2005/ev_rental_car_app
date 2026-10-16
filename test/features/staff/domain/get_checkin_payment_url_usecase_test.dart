import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/get_checkin_payment_url_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late GetCheckInPaymentUrlUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = GetCheckInPaymentUrlUseCase(repository);
  });

  group('GetCheckInPaymentUrlUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(rentalId: -1);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test(
      'delegates to repository and normalizes negative point to 0',
      () async {
        const payUrl = 'https://pay.payos.vn/web/123';
        when(
          () => repository.getCheckInPaymentUrl(rentalId: 20),
        ).thenAnswer((_) async => const Result.ok(payUrl));

        final result = await useCase(rentalId: 20, point: -50);

        expect(result.isOk, isTrue);
        result.when(
          ok: (url) => expect(url, payUrl),
          err: (_) => fail('Expected ok'),
        );
        verify(() => repository.getCheckInPaymentUrl(rentalId: 20)).called(1);
      },
    );
  });
}
