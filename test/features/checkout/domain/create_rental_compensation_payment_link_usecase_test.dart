import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_rental_compensation_payment_link_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;
  late CreateRentalCompensationPaymentLinkUseCase useCase;

  setUp(() {
    repository = MockCheckoutRepository();
    useCase = CreateRentalCompensationPaymentLinkUseCase(repository);
  });

  group('CreateRentalCompensationPaymentLinkUseCase', () {
    test(
      'delegates to repository and returns payment info entity on success',
      () async {
        const paymentInfo = PayOSPaymentInfoEntity(
          orderCode: '1729571234',
          amount: 200000,
          description: 'DEN BU DON 10',
          accountNumber: '0909123456',
          accountName: 'CONG TY E-MOTION',
          qrCodeUrl:
              'https://img.vietqr.io/image/970422-0909123456-compact2.png',
          bin: '970422',
          bankName: 'MBBank',
          checkoutUrl: 'https://pay.payos.vn/web/a1b2c3',
        );

        when(
          () => repository.createRentalCompensationPaymentLink(
            10,
            amount: 200000,
          ),
        ).thenAnswer((_) async => const Result.ok(paymentInfo));

        final result = await useCase(10, amount: 200000);

        expect(result.isOk, isTrue);
        result.when(
          ok: (data) {
            expect(data.orderCode, '1729571234');
            expect(data.amount, 200000);
            expect(data.accountNumber, '0909123456');
            expect(data.bankName, 'MBBank');
          },
          err: (_) => fail('Expected ok'),
        );
        verify(
          () => repository.createRentalCompensationPaymentLink(
            10,
            amount: 200000,
          ),
        ).called(1);
      },
    );

    test('returns Failure when repository fails', () async {
      when(
        () =>
            repository.createRentalCompensationPaymentLink(10, amount: 200000),
      ).thenAnswer(
        (_) async =>
            const Result.err(ServerFailure(message: 'Lỗi tạo link PayOS')),
      );

      final result = await useCase(10, amount: 200000);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected failure'),
        err: (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Lỗi tạo link PayOS');
        },
      );
      verify(
        () =>
            repository.createRentalCompensationPaymentLink(10, amount: 200000),
      ).called(1);
    });
  });
}
