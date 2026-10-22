import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_vehicle_log_by_rental_id_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;
  late GetVehicleLogByRentalIdUseCase useCase;

  setUp(() {
    repository = MockCheckoutRepository();
    useCase = GetVehicleLogByRentalIdUseCase(repository);
  });

  group('GetVehicleLogByRentalIdUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(0);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected failure'),
        err: (f) => expect(f, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository when rentalId is valid', () async {
      const log = VehicleLogEntity(
        id: 10,
        rentalId: 42,
        vehicleId: 99,
        cost: 250000,
        repairItems: [
          VehicleDamageItemEntity(description: 'Trầy sơn cửa', cost: 250000),
        ],
      );

      when(
        () => repository.getVehicleLogByRentalId(42),
      ).thenAnswer((_) async => const Result.ok(log));

      final result = await useCase(42);

      expect(result.isOk, isTrue);
      result.when(
        ok: (data) {
          expect(data?.id, 10);
          expect(data?.cost, 250000);
          expect(data?.repairItems.first.description, 'Trầy sơn cửa');
        },
        err: (_) => fail('Expected success'),
      );
      verify(() => repository.getVehicleLogByRentalId(42)).called(1);
    });

    test('returns failure when repository returns failure', () async {
      when(() => repository.getVehicleLogByRentalId(42)).thenAnswer(
        (_) async => const Result.err(
          ServerFailure(message: 'Internal server error', statusCode: 500),
        ),
      );

      final result = await useCase(42);

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected failure'),
        err: (f) => expect(f, isA<ServerFailure>()),
      );
      verify(() => repository.getVehicleLogByRentalId(42)).called(1);
    });
  });
}
