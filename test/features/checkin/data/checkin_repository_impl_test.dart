import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/checkin/data/datasources/checkin_remote_data_source.dart';
import 'package:rental_car/features/checkin/data/models/docuseal_contract_model.dart';
import 'package:rental_car/features/checkin/data/models/license_status_model.dart';
import 'package:rental_car/features/checkin/data/models/pickup_checklist_model.dart';
import 'package:rental_car/features/checkin/data/repositories/checkin_repository_impl.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

class MockCheckinRemoteDataSource extends Mock
    implements CheckinRemoteDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(const AccessoryChecklistEntity());
    registerFallbackValue(const CarImagesEntity());
  });

  late MockCheckinRemoteDataSource mockDataSource;
  late CheckinRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockCheckinRemoteDataSource();
    repository = CheckinRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('CheckinRepositoryImpl', () {
    test('getLicenseStatus returns LicenseStatusEntity on success', () async {
      const model = LicenseStatusModel(
        userId: 12,
        licenseStatus: 'APPROVED',
        licenseNumber: '123456',
      );
      when(
        () => mockDataSource.getLicenseStatus(),
      ).thenAnswer((_) async => model);

      final result = await repository.getLicenseStatus();

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.userId, 12);
          expect(entity.isApproved, true);
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('getLicenseStatus returns ServerFailure on ServerException', () async {
      when(
        () => mockDataSource.getLicenseStatus(),
      ).thenThrow(const ServerException(message: 'Lỗi máy chủ'));

      final result = await repository.getLicenseStatus();

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) {
          expect(failure, isA<ServerFailure>());
        },
      );
    });

    test(
      'submitPickupChecklist returns PickupChecklistEntity on success',
      () async {
        const model = PickupChecklistModel(
          checklistId: 88,
          rentalId: 105,
          type: 'PICKUP',
          odometer: 12540,
          batteryPercentage: 95,
        );

        when(
          () => mockDataSource.createPickupChecklist(
            rentalId: 105,
            odometer: 12540,
            batteryPercentage: 95,
            accessories: any(named: 'accessories'),
            images: any(named: 'images'),
            note: any(that: anything, named: 'note'),
          ),
        ).thenAnswer((_) async => model);

        final result = await repository.submitPickupChecklist(
          rentalId: 105,
          odometer: 12540,
          batteryPercentage: 95,
          accessories: const AccessoryChecklistEntity(),
          images: const CarImagesEntity(
            frontUrl: 'f',
            backUrl: 'b',
            leftSideUrl: 'l',
            rightSideUrl: 'r',
          ),
        );

        expect(result.isOk, true);
        result.when(
          ok: (entity) {
            expect(entity.checklistId, 88);
            expect(entity.rentalId, 105);
          },
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test(
      'generateContract returns DocuSealContractEntity on success',
      () async {
        const contract = DocuSealContractModel(
          rentalId: 105,
          contractId: 32,
          contractCode: 'HD-105',
          contractStatus: 'PENDING_SIGNATURE',
          signingUrl: 'https://docuseal.com/s/123',
        );
        when(
          () => mockDataSource.generateContract(105),
        ).thenAnswer((_) async => contract);

        final result = await repository.generateContract(105);

        expect(result.isOk, true);
        result.when(
          ok: (entity) {
            expect(entity.contractId, 32);
            expect(entity.signingUrl, 'https://docuseal.com/s/123');
          },
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test(
      'confirmContractSigned returns ContractConfirmResultEntity on success',
      () async {
        const confirmResult = ContractConfirmResultModel(
          rentalId: 105,
          status: 'ACTIVE',
          contractStatus: 'SIGNED',
        );
        when(
          () => mockDataSource.confirmContractSigned(105),
        ).thenAnswer((_) async => confirmResult);

        final result = await repository.confirmContractSigned(105);

        expect(result.isOk, true);
        result.when(
          ok: (entity) {
            expect(entity.rentalId, 105);
            expect(entity.isActive, true);
          },
          err: (_) => fail('Expected ok'),
        );
      },
    );

    test('uploadCarImage returns image url on success', () async {
      when(
        () => mockDataSource.uploadCarImage('/test.jpg'),
      ).thenAnswer((_) async => 'https://cdn.com/test.jpg');

      final result = await repository.uploadCarImage('/test.jpg');

      expect(result.isOk, isTrue);
      result.when(
        ok: (url) => expect(url, 'https://cdn.com/test.jpg'),
        err: (_) => fail('Expected ok'),
      );
    });

    test('uploadCarImage returns NetworkFailure on NetworkException', () async {
      when(
        () => mockDataSource.uploadCarImage('/test.jpg'),
      ).thenThrow(const NetworkException('Mất mạng'));

      final result = await repository.uploadCarImage('/test.jpg');

      expect(result.isErr, isTrue);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (f) => expect(f, isA<NetworkFailure>()),
      );
    });

    test(
      'generateContract returns ServerFailure on generic exception',
      () async {
        when(
          () => mockDataSource.generateContract(105),
        ).thenThrow(Exception('Unknown'));

        final result = await repository.generateContract(105);

        expect(result.isErr, isTrue);
        result.when(
          ok: (_) => fail('Expected err'),
          err: (f) => expect(f, isA<ServerFailure>()),
        );
      },
    );

    test(
      'error mapping covers NetworkException, ServerException, and generic exception across all methods',
      () async {
        final errors = [
          const NetworkException('net error'),
          const ServerException(message: 'server error'),
          Exception('generic error'),
        ];

        for (final err in errors) {
          when(() => mockDataSource.getLicenseStatus()).thenThrow(err);
          final r1 = await repository.getLicenseStatus();
          expect(r1.isErr, isTrue);

          when(() => mockDataSource.uploadCarImage(any())).thenThrow(err);
          final r2 = await repository.uploadCarImage('file.jpg');
          expect(r2.isErr, isTrue);

          when(
            () => mockDataSource.createPickupChecklist(
              rentalId: any(named: 'rentalId'),
              odometer: any(named: 'odometer'),
              batteryPercentage: any(named: 'batteryPercentage'),
              accessories: any(named: 'accessories'),
              images: any(named: 'images'),
              note: any(named: 'note'),
            ),
          ).thenThrow(err);
          final r3 = await repository.submitPickupChecklist(
            rentalId: 1,
            odometer: 100,
            batteryPercentage: 50,
            accessories: const AccessoryChecklistEntity(),
            images: const CarImagesEntity(),
          );
          expect(r3.isErr, isTrue);

          when(() => mockDataSource.generateContract(any())).thenThrow(err);
          final r4 = await repository.generateContract(1);
          expect(r4.isErr, isTrue);

          when(
            () => mockDataSource.confirmContractSigned(any()),
          ).thenThrow(err);
          final r5 = await repository.confirmContractSigned(1);
          expect(r5.isErr, isTrue);
        }
      },
    );
  });
}
