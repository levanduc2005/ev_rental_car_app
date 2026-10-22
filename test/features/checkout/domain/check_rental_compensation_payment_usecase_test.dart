import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/check_rental_compensation_payment_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;
  late CheckRentalCompensationPaymentUseCase useCase;

  setUp(() {
    repository = MockCheckoutRepository();
    useCase = CheckRentalCompensationPaymentUseCase(repository);
  });

  group('CheckRentalCompensationPaymentUseCase', () {
    test(
      'delegates to repository and returns true when payment is confirmed',
      () async {
        when(
          () => repository.checkRentalCompensationPayment(10),
        ).thenAnswer((_) async => const Result.ok(true));

        final result = await useCase(10);

        expect(result.isOk, isTrue);
        result.when(
          ok: (isPaid) => expect(isPaid, isTrue),
          err: (_) => fail('Expected ok'),
        );
        verify(() => repository.checkRentalCompensationPayment(10)).called(1);
      },
    );

    test('returns Failure when repository returns failure', () async {
      when(() => repository.checkRentalCompensationPayment(10)).thenAnswer(
        (_) async =>
            const Result.err(ServerFailure(message: 'Lỗi kiểm tra thanh toán')),
      );

      final result = await useCase(10);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected failure'),
        err: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Lỗi kiểm tra thanh toán');
        },
      );
      verify(() => repository.checkRentalCompensationPayment(10)).called(1);
    });
  });
}
