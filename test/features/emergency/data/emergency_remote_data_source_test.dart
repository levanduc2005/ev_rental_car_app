import 'dart:io';
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
        await expectLater(
          dataSource.uploadIncidentImage('/non/existent/path/photo.jpg'),
          throwsA(isA<ServerException>()),
        );
      },
    );

    test(
      'uploadIncidentImage handles success, empty url, and error responses',
      () async {
        final mockCloudinaryDio = MockDio();
        final customDataSource = EmergencyRemoteDataSourceImpl(
          dio: mockDio,
          cloudinaryDio: mockCloudinaryDio,
        );

        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/incident.jpg');
        await tempFile.writeAsString('test image bytes');

        // 1. Success
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/upload'),
            statusCode: 200,
            data: {'secure_url': 'https://cloudinary.com/incident.jpg'},
          ),
        );

        final url = await customDataSource.uploadIncidentImage(tempFile.path);
        expect(url, 'https://cloudinary.com/incident.jpg');

        // 2. Empty secure_url
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/upload'),
            statusCode: 200,
            data: {'secure_url': ''},
          ),
        );

        await expectLater(
          customDataSource.uploadIncidentImage(tempFile.path),
          throwsA(isA<ServerException>()),
        );

        // 3. DioException with error object
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/upload'),
            response: Response(
              requestOptions: RequestOptions(path: '/upload'),
              statusCode: 400,
              data: {
                'error': {'message': 'Image resolution invalid'},
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        await expectLater(
          customDataSource.uploadIncidentImage(tempFile.path),
          throwsA(isA<ServerException>()),
        );

        // 4. Generic Exception
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(Exception('Disk read failure'));

        await expectLater(
          customDataSource.uploadIncidentImage(tempFile.path),
          throwsA(isA<ServerException>()),
        );

        await tempDir.delete(recursive: true);
      },
    );

    test('submitReport throws ParsingException when data is null', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/reports',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/reports'),
          statusCode: 200,
          data: {'data': null},
        ),
      );

      await expectLater(
        dataSource.submitReport(title: 'T', description: 'D', type: 'OTHER'),
        throwsA(isA<ParsingException>()),
      );
    });

    test(
      'getEmergencyReports returns empty list when data is not List',
      () async {
        when(() => mockDio.get<Map<String, dynamic>>('/reports')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/reports'),
            statusCode: 200,
            data: {'data': null},
          ),
        );

        final result = await dataSource.getEmergencyReports();
        expect(result, isEmpty);
      },
    );
  });
}
