import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/staff/data/datasources/staff_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late StaffRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = StaffRemoteDataSourceImpl(dio: mockDio);
  });

  group('StaffRemoteDataSourceImpl', () {
    test('getStaffProfile returns StaffProfileModel on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/users/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 200,
          data: {
            'data': {
              'id': 1,
              'email': 'staff@test.com',
              'fullName': 'Staff Name',
              'role': 'STAFF',
            },
          },
        ),
      );

      final result = await dataSource.getStaffProfile();
      expect(result.staffId, 1);
      expect(result.email, 'staff@test.com');
    });

    test('filterReservations calls /reservations/filter', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reservations/filter',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reservations/filter'),
          statusCode: 200,
          data: {
            'data': {
              'content': [
                {'id': 10, 'reservationCode': 'RES-10', 'status': 'CONFIRMED'},
              ],
            },
          },
        ),
      );

      final result = await dataSource.filterReservations();
      expect(result.length, 1);
      expect(result.first.id, 10);
    });

    test('filterRentals calls /rentals/filter', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals/filter',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/filter'),
          statusCode: 200,
          data: {
            'data': {
              'content': [
                {
                  'id': 20,
                  'status': 'ONGOING',
                  'vehicle': {'name': 'VF8'},
                },
              ],
            },
          },
        ),
      );

      final result = await dataSource.filterRentals();
      expect(result.length, 1);
      expect(result.first.id, 20);
    });

    test('convertReservationToRental calls /rentals/reservation', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals/reservation',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/reservation'),
          statusCode: 200,
          data: {
            'data': {
              'id': 25,
              'status': 'WAITING_PAYMENT',
              'vehicle': {'name': 'VF8'},
            },
          },
        ),
      );

      final result = await dataSource.convertReservationToRental(
        reservationCode: 'RES-10',
        staffId: 1,
      );
      expect(result.id, 25);
    });

    test('generateContract returns signing url string', () async {
      when(() => mockDio.post<dynamic>('/rentals/25/contract')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/25/contract'),
          statusCode: 200,
          data: {'data': 'https://docuseal.com/s/staff'},
        ),
      );

      final result = await dataSource.generateContract(25);
      expect(result, 'https://docuseal.com/s/staff');
    });

    test('getCheckInPaymentUrl returns payment url', () async {
      when(
        () => mockDio.get<dynamic>(
          '/rentals/check-inpayment',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/check-inpayment'),
          statusCode: 200,
          data: {'data': 'https://pay.vn/checkout'},
        ),
      );

      final result = await dataSource.getCheckInPaymentUrl(rentalId: 25);
      expect(result, 'https://pay.vn/checkout');
    });

    test('updateRentalStatus calls /rentals/status patch', () async {
      when(
        () => mockDio.patch<Map<String, dynamic>>(
          '/rentals/status',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/status'),
          statusCode: 200,
        ),
      );

      await dataSource.updateRentalStatus(rentalId: 25, status: 'ONGOING');
      verify(
        () => mockDio.patch<Map<String, dynamic>>(
          '/rentals/status',
          data: {'id': 25, 'status': 'ONGOING'},
        ),
      ).called(1);
    });

    test('submitCheckInChecklist calls /rental-checklists', () async {
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
              'id': 33,
              'rentalId': 25,
              'type': 'CHECK_IN',
              'currentBattery': 90.0,
            },
          },
        ),
      );

      final result = await dataSource.submitCheckInChecklist(
        rentalId: 25,
        staffEmail: 'staff@test.com',
        currentBattery: 90,
        img: 'in.jpg',
      );
      expect(result.id, 33);
    });

    test('getChecklists calls /rental-checklists/search', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          '/rental-checklists/search',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rental-checklists/search'),
          statusCode: 200,
          data: {
            'data': [
              {
                'id': 33,
                'rentalId': 25,
                'type': 'CHECK_IN',
                'currentBattery': 90.0,
              },
            ],
          },
        ),
      );

      final result = await dataSource.getChecklists();
      expect(result.length, 1);
    });

    test('getRenterByEmail returns RenterModel', () async {
      when(
        () =>
            mockDio.get<Map<String, dynamic>>('/users/renter/renter@test.com'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/renter/renter@test.com'),
          statusCode: 200,
          data: {
            'data': {
              'id': 8,
              'email': 'renter@test.com',
              'fullName': 'Renter A',
            },
          },
        ),
      );

      final result = await dataSource.getRenterByEmail('renter@test.com');
      expect(result.fullName, 'Renter A');
      expect(result.email, 'renter@test.com');
    });

    test('cancelRental calls /rentals/manage/:id/cancel', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>('/rentals/manage/25/cancel'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/manage/25/cancel'),
          statusCode: 200,
          data: {'data': true},
        ),
      );

      final result = await dataSource.cancelRental(25);
      expect(result, isTrue);
    });

    test('getStationVehicles returns filtered vehicles by stationId', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/vehicles')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/vehicles'),
          statusCode: 200,
          data: {
            'data': [
              {
                'id': 1,
                'name': 'VF 5',
                'brand': 'VINFAST',
                'station': {'id': 10, 'name': 'Station 10'},
              },
              {
                'id': 2,
                'name': 'VF 8',
                'brand': 'VINFAST',
                'station': {'id': 20, 'name': 'Station 20'},
              },
            ],
          },
        ),
      );

      final vehicles = await dataSource.getStationVehicles(10);
      expect(vehicles.length, 1);
      expect(vehicles.first.id, 1);
    });

    test('createRental calls /rentals and parses RentalDetailModel', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals'),
          statusCode: 200,
          data: {
            'data': {
              'id': 50,
              'status': 'PENDING',
              'vehicle': {'name': 'VF 3'},
            },
          },
        ),
      );

      final result = await dataSource.createRental(
        startTime: DateTime(2026, 10, 1, 8),
        endTime: DateTime(2026, 10, 1, 16),
        vehicleId: 1,
        email: 'user@test.com',
        staffId: 2,
      );

      expect(result.id, 50);
      expect(result.vehicleName, 'VF 3');
    });

    test(
      'generateContract and getCheckInPaymentUrl handle map and direct string formats',
      () async {
        // 1. generateContract with Map
        when(() => mockDio.post<dynamic>('/rentals/25/contract')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/25/contract'),
            statusCode: 200,
            data: {
              'data': {'signingUrl': 'https://docuseal.com/s/map'},
            },
          ),
        );
        final contractUrl = await dataSource.generateContract(25);
        expect(contractUrl, 'https://docuseal.com/s/map');

        // 2. getCheckInPaymentUrl with Map data['url']
        when(
          () => mockDio.get<dynamic>(
            '/rentals/check-inpayment',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/check-inpayment'),
            statusCode: 200,
            data: {
              'data': {'url': 'https://pay.vn/map-url'},
            },
          ),
        );
        final payUrl = await dataSource.getCheckInPaymentUrl(rentalId: 25);
        expect(payUrl, 'https://pay.vn/map-url');
      },
    );

    test(
      'parsing exceptions thrown when data is null across endpoints',
      () async {
        when(() => mockDio.get<Map<String, dynamic>>('/users/me')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/me'),
            statusCode: 200,
            data: {},
          ),
        );
        expect(
          () => dataSource.getStaffProfile(),
          throwsA(isA<ParsingException>()),
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/reservation',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/reservation'),
            statusCode: 200,
            data: {},
          ),
        );
        expect(
          () => dataSource.convertReservationToRental(
            reservationCode: 'C',
            staffId: 1,
          ),
          throwsA(isA<ParsingException>()),
        );

        when(() => mockDio.post<dynamic>('/rentals/25/contract')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/25/contract'),
            statusCode: 200,
            data: 123,
          ),
        );
        expect(
          () => dataSource.generateContract(25),
          throwsA(isA<ParsingException>()),
        );

        when(
          () => mockDio.get<dynamic>(
            '/rentals/check-inpayment',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/check-inpayment'),
            statusCode: 200,
            data: 123,
          ),
        );
        expect(
          () => dataSource.getCheckInPaymentUrl(rentalId: 25),
          throwsA(isA<ParsingException>()),
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rental-checklists',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rental-checklists'),
            statusCode: 200,
            data: {},
          ),
        );
        expect(
          () => dataSource.submitCheckInChecklist(
            rentalId: 1,
            staffEmail: 's',
            currentBattery: 10,
            img: 'i',
          ),
          throwsA(isA<ParsingException>()),
        );

        when(
          () => mockDio.get<Map<String, dynamic>>('/users/renter/bad@test.com'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/renter/bad@test.com'),
            statusCode: 200,
            data: {},
          ),
        );
        expect(
          () => dataSource.getRenterByEmail('bad@test.com'),
          throwsA(isA<ParsingException>()),
        );

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals'),
            statusCode: 200,
            data: {},
          ),
        );
        expect(
          () => dataSource.createRental(
            startTime: DateTime(2026, 10),
            endTime: DateTime(2026, 10, 2),
            vehicleId: 1,
            email: 'e',
            staffId: 1,
          ),
          throwsA(isA<ParsingException>()),
        );
      },
    );
  });
}
