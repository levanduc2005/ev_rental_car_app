import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/get_station_vehicles_usecase.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late GetStationVehiclesUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = GetStationVehiclesUseCase(repository);
  });

  group('GetStationVehiclesUseCase', () {
    test('delegates to repository.getStationVehicles(stationId)', () async {
      final List<VehicleEntity> vehicles = [
        const VehicleEntity(
          id: 1,
          name: 'VF 5 Plus',
          brand: 'VinFast',
          pricePerDay: 800000,
          batteryCapacity: 37,
        ),
      ];

      when(
        () => repository.getStationVehicles(2),
      ).thenAnswer((_) async => Result.ok(vehicles));

      final result = await useCase(2);

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list.first.name, 'VF 5 Plus');
        },
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.getStationVehicles(2)).called(1);
    });

    test('returns failure when repository fails', () async {
      when(() => repository.getStationVehicles(any())).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Error')),
      );

      final result = await useCase(2);

      expect(result.isErr, isTrue);
    });
  });
}
