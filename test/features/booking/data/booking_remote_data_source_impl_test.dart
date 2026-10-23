import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source_impl.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late BookingRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = BookingRemoteDataSourceImpl(dio: mockDio);
  });

  group('BookingRemoteDataSourceImpl', () {
    final start = DateTime(2026, 10, 1, 8);
    final end = DateTime(2026, 10, 1, 16);

    test('calculateBookingFees parses list into BookingFeeModel', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/vehicles/booking',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/booking'),
          data: {
            'data': [
              {
                'description': 'Rental',
                'feeType': 'BOOKING_FEE',
                'value': 500000,
              },
              {
                'description': 'Total',
                'feeType': 'TOTAL_AMOUNT',
                'value': 500000,
              },
            ],
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.calculateBookingFees(
        vehicleId: 1,
        startTime: start,
        endTime: end,
      );

      expect(result.bookingFee, 500000);
      expect(result.totalAmount, 500000);
    });

    test('createReservation returns ReservationModel on success', () async {
      final request = CreateReservationRequestModel(
        userEmail: 'user@test.com',
        vehicleId: 1,
        stationId: 2,
        startTime: start,
        endTime: end,
      );

      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reservations',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reservations'),
          data: {
            'data': {'id': 10, 'code': 'RES-10', 'status': 'PENDING'},
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.createReservation(request);

      expect(result.id, 10);
      expect(result.code, 'RES-10');
    });

    test('getMyReservations returns list of models', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reservations/email',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reservations/email'),
          data: {
            'data': {
              'content': [
                {'id': 1, 'code': 'RES-01', 'status': 'CONFIRMED'},
              ],
            },
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getMyReservations(email: 'user@test.com');

      expect(result.length, 1);
      expect(result.first.code, 'RES-01');
    });

    test('getReservationDetail returns model on success', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/reservations/me/1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reservations/me/1'),
          data: {
            'data': {'id': 1, 'code': 'RES-01', 'status': 'CONFIRMED'},
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getReservationDetail(1);

      expect(result.id, 1);
      expect(result.code, 'RES-01');
    });

    test('cancelReservation returns true on success', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reservations/RES-01/cancel',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reservations/RES-01/cancel'),
          data: {'data': true},
          statusCode: 200,
        ),
      );

      final result = await dataSource.cancelReservation(
        'RES-01',
        reason: 'Change',
      );

      expect(result, isTrue);
    });

    test('getVehicleDetail returns vehicle summary model', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/vehicles/id/5'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles/id/5'),
          data: {
            'data': {'id': 5, 'name': 'VinFast VF5'},
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getVehicleDetail(5);

      expect(result.id, 5);
      expect(result.name, 'VinFast VF5');
    });

    test(
      'confirmPayOSPayment throws ServerException when status is not 200/201',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/payment/payos/confirm/RES-01',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: '/payment/payos/confirm/RES-01',
            ),
            data: {'status': 400, 'message': 'Chưa thanh toán'},
            statusCode: 200,
          ),
        );

        expect(
          () => dataSource.confirmPayOSPayment('RES-01'),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test('confirmPayOSPayment returns true when status is 200', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>('/payment/payos/confirm/RES-01'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payment/payos/confirm/RES-01'),
          data: {'status': 200},
          statusCode: 200,
        ),
      );

      final result = await dataSource.confirmPayOSPayment('RES-01');

      expect(result, isTrue);
    });

    test('createPayOSPaymentLink returns PayOS model', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>('/payment/payos/create-link/10'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/payment/payos/create-link/10'),
          data: {
            'data': {
              'orderCode': 'ORD-10',
              'amount': 500000,
              'accountNumber': '123',
              'accountName': 'EMOTION',
              'qrCode': 'https://qr.png',
            },
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.createPayOSPaymentLink(10);

      expect(result.orderCode, 'ORD-10');
      expect(result.amount, 500000.0);
    });

    test(
      'getSupportedBanks handles VietQR response and errors safely',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
            'https://api.vietqr.io/v2/banks',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'https://api.vietqr.io/v2/banks',
            ),
            data: {
              'data': [
                {'code': 'MB', 'shortName': 'MBBank'},
              ],
            },
            statusCode: 200,
          ),
        );

        final result = await dataSource.getSupportedBanks();

        expect(result.length, 1);
        expect(result.first.code, 'MB');

        when(
          () => mockDio.get<Map<String, dynamic>>(
            'https://api.vietqr.io/v2/banks',
          ),
        ).thenThrow(Exception('VietQR down'));

        final errorResult = await dataSource.getSupportedBanks();
        expect(errorResult, isEmpty);
      },
    );
  });
}
