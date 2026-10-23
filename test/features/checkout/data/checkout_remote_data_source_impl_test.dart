import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source_impl.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late CheckoutRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = CheckoutRemoteDataSourceImpl(dio: mockDio);
  });

  group('CheckoutRemoteDataSourceImpl', () {
    test(
      'getChecklistsByRentalId returns list of RentalChecklistModel',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>(
            '/rental-checklists/rentalId',
            queryParameters: {'rentalId': 10},
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rental-checklists/rentalId'),
            statusCode: 200,
            data: {
              'data': [
                {
                  'id': 1,
                  'rentalId': 10,
                  'type': 'CHECK_OUT',
                  'currentBattery': 80,
                },
              ],
            },
          ),
        );

        final result = await dataSource.getChecklistsByRentalId(10);
        expect(result.length, 1);
        expect(result.first.id, 1);
      },
    );

    test(
      'createChecklist calls /rental-checklists and returns model',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rental-checklists',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rental-checklists'),
            statusCode: 200,
            data: {
              'data': {
                'id': 2,
                'rentalId': 10,
                'type': 'CHECK_OUT',
                'currentBattery': 75.0,
              },
            },
          ),
        );

        final result = await dataSource.createChecklist(
          rentalId: 10,
          type: 'CHECK_OUT',
          currentBattery: 75.0,
          img: 'out.jpg',
          staffEmail: 'staff@test.com',
        );

        expect(result.id, 2);
      },
    );

    test('updateChecklist calls PUT and returns model', () async {
      when(
        () => mockDio.put<Map<String, dynamic>>(
          '/rental-checklists/2',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rental-checklists/2'),
          statusCode: 200,
          data: {
            'data': {
              'id': 2,
              'rentalId': 10,
              'type': 'CHECK_OUT',
              'currentBattery': 75.0,
            },
          },
        ),
      );

      final result = await dataSource.updateChecklist(
        id: 2,
        rentalId: 10,
        type: 'CHECK_OUT',
        currentBattery: 75.0,
        img: 'out.jpg',
        staffEmail: 'staff@test.com',
      );

      expect(result.id, 2);
    });

    test('getVehicleLogByRentalId returns log if found', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/rentals/10/details'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/10/details'),
          statusCode: 200,
          data: {
            'data': {
              'vehicleLog': {
                'id': 99,
                'rentalId': 10,
                'vehicleId': 4,
                'cost': 200000,
              },
            },
          },
        ),
      );

      final result = await dataSource.getVehicleLogByRentalId(10);
      expect(result?.id, 99);
    });

    test(
      'createOrUpdateVehicleLog creates new log when logId is null',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/vehicleLogs',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicleLogs'),
            statusCode: 200,
            data: {
              'data': {
                'id': 55,
                'rentalId': 10,
                'vehicleId': 4,
                'cost': 150000,
              },
            },
          ),
        );

        final result = await dataSource.createOrUpdateVehicleLog(
          rentalId: 10,
          vehicleId: 4,
          repairItems: [],
          imgs: [],
          staffId: 1,
        );

        expect(result.id, 55);
      },
    );

    test(
      'createOrUpdateVehicleLog updates existing log when logId is provided',
      () async {
        when(
          () => mockDio.put<Map<String, dynamic>>(
            '/vehicleLogs/55',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/vehicleLogs/55'),
            statusCode: 200,
            data: {
              'data': {
                'id': 55,
                'rentalId': 10,
                'vehicleId': 4,
                'cost': 300000,
              },
            },
          ),
        );

        final result = await dataSource.createOrUpdateVehicleLog(
          rentalId: 10,
          vehicleId: 4,
          repairItems: [],
          imgs: [],
          staffId: 1,
          logId: 55,
        );

        expect(result.id, 55);
      },
    );

    test('getRentalOverview returns RentalOverviewModel', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/rentals/10/overview'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/10/overview'),
          statusCode: 200,
          data: {
            'data': {
              'rentalResponse': {
                'id': 10,
                'vehicle': {'id': 1, 'name': 'VF8'},
              },
            },
          },
        ),
      );

      final result = await dataSource.getRentalOverview(10);
      expect(result.rentalId, 10);
      expect(result.vehicleName, 'VF8');
    });

    test('processCheckoutPayment returns response data', () async {
      when(
        () =>
            mockDio.post<Map<String, dynamic>>('/rentals/10/check-outpayment'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/10/check-outpayment'),
          statusCode: 200,
          data: {
            'data': {'status': 'SUCCESS'},
          },
        ),
      );

      final result = await dataSource.processCheckoutPayment(10);
      expect(result['status'], 'SUCCESS');
    });

    test('createRentalCompensationPaymentLink returns PayOS model', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/payment/payos/create-link/rental/10',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(
            path: '/payment/payos/create-link/rental/10',
          ),
          statusCode: 200,
          data: {
            'data': {
              'orderCode': 'LINK1',
              'checkoutUrl': 'https://payos.vn/gate/1',
              'qrCode': 'https://qr.payos.vn/1',
              'amount': 500000,
            },
          },
        ),
      );

      final result = await dataSource.createRentalCompensationPaymentLink(
        10,
        amount: 500000,
      );
      expect(result.orderCode, 'LINK1');
      expect(result.amount, 500000);
    });

    test(
      'checkRentalCompensationPayment returns true on PAID/SUCCESS',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/payment/payos/check/rental/10',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: '/payment/payos/check/rental/10',
            ),
            statusCode: 200,
            data: {
              'data': {'status': 'PAID'},
            },
          ),
        );

        final result = await dataSource.checkRentalCompensationPayment(10);
        expect(result, isTrue);
      },
    );
  });
}
