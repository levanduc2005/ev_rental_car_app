import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ActiveRentalRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = ActiveRentalRemoteDataSourceImpl(dio: mockDio);
  });

  group('ActiveRentalRemoteDataSourceImpl', () {
    final backendData = {
      'data': {
        'id': 100,
        'status': 'ONGOING',
        'startTime': '2026-10-01T08:00:00Z',
        'endTime': '2026-10-01T16:00:00Z',
        'vehicle': {'id': 1, 'name': 'VinFast VF8', 'plateNumber': '51K-12345'},
      },
    };

    test(
      'getRentalDetail returns ActiveRentalModel on primary endpoint success',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/100'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/me/details/100'),
            data: backendData,
            statusCode: 200,
          ),
        );

        final result = await dataSource.getRentalDetail(100);

        expect(result.id, 100);
        expect(result.vehicleName, 'VinFast VF8');
      },
    );

    test(
      'getRentalDetail falls back to secondary endpoint on DioException',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/100'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/rentals/me/details/100'),
            type: DioExceptionType.badResponse,
          ),
        );

        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/100/details'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/100/details'),
            data: backendData,
            statusCode: 200,
          ),
        );

        final result = await dataSource.getRentalDetail(100);

        expect(result.id, 100);
        expect(result.vehicleName, 'VinFast VF8');
      },
    );

    test('getCurrentActiveRental returns null when content is empty', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals/email',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/email'),
          data: {
            'data': {'content': <dynamic>[]},
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getCurrentActiveRental(
        email: 'user@test.com',
      );

      expect(result, isNull);
    });

    test(
      'getCurrentActiveRental calls getRentalDetail when active rental exists in list',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/email',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/email'),
            data: {
              'data': {
                'content': [
                  {'id': 100},
                ],
              },
            },
            statusCode: 200,
          ),
        );

        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/100'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/me/details/100'),
            data: backendData,
            statusCode: 200,
          ),
        );

        final result = await dataSource.getCurrentActiveRental(
          email: 'user@test.com',
        );

        expect(result, isNotNull);
        expect(result?.id, 100);
      },
    );
  });
}
