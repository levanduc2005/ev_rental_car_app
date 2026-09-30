import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/home/data/datasources/home_remote_data_source.dart';
import 'package:rental_car/features/home/data/repositories/home_repository_impl.dart';
import 'package:rental_car/features/vehicles/data/models/station_model.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late MockHomeRemoteDataSource mockRemoteDataSource;
  late HomeRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('HomeRepositoryImpl', () {
    test(
      'getStationsByCity returns list of StationEntity when successful',
      () async {
        const stationModels = [
          StationModel(id: 3, name: 'Trạm Cầu Giấy', address: 'Xuân Thủy'),
        ];

        when(
          () => mockRemoteDataSource.getStationsByCity('Hà Nội'),
        ).thenAnswer((_) async => stationModels);

        final result = await repository.getStationsByCity('Hà Nội');

        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.name, 'Trạm Cầu Giấy');
        verify(
          () => mockRemoteDataSource.getStationsByCity('Hà Nội'),
        ).called(1);
      },
    );
  });
}
