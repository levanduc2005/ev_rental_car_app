import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';
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

    test(
      'getRentalDetail uses /rentals/:id/details for staff and falls back on DioException',
      () async {
        const staffUser = UserModel(
          email: 'staff@test.com',
          role: 'ROLE_STAFF',
        );
        when(
          () => mockAuthLocalDataSource.getUser(),
        ).thenAnswer((_) async => staffUser);

        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/10/details'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/rentals/10/details'),
            type: DioExceptionType.badResponse,
          ),
        );

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
        verify(
          () => mockDio.get<Map<String, dynamic>>('/rentals/10/details'),
        ).called(1);
        verify(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/10'),
        ).called(1);
      },
    );

    test('getRentalDetail throws when data is null or not a map', () async {
      when(
        () => mockAuthLocalDataSource.getUser(),
      ).thenAnswer((_) async => null);
      when(
        () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/10'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/me/details/10'),
          statusCode: 200,
          data: {'data': null},
        ),
      );

      expect(
        () => dataSource.getRentalDetail(10),
        throwsA(isA<ServerException>()),
      );
    });

    test(
      'getProfile and updateProfile throw ParsingException when data is null',
      () async {
        when(() => mockDio.get<Map<String, dynamic>>('/users/me')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/me'),
            statusCode: 200,
            data: {},
          ),
        );

        expect(() => dataSource.getProfile(), throwsA(isA<ParsingException>()));

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/users/me/update-profile',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/users/me/update-profile'),
            statusCode: 200,
            data: {},
          ),
        );

        expect(
          () => dataSource.updateProfile(fullName: 'A', phone: '1'),
          throwsA(isA<ParsingException>()),
        );
      },
    );

    test(
      'getDocuments returns empty list when response data is not a list',
      () async {
        when(
          () => mockDio.get<Map<String, dynamic>>('/documents/user@test.com'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/documents/user@test.com'),
            statusCode: 200,
            data: {'data': null},
          ),
        );

        final result = await dataSource.getDocuments('user@test.com');
        expect(result, isEmpty);
      },
    );

    test(
      'getRentalHistory returns empty list when response is not Map or content is not list',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/email',
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/email'),
            statusCode: 200,
            data: {'data': null},
          ),
        );

        final result = await dataSource.getRentalHistory(
          email: 'user@test.com',
        );
        expect(result, isEmpty);
      },
    );

    test(
      'getRentalDetail uses /rentals/me/details/:id for customer and falls back on DioException',
      () async {
        when(
          () => mockAuthLocalDataSource.getUser(),
        ).thenAnswer((_) async => null);

        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/10'),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/rentals/me/details/10'),
            type: DioExceptionType.badResponse,
          ),
        );

        when(
          () => mockDio.get<Map<String, dynamic>>('/rentals/10/details'),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/10/details'),
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
        verify(
          () => mockDio.get<Map<String, dynamic>>('/rentals/me/details/10'),
        ).called(1);
        verify(
          () => mockDio.get<Map<String, dynamic>>('/rentals/10/details'),
        ).called(1);
      },
    );

    test(
      'uploadDocument throws ServerException with mapped KYC error message',
      () async {
        final kycErrors = [
          'DOCUMENT_INVALID',
          'DOCUMENT_NUMBER_MISMATCH',
          'DOCUMENT_NUMBER_INVALID',
          'DOCUMENT_EXPIRED',
          'LICENSE_NOT_VALID_FOR_VEHICLE',
          'DOCUMENT_NUMBER_EXISTS',
          'documents_doc_number_key',
          'duplicate key value',
          'USER_ALREADY_HAS_DOCUMENT_OF_TYPE',
          'GENERIC_ERROR',
        ];

        for (final err in kycErrors) {
          when(
            () => mockDio.post<Map<String, dynamic>>(
              '/documents',
              data: any(named: 'data'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/documents'),
              response: Response(
                requestOptions: RequestOptions(path: '/documents'),
                statusCode: 400,
                data: {'message': err},
              ),
              type: DioExceptionType.badResponse,
            ),
          );

          await expectLater(
            dataSource.uploadDocument(
              imgUrl: 'https://doc.jpg',
              type: 'LICENSE',
              number: '123',
              email: 'user@test.com',
            ),
            throwsA(isA<ServerException>()),
          );
        }
      },
    );

    test('uploadDocument throws ParsingException when data is null', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/documents',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/documents'),
          statusCode: 200,
          data: {'data': null},
        ),
      );

      await expectLater(
        dataSource.uploadDocument(
          imgUrl: 'https://doc.jpg',
          type: 'LICENSE',
          number: '123',
          email: 'user@test.com',
        ),
        throwsA(isA<ParsingException>()),
      );
    });

    test('uploadImage handles file existence, success and errors', () async {
      final mockCloudinaryDio = MockDio();
      final customDataSource = ProfileRemoteDataSourceImpl(
        dio: mockDio,
        cloudinaryDio: mockCloudinaryDio,
      );

      // 1. File does not exist
      await expectLater(
        customDataSource.uploadImage('non_existent_file.jpg'),
        throwsA(isA<ServerException>()),
      );

      // Create a temporary file
      final tempDir = await Directory.systemTemp.createTemp();
      final tempFile = File('${tempDir.path}/test_upload.jpg');
      await tempFile.writeAsString('test image content');

      // 2. Success upload
      when(
        () => mockCloudinaryDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/image/upload'),
          statusCode: 200,
          data: {'secure_url': 'https://cloudinary.com/test.jpg'},
        ),
      );

      final url = await customDataSource.uploadImage(tempFile.path);
      expect(url, 'https://cloudinary.com/test.jpg');

      // 3. Cloudinary returns empty or null secure_url
      when(
        () => mockCloudinaryDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/image/upload'),
          statusCode: 200,
          data: {'secure_url': ''},
        ),
      );

      await expectLater(
        customDataSource.uploadImage(tempFile.path),
        throwsA(isA<ServerException>()),
      );

      // 4. Cloudinary throws DioException with error object
      when(
        () => mockCloudinaryDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/image/upload'),
          response: Response(
            requestOptions: RequestOptions(path: '/image/upload'),
            statusCode: 400,
            data: {
              'error': {'message': 'File size too large'},
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        customDataSource.uploadImage(tempFile.path),
        throwsA(isA<ServerException>()),
      );

      // 5. Cloudinary throws generic Exception
      when(
        () => mockCloudinaryDio.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(Exception('Network socket broken'));

      await expectLater(
        customDataSource.uploadImage(tempFile.path),
        throwsA(isA<ServerException>()),
      );

      // 6. Test with default _effectiveCloudinaryDio (when cloudinaryDio is null)
      await expectLater(
        dataSource.uploadImage(tempFile.path),
        throwsA(isA<ServerException>()),
      );

      await tempDir.delete(recursive: true);
    });
  });
}
