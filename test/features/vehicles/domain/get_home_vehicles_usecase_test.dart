import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:rental_car/features/vehicles/domain/usecases/get_home_vehicles_usecase.dart';

class MockVehicleRepository extends Mock implements VehicleRepository {}

void main() {
  late MockVehicleRepository mockRepository;
  late GetHomeVehiclesUseCase useCase;

  setUp(() {
    mockRepository = MockVehicleRepository();
    useCase = GetHomeVehiclesUseCase(mockRepository);
  });

  test(
    'GetHomeVehiclesUseCase delegates to repository.getHomeVehicles()',
    () async {
      const vehicles = [
        VehicleEntity(id: 1, name: 'VinFast VF 8', brand: 'VINFAST', seats: 5),
      ];

      when(
        () => mockRepository.getHomeVehicles(),
      ).thenAnswer((_) async => const Result.ok(vehicles));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, vehicles);
      verify(() => mockRepository.getHomeVehicles()).called(1);
    },
  );
}
