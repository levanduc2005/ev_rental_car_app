import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';
import 'package:rental_car/features/home/domain/usecases/get_home_vehicles_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetHomeVehiclesUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
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
