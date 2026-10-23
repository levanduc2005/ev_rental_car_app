import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/emergency/data/datasources/emergency_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EmergencyRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = EmergencyRemoteDataSourceImpl(dio: mockDio);
  });

  group('EmergencyRemoteDataSourceImpl', () {
    test('submitReport returns SosReportModel on success', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reports',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reports'),
          data: {
            'data': {
              'id': 1,
              'title': 'SOS',
              'description': 'Flat tire',
              'type': 'FLAT_TIRE',
            },
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.submitReport(
        title: 'SOS',
        description: 'Flat tire',
        type: 'FLAT_TIRE',
        userEmail: 'driver@test.com',
      );

      expect(result.id, 1);
      expect(result.title, 'SOS');
    });

    test('getEmergencyReports returns list on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/reports')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reports'),
          data: {
            'data': [
              {'id': 1, 'title': 'SOS 1'},
            ],
          },
          statusCode: 200,
        ),
      );

      final result = await dataSource.getEmergencyReports();

      expect(result.length, 1);
      expect(result.first.title, 'SOS 1');
    });

    test(
      'uploadIncidentImage throws ServerException when file does not exist',
      () async {
        expect(
          () => dataSource.uploadIncidentImage('/non/existent/path/photo.jpg'),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
