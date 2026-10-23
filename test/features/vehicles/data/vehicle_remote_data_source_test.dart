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

    test(
      'getVehicles with complex filter exercises brand mapping, category mapping, seat count and pricing',
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
                  {'id': 1, 'name': 'Mercedes EQE', 'brand': 'MERCEDES_BENZ'},
                ],
              },
            },
          ),
        );

        final filter = VehicleFilter(
          startTime: DateTime(2026, 10, 1, 8),
          endTime: DateTime(2026, 10, 1, 16),
          city: 'Hà Nội',
          brand: 'MERCEDES_BENZ',
          carType: 'BÁN TẢI',
          seats: '5 chỗ',
          stationId: 10,
          priceRange: '2M - 4M',
        );

        final result = await dataSource.getVehicles(filter: filter);
        expect(result.length, 1);
        expect(result.first.brand, 'MERCEDES_BENZ');
      },
    );

    test(
      'getVehicles falls back across /vehicles/brand, /vehicles/home, /vehicles and static defaults with filters',
      () async {
        // 1. /vehicles/brand succeeds
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/brand/TESLA'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/brand/TESLA'),
            statusCode: 200,
            data: {
              'data': [
                {'id': 5, 'name': 'Tesla Model 3', 'brand': 'TESLA'},
              ],
            },
          ),
        );

        final brandVehicles = await dataSource.getVehicles(
          filter: const VehicleFilter(brand: 'TESLA'),
        );
        expect(brandVehicles.length, 1);

        // 2. /vehicles/home throws, /vehicles throws -> falls back to static vehicles with client-side filtering
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/home'),
        ).thenThrow(Exception('offline'));
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles'),
        ).thenThrow(Exception('offline'));

        final staticFiltered = await dataSource.getVehicles(
          filter: const VehicleFilter(
            city: 'Hồ Chí Minh',
            brand: 'VINFAST',
            seats: '5 chỗ',
            carType: 'SUV',
            search: 'VF',
          ),
        );
        expect(staticFiltered, isNotEmpty);
        expect(staticFiltered.first.brand, 'VINFAST');
      },
    );

    test(
      'getVehicleDetail falls back to static detailed extra when remote fails',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/id/999'),
        ).thenThrow(Exception('404'));

        final fallback = await dataSource.getVehicleDetail('999');
        expect(fallback.id, 1); // defaults to first static fallback
        expect(fallback.description, isNotEmpty);
        expect(fallback.main, contains('?q=80'));
      },
    );

    test(
      'getVehicleBrands falls back to /vehicles/brand and default brands on failure',
      () async {
        // 1. /brands throws -> /vehicles/brand succeeds
        when(
          () => mockDio.get<Map<String, dynamic>>('/brands'),
        ).thenThrow(Exception('404'));
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/brand'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/brand'),
            statusCode: 200,
            data: {
              'data': ['TESLA', 'BYD'],
            },
          ),
        );

        final b1 = await dataSource.getVehicleBrands();
        expect(b1, ['TESLA', 'BYD']);

        // 2. Both throw -> returns static fallback brands
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/brand'),
        ).thenThrow(Exception('500'));

        final b2 = await dataSource.getVehicleBrands();
        expect(b2, contains('VINFAST'));
        expect(b2, contains('TESLA'));
      },
    );

    test(
      'getVehicleCategories, getBookingFees, and getVehicleSchedule handle empty/invalid responses',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/category'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/category'),
            statusCode: 200,
            data: {'data': null},
          ),
        );
        final cats = await dataSource.getVehicleCategories();
        expect(cats, isEmpty);

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/vehicles/booking',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/booking'),
            statusCode: 200,
            data: {'data': <dynamic>[]},
          ),
        );
        final fees = await dataSource.getBookingFees(
          vehicleId: 1,
          startTime: DateTime(2026, 10, 1, 8),
          endTime: DateTime(2026, 10, 1, 12),
        );
        expect(fees.fees, isEmpty);

        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/1/schedule'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/1/schedule'),
            statusCode: 200,
            data: {'data': <dynamic>[]},
          ),
        );
        final sched = await dataSource.getVehicleSchedule(1);
        expect(sched, isEmpty);
      },
    );

    test(
      'getVehiclesPaginated falls back to getVehicles when no availability conditions',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/vehicles/home'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicles/home'),
            statusCode: 200,
            data: {
              'data': [
                {'id': 1, 'name': 'VF 3', 'brand': 'VINFAST'},
              ],
            },
          ),
        );

        final paginated = await dataSource.getVehiclesPaginated();
        expect(paginated.models.length, 1);
        expect(paginated.totalPages, 1);
      },
    );
  });
}
