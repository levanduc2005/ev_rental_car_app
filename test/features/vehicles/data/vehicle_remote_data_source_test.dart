import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late VehicleRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = VehicleRemoteDataSourceImpl(dio: mockDio);
  });

  group('VehicleRemoteDataSourceImpl', () {
    test(
      'getVehicles without filter calls /vehicles/home or fallback',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/home'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/home'),
            statusCode: 200,
            data: {
              'data': [
                {'id': 1, 'name': 'VF8', 'brand': 'VINFAST'},
              ],
            },
          ),
        );

        final result = await dataSource.getVehicles();
        expect(result.length, 1);
        expect(result.first.id, 1);
      },
    );

    test(
      'getVehicles with availability filter calls /vehicles/filter/available',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/vehicles/filter/available',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/filter/available'),
            statusCode: 200,
            data: {
              'data': {
                'content': [
                  {'id': 1, 'name': 'VF8', 'brand': 'VINFAST'},
                ],
              },
            },
          ),
        );

        final filter = VehicleFilter(
          startTime: DateTime(2026, 10, 1, 8),
          endTime: DateTime(2026, 10, 1, 16),
        );

        final result = await dataSource.getVehicles(filter: filter);
        expect(result.length, 1);
        expect(result.first.id, 1);
      },
    );

    test('getVehicleDetail calls /vehicles/id/:id', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/vehicles/id/1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/id/1'),
          statusCode: 200,
          data: {
            'data': {'id': 1, 'name': 'VF8', 'brand': 'VINFAST'},
          },
        ),
      );

      final result = await dataSource.getVehicleDetail('1');
      expect(result.id, 1);
      expect(result.name, 'VF8');
    });

    test('getVehicleBrands calls /brands', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/brands')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/brands'),
          statusCode: 200,
          data: {
            'data': [
              {'name': 'VINFAST'},
              {'name': 'TESLA'},
            ],
          },
        ),
      );

      final result = await dataSource.getVehicleBrands();
      expect(result, ['VINFAST', 'TESLA']);
    });

    test('getVehicleCategories calls /vehicles/category', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/vehicles/category'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/category'),
          statusCode: 200,
          data: {
            'data': ['SUV', 'Sedan'],
          },
        ),
      );

      final result = await dataSource.getVehicleCategories();
      expect(result, ['SUV', 'Sedan']);
    });

    test('getBookingFees calls /vehicles/booking', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/vehicles/booking',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/booking'),
          statusCode: 200,
          data: {
            'data': [
              {
                'feeType': 'BOOKING_FEE',
                'description': 'Tien thue',
                'value': 1000000.0,
              },
            ],
          },
        ),
      );

      final result = await dataSource.getBookingFees(
        vehicleId: 1,
        startTime: DateTime(2026, 10, 1, 8),
        endTime: DateTime(2026, 10, 1, 16),
      );

      expect(result.bookingFee, 1000000.0);
    });

    test('getVehicleSchedule calls /vehicles/:id/schedule', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/vehicles/1/schedule'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/1/schedule'),
          statusCode: 200,
          data: {
            'data': [
              {
                'startTime': '2026-10-01T08:00:00Z',
                'endTime': '2026-10-01T12:00:00Z',
              },
            ],
          },
        ),
      );

      final result = await dataSource.getVehicleSchedule(1);
      expect(result.length, 1);
    });

    test(
      'getVehiclesPaginated calls /vehicles/filter/available with pagination',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/vehicles/filter/available',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/filter/available'),
            statusCode: 200,
            data: {
              'data': {
                'totalPages': 3,
                'content': [
                  {'id': 1, 'name': 'VF8', 'brand': 'VINFAST'},
                ],
              },
            },
          ),
        );

        final filter = VehicleFilter(
          startTime: DateTime(2026, 10, 1, 8),
          endTime: DateTime(2026, 10, 1, 16),
        );

        final result = await dataSource.getVehiclesPaginated(
          filter: filter,
          page: 2,
          limit: 10,
        );

        expect(result.models.length, 1);
        expect(result.currentPage, 2);
        expect(result.totalPages, 3);
      },
    );
  });
}
