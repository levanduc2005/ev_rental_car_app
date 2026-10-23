import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_checklists_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_rental_overview_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/process_checkout_payment_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;

  setUp(() {
    repository = MockCheckoutRepository();
  });

  group('GetChecklistsByRentalIdUseCase', () {
    test('delegates to repository.getChecklistsByRentalId', () async {
      final useCase = GetChecklistsByRentalIdUseCase(repository);
      const checklist = RentalChecklistEntity(
        id: 1,
        rentalId: 10,
        type: 'CHECK_OUT',
        currentBattery: 80,
      );

      when(
        () => repository.getChecklistsByRentalId(10),
      ).thenAnswer((_) async => const Result.ok([checklist]));

      final result = await useCase(10);

      expect(result.isOk, isTrue);
      verify(() => repository.getChecklistsByRentalId(10)).called(1);
    });
  });

  group('GetRentalOverviewUseCase', () {
    test('delegates to repository.getRentalOverview', () async {
      final useCase = GetRentalOverviewUseCase(repository);
      const overview = RentalOverviewEntity(
        rentalId: 10,
        reservationDeposit: 500000,
      );

      when(
        () => repository.getRentalOverview(10),
      ).thenAnswer((_) async => const Result.ok(overview));

      final result = await useCase(10);

      expect(result.isOk, isTrue);
      verify(() => repository.getRentalOverview(10)).called(1);
    });
  });

  group('ProcessCheckoutPaymentUseCase', () {
    test('delegates to repository.processCheckoutPayment', () async {
      final useCase = ProcessCheckoutPaymentUseCase(repository);

      when(
        () => repository.processCheckoutPayment(10),
      ).thenAnswer((_) async => const Result.ok({'status': 'SUCCESS'}));

      final result = await useCase(10);

      expect(result.isOk, isTrue);
      verify(() => repository.processCheckoutPayment(10)).called(1);
    });
  });
}
