import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/home/data/datasources/home_remote_data_source.dart';
import 'package:rental_car/features/home/data/models/station_model.dart';
import 'package:rental_car/features/home/data/models/vehicle_model.dart';
import 'package:rental_car/features/home/data/repositories/home_repository_impl.dart';

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
      'getHomeVehicles returns list of VehicleEntity when successful',
      () async {
        const models = [
          VehicleModel(
            id: 1,
            name: 'VinFast VF 8',
            brand: 'VINFAST',
            seats: 5,
            priceRate: 1450000.0,
            hourRate: 720000.0,
          ),
        ];

        when(
          () => mockRemoteDataSource.getHomeVehicles(),
        ).thenAnswer((_) async => models);

        final result = await repository.getHomeVehicles();

        expect(result.isOk, isTrue);
        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.name, 'VinFast VF 8');
        verify(() => mockRemoteDataSource.getHomeVehicles()).called(1);
      },
    );

    test('getHomeVehicles returns ServerFailure on ServerException', () async {
      when(() => mockRemoteDataSource.getHomeVehicles()).thenThrow(
        const ServerException(statusCode: 500, message: 'Máy chủ bận'),
      );

      final result = await repository.getHomeVehicles();

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
      expect(result.failureOrNull?.message, 'Máy chủ bận');
    });

    test('getVehicleBrands returns list of brand strings', () async {
      final brands = ['VINFAST', 'TESLA', 'BMW'];

      when(
        () => mockRemoteDataSource.getVehicleBrands(),
      ).thenAnswer((_) async => brands);

      final result = await repository.getVehicleBrands();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, containsAll(['VINFAST', 'TESLA', 'BMW']));
      verify(() => mockRemoteDataSource.getVehicleBrands()).called(1);
    });

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
