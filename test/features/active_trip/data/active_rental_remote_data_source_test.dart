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

    test('getVehicleSchedule returns list of schedule models', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/vehicles/5/schedule'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/5/schedule'),
          data: {
            'data': [
              {
                'startTime': '2026-10-25T10:00:00Z',
                'endTime': '2026-10-25T14:00:00Z',
              },
            ],
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getVehicleSchedule(5);

      expect(result.length, 1);
      expect(result.first.startTime, DateTime.parse('2026-10-25T10:00:00Z'));
    });

    test(
      'extendRental posts newReturnTime ISO string and returns model',
      () async {
        final newReturnTime = DateTime(2026, 10, 25, 18);
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/100/extend',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/100/extend'),
            data: {
              'data': {
                'url': 'https://pay.payos.vn/web/100',
                'qrCode': 'https://img.vietqr.io/100.png',
              },
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.extendRental(
          rentalId: 100,
          newReturnTime: newReturnTime,
        );

        expect(result.url, 'https://pay.payos.vn/web/100');
        expect(result.qrCode, 'https://img.vietqr.io/100.png');
      },
    );

    test(
      'previewExtendRental posts newReturnTime ISO string and returns preview model',
      () async {
        final newReturnTime = DateTime(2026, 10, 25, 18);
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/100/preview-extend',
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/100/preview-extend'),
            data: {
              'data': {
                'additionalFee': 100000.0,
                'newRentFee': 1000000.0,
                'currentRentFee': 900000.0,
                'additionalHours': 1,
                'newReturnTime': '2026-10-25T18:00:00Z',
              },
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.previewExtendRental(
          rentalId: 100,
          newReturnTime: newReturnTime,
        );

        expect(result.additionalFee, 100000.0);
        expect(result.newRentFee, 1000000.0);
        expect(result.currentRentFee, 900000.0);
        expect(result.additionalHours, 1);
      },
    );

    test(
      'checkExtendPayment returns true when status is SUCCESS/PAID',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/payment/payos/check/rental/100',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: '/payment/payos/check/rental/100',
            ),
            data: {
              'data': {'status': 'SUCCESS'},
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.checkExtendPayment(100);
        expect(result, isTrue);
      },
    );
  });
}
