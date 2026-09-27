import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';
import 'package:rental_car/features/home/domain/usecases/get_stations_by_city_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late MockHomeRepository mockRepository;
  late GetStationsByCityUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetStationsByCityUseCase(repository: mockRepository);
  });

  test(
    'GetStationsByCityUseCase delegates to repository.getStationsByCity()',
    () async {
      const stations = [
        StationEntity(id: 3, name: 'Trạm Cầu Giấy', address: 'Xuân Thủy'),
      ];

      when(
        () => mockRepository.getStationsByCity('Hà Nội'),
      ).thenAnswer((_) async => const Result.ok(stations));

      final result = await useCase('Hà Nội');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, stations);
      verify(() => mockRepository.getStationsByCity('Hà Nội')).called(1);
    },
  );
}
