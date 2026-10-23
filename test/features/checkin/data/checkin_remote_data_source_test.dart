import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/features/checkin/data/datasources/checkin_remote_data_source.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late MockDio mockCloudinaryDio;
  late CheckinRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    mockCloudinaryDio = MockDio();
    dataSource = CheckinRemoteDataSourceImpl(
      dio: mockDio,
      cloudinaryDio: mockCloudinaryDio,
    );
  });

  group('CheckinRemoteDataSourceImpl', () {
    test('getLicenseStatus returns LicenseStatusModel on success', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/users/me/license-status'),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/me/license-status'),
          statusCode: 200,
          data: {
            'data': {
              'userId': 1,
              'licenseStatus': 'APPROVED',
              'licenseNumber': '123456',
            },
          },
        ),
      );

      final result = await dataSource.getLicenseStatus();
      expect(result.userId, 1);
      expect(result.licenseStatus, 'APPROVED');
    });

    test('getLicenseStatus falls back to /users/me on 404', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>('/users/me/license-status'),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/users/me/license-status'),
          response: Response(
            requestOptions: RequestOptions(path: '/users/me/license-status'),
            statusCode: 404,
          ),
        ),
      );

      when(() => mockDio.get<Map<String, dynamic>>('/users/me')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/users/me'),
          statusCode: 200,
          data: {
            'data': {
              'id': 9,
              'documents': [
                {'type': 'LICENSE', 'status': 'VERIFIED', 'number': 'A1-999'},
              ],
            },
          },
        ),
      );

      final result = await dataSource.getLicenseStatus();
      expect(result.userId, 9);
      expect(result.licenseStatus, 'VERIFIED');
    });

    test('createPickupChecklist calls /rental-checklists with body', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rental-checklists',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rental-checklists'),
          statusCode: 201,
          data: {
            'data': {
              'id': 10,
              'rentalId': 5,
              'odometer': 15000,
              'batteryPercentage': 85,
            },
          },
        ),
      );

      final result = await dataSource.createPickupChecklist(
        rentalId: 5,
        odometer: 15000,
        batteryPercentage: 85,
        accessories: const AccessoryChecklistEntity(),
        images: const CarImagesEntity(),
        note: 'Everything fine',
      );

      expect(result.checklistId, 10);
      expect(result.odometer, 15000);
    });

    test('generateContract returns DocuSealContractModel', () async {
      when(() => mockDio.post<dynamic>('/rentals/5/contract')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/rentals/5/contract'),
          statusCode: 200,
          data: {
            'data': {
              'rentalId': 5,
              'contractId': 12,
              'contractCode': 'HD-5',
              'contractStatus': 'PENDING_SIGNATURE',
              'signingUrl': 'https://docuseal.com/s/123',
            },
          },
        ),
      );

      final result = await dataSource.generateContract(5);
      expect(result.rentalId, 5);
      expect(result.signingUrl, 'https://docuseal.com/s/123');
    });

    test(
      'confirmContractSigned returns ContractConfirmResultModel on success',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/5/contract/confirm-signed',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: '/rentals/5/contract/confirm-signed',
            ),
            statusCode: 200,
            data: {
              'data': {
                'rentalId': 5,
                'status': 'ACTIVE',
                'contractStatus': 'SIGNED',
              },
            },
          ),
        );

        final result = await dataSource.confirmContractSigned(5);
        expect(result.rentalId, 5);
        expect(result.isActive, true);
      },
    );

    test('confirmContractSigned falls back on 404', () async {
      when(
        () => mockDio.post<Map<String, dynamic>>(
          '/rentals/5/contract/confirm-signed',
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/rentals/5/contract/confirm-signed',
          ),
          response: Response(
            requestOptions: RequestOptions(
              path: '/rentals/5/contract/confirm-signed',
            ),
            statusCode: 404,
          ),
        ),
      );

      final result = await dataSource.confirmContractSigned(5);
      expect(result.rentalId, 5);
      expect(result.contractStatus, 'SIGNED');
    });

    test(
      'confirmContractSigned falls back on 500 with No static resource or empty data',
      () async {
        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/5/contract/confirm-signed',
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/rentals/5/contract/confirm-signed',
            ),
            response: Response(
              requestOptions: RequestOptions(
                path: '/rentals/5/contract/confirm-signed',
              ),
              statusCode: 500,
              data: {'message': 'No static resource found'},
            ),
          ),
        );

        final res1 = await dataSource.confirmContractSigned(5);
        expect(res1.contractStatus, 'SIGNED');

        when(
          () => mockDio.post<Map<String, dynamic>>(
            '/rentals/5/contract/confirm-signed',
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: '/rentals/5/contract/confirm-signed',
            ),
            statusCode: 200,
            data: {},
          ),
        );

        final res2 = await dataSource.confirmContractSigned(5);
        expect(res2.contractStatus, 'SIGNED');
      },
    );

    test(
      'generateContract handles raw string response or throws ParsingException',
      () async {
        when(() => mockDio.post<dynamic>('/rentals/5/contract')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/5/contract'),
            statusCode: 200,
            data: 'https://docuseal.com/direct-url',
          ),
        );

        final res = await dataSource.generateContract(5);
        expect(res.signingUrl, 'https://docuseal.com/direct-url');

        when(() => mockDio.post<dynamic>('/rentals/5/contract')).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/rentals/5/contract'),
            statusCode: 200,
            data: 12345, // invalid
          ),
        );

        expect(
          () => dataSource.generateContract(5),
          throwsA(isA<ParsingException>()),
        );
      },
    );

    test(
      'createPickupChecklist throws ParsingException when data is null',
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
            data: {'data': null},
          ),
        );

        expect(
          () => dataSource.createPickupChecklist(
            rentalId: 1,
            odometer: 100,
            batteryPercentage: 50,
            accessories: const AccessoryChecklistEntity(),
            images: const CarImagesEntity(),
          ),
          throwsA(isA<ParsingException>()),
        );
      },
    );

    test(
      'uploadCarImage handles missing file, success, and connection errors',
      () async {
        await expectLater(
          dataSource.uploadCarImage('non_existent.jpg'),
          throwsA(isA<ServerException>()),
        );

        // Create temp file
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/car.jpg');
        await tempFile.writeAsString('sample car content');

        // 2. Success upload
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/upload'),
            statusCode: 200,
            data: {'secure_url': 'https://cloudinary.com/car.jpg'},
          ),
        );

        final url = await dataSource.uploadCarImage(tempFile.path);
        expect(url, 'https://cloudinary.com/car.jpg');

        // 3. Cloudinary returns empty secure_url
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
          dataSource.uploadCarImage(tempFile.path),
          throwsA(isA<ServerException>()),
        );

        // 4. Connection error in non-prod returns fallback image
        when(
          () => mockCloudinaryDio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/upload'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final fallbackUrl = await dataSource.uploadCarImage(tempFile.path);
        expect(fallbackUrl, contains('car_sample_'));

        await tempDir.delete(recursive: true);
      },
    );
  });
}
