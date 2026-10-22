import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_or_update_vehicle_log_usecase.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository repository;
  late CreateOrUpdateVehicleLogUseCase useCase;

  setUp(() {
    repository = MockCheckoutRepository();
    useCase = CreateOrUpdateVehicleLogUseCase(repository);
  });

  group('CreateOrUpdateVehicleLogUseCase', () {
    test('returns DataFailure when rentalId or vehicleId <= 0', () async {
      final result = await useCase(
        rentalId: 0,
        vehicleId: 5,
        repairItems: const [],
        imgs: const [],
      );

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<DataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('delegates to repository on valid parameters', () async {
      const log = VehicleLogEntity(
        id: 1,
        rentalId: 10,
        vehicleId: 2,
        cost: 300000,
        repairItems: [
          VehicleDamageItemEntity(description: 'Xước cản trước', cost: 300000),
        ],
      );

      when(
        () => repository.createOrUpdateVehicleLog(
          rentalId: 10,
          vehicleId: 2,
          repairItems: [
            {'description': 'Xước cản trước', 'cost': 300000},
          ],
          imgs: const ['https://image.com/scratch.jpg'],
          staffId: 99,
        ),
      ).thenAnswer((_) async => const Result.ok(log));

      final result = await useCase(
        rentalId: 10,
        vehicleId: 2,
        repairItems: const [
          {'description': 'Xước cản trước', 'cost': 300000},
        ],
        imgs: const ['https://image.com/scratch.jpg'],
        staffId: 99,
      );

      expect(result.isOk, isTrue);
      result.when(
        ok: (data) {
          expect(data.id, 1);
          expect(data.hasDamages, isTrue);
          expect(data.cost, 300000);
        },
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.createOrUpdateVehicleLog(
          rentalId: 10,
          vehicleId: 2,
          repairItems: [
            {'description': 'Xước cản trước', 'cost': 300000},
          ],
          imgs: const ['https://image.com/scratch.jpg'],
          staffId: 99,
        ),
      ).called(1);
    });
  });
}
