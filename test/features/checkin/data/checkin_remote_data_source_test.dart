import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  });
}
