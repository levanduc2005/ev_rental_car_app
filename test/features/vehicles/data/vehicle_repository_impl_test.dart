import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:rental_car/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';

class MockVehicleRemoteDataSource extends Mock
    implements VehicleRemoteDataSource {}

void main() {
  late MockVehicleRemoteDataSource remoteDataSource;
  late VehicleRepositoryImpl repository;

  setUp(() {
    remoteDataSource = MockVehicleRemoteDataSource();
    repository = VehicleRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('VehicleRepositoryImpl', () {
    const model = VehicleModel(
      id: 1,
      name: 'VinFast VF8',
      brand: 'VinFast',
      plateNumber: '51K-12345',
    );

    test('getVehicles returns list of VehicleEntity on success', () async {
      when(
        () => remoteDataSource.getVehicles(filter: any(named: 'filter')),
      ).thenAnswer((_) async => [model]);

      final result = await repository.getVehicles();

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) => expect(list.first.name, 'VinFast VF8'),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getHomeVehicles returns list on success', () async {
      when(
        () => remoteDataSource.getVehicles(),
      ).thenAnswer((_) async => [model]);

      final result = await repository.getHomeVehicles();

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) => expect(list.length, 1),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getVehicleDetail returns entity on success', () async {
      when(
        () => remoteDataSource.getVehicleDetail('1'),
      ).thenAnswer((_) async => model);

      final result = await repository.getVehicleDetail('1');

      expect(result.isOk, isTrue);
      result.when(
        ok: (entity) => expect(entity.id, 1),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getVehicleBrands returns list of strings', () async {
      when(
        () => remoteDataSource.getVehicleBrands(),
      ).thenAnswer((_) async => ['VinFast', 'Tesla']);

      final result = await repository.getVehicleBrands();

      expect(result.isOk, isTrue);
      result.when(
        ok: (brands) => expect(brands, ['VinFast', 'Tesla']),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getVehicleCategories returns list of strings', () async {
      when(
        () => remoteDataSource.getVehicleCategories(),
      ).thenAnswer((_) async => ['SUV', 'Sedan']);

      final result = await repository.getVehicleCategories();

      expect(result.isOk, isTrue);
      result.when(
        ok: (categories) => expect(categories, ['SUV', 'Sedan']),
        err: (_) => fail('Expected ok'),
      );
    });

    test('getBookingFees returns breakdown on success', () async {
      const breakdown = BookingFeeBreakdown(fees: [], totalAmount: 1000000);

      final start = DateTime(2026, 10, 1, 8);
      final end = DateTime(2026, 10, 1, 16);

      when(
        () => remoteDataSource.getBookingFees(
          vehicleId: 1,
          startTime: start,
          endTime: end,
        ),
      ).thenAnswer((_) async => breakdown);

      final result = await repository.getBookingFees(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.isOk, isTrue);
    });

    test('getVehicleSchedule returns schedule list', () async {
      final slot = VehicleScheduleSlot(
        startTime: DateTime(2026, 10, 1, 8),
        endTime: DateTime(2026, 10, 1, 12),
      );

      when(
        () => remoteDataSource.getVehicleSchedule(1),
      ).thenAnswer((_) async => [slot]);

      final result = await repository.getVehicleSchedule(1);

      expect(result.isOk, isTrue);
    });

    test('getVehiclesPaginated returns PaginatedVehicles', () async {
      const paginatedResult = PaginatedVehicleModels(
        models: [model],
        currentPage: 1,
        totalPages: 2,
      );

      when(
        () =>
            remoteDataSource.getVehiclesPaginated(filter: any(named: 'filter')),
      ).thenAnswer((_) async => paginatedResult);

      final result = await repository.getVehiclesPaginated();

      expect(result.isOk, isTrue);
      result.when(
        ok: (paginated) {
          expect(paginated.vehicles.length, 1);
          expect(paginated.currentPage, 1);
          expect(paginated.totalPages, 2);
          expect(paginated.hasNextPage, isTrue);
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test(
      'returns ServerFailure when remoteDataSource throws ServerException',
      () async {
        when(
          () => remoteDataSource.getVehicleBrands(),
        ).thenThrow(const ServerException(message: 'Error fetching brands'));

        final result = await repository.getVehicleBrands();

        expect(result.isErr, isTrue);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (f) => expect(f, isA<ServerFailure>()),
        );
      },
    );
  });
}
