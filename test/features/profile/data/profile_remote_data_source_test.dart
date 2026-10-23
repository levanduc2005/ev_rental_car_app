import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/profile/data/datasources/profile_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockDio mockDio;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    dataSource = ProfileRemoteDataSourceImpl(
      dio: mockDio,
      authLocalDataSource: mockAuthLocalDataSource,
    );
  });

  group('ProfileRemoteDataSourceImpl', () {
    test('getProfile returns UserProfileModel on success', () async {
      when(() => mockDio.get<Map<String, dynamic>>('/users/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 200,
          data: {
            'data': {
              'id': 1,
              'email': 'user@test.com',
              'fullName': 'Test User',
              'phone': '0901234567',
            },
          },
        ),
      );

      final result = await dataSource.getProfile();
      expect(result.email, 'user@test.com');
      expect(result.fullName, 'Test User');
    });

    test(
      'updateProfile calls /users/me/update-profile and returns model',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/users/me/update-profile',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/me/update-profile'),
            statusCode: 200,
            data: {
              'data': {
                'id': 1,
                'email': 'user@test.com',
                'fullName': 'Updated Name',
                'phone': '0901234567',
              },
            },
          ),
        );

        final result = await dataSource.updateProfile(
          fullName: 'Updated Name',
          phone: '0901234567',
        );
        expect(result.fullName, 'Updated Name');
      },
    );

    test('uploadDocument calls /documents and returns model', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/documents',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents'),
          statusCode: 200,
          data: {
            'data': {
              'id': 1,
              'type': 'LICENSE',
              'number': '123456',
              'imgUrl': 'https://doc.jpg',
            },
          },
        ),
      );

      final result = await dataSource.uploadDocument(
        imgUrl: 'https://doc.jpg',
        type: 'LICENSE',
        number: '123456',
        email: 'user@test.com',
      );
      expect(result.id, 1);
      expect(result.number, '123456');
    });

    test('getDocuments returns list of KycDocumentModel', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/documents/user@test.com'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/user@test.com'),
          statusCode: 200,
          data: {
            'data': [
              {
                'id': 1,
                'type': 'LICENSE',
                'number': '123456',
                'imgUrl': 'https://doc.jpg',
              },
            ],
          },
        ),
      );

      final result = await dataSource.getDocuments('user@test.com');
      expect(result.length, 1);
      expect(result.first.id, 1);
    });

    test('deleteDocument calls DELETE /documents/1', () async {
      when(
        () => mockDio.delete<Map<String, dynamic>>('/documents/1'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents/1'),
          statusCode: 200,
        ),
      );

      await dataSource.deleteDocument(1);
      verify(
        () => mockDio.delete<Map<String, dynamic>>('/documents/1'),
      ).called(1);
    });

    test('getRentalHistory returns list of RentalItemModel', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals/email',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/email'),
          statusCode: 200,
          data: {
            'data': {
              'content': [
                {
                  'id': 100,
                  'status': 'COMPLETED',
                  'startTime': '2026-10-01T08:00:00Z',
                  'endTime': '2026-10-01T16:00:00Z',
                },
              ],
            },
          },
        ),
      );

      final result = await dataSource.getRentalHistory(email: 'user@test.com');
      expect(result.length, 1);
      expect(result.first.id, 100);
    });

    test('getRentalDetail returns RentalDetailModel on primary path', () async {
      when(
        () => mockAuthLocalDataSource.getUser(),
      ).thenAnswer((_) async => null);

      when(
        () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/10'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/me/details/10'),
          statusCode: 200,
          data: {
            'data': {
              'id': 10,
              'status': 'ONGOING',
              'vehicle': {'name': 'VF8'},
            },
          },
        ),
      );

      final result = await dataSource.getRentalDetail(10);
      expect(result.id, 10);
      expect(result.vehicleName, 'VF8');
    });
  });
}
