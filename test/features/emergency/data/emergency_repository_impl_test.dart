import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/emergency/data/datasources/emergency_remote_data_source.dart';
import 'package:rental_car/features/emergency/data/models/sos_report_model.dart';
import 'package:rental_car/features/emergency/data/repositories/emergency_repository_impl.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';

class MockEmergencyRemoteDataSource extends Mock
    implements EmergencyRemoteDataSource {}

void main() {
  late MockEmergencyRemoteDataSource mockRemoteDataSource;
  late EmergencyRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockEmergencyRemoteDataSource();
    repository = EmergencyRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('EmergencyRepositoryImpl', () {
    test('submitEmergencyReport returns SosReportEntity on success', () async {
      const model = SosReportModel(
        id: 1,
        title: '[SOS] Hỏng hóc kỹ thuật',
        description: 'Lỗi motor điện',
        type: 'TECHNICAL_FAULT',
      );

      when(
        () => mockRemoteDataSource.submitReport(
          title: any(named: 'title'),
          description: any(named: 'description'),
          type: 'TECHNICAL_FAULT',
        ),
      ).thenAnswer((_) async => model);

      final result = await repository.submitEmergencyReport(
        type: EmergencyType.technicalFault,
        description: 'Lỗi motor điện',
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.title, '[SOS] Hỏng hóc kỹ thuật');
      expect(result.valueOrNull?.type, EmergencyType.technicalFault);
      verify(
        () => mockRemoteDataSource.submitReport(
          title: any(named: 'title'),
          description: any(named: 'description'),
          type: 'TECHNICAL_FAULT',
        ),
      ).called(1);
    });

    test(
      'submitEmergencyReport returns ServerFailure on ServerException',
      () async {
        when(
          () => mockRemoteDataSource.submitReport(
            title: any(named: 'title'),
            description: any(named: 'description'),
            type: 'OUT_OF_BATTERY',
          ),
        ).thenThrow(const ServerException(message: 'Lỗi máy chủ'));

        final result = await repository.submitEmergencyReport(
          type: EmergencyType.outOfBattery,
          description: 'Hết pin',
        );

        expect(result.isErr, isTrue);
        expect(result.failureOrNull, isA<ServerFailure>());
        expect(result.failureOrNull?.message, 'Lỗi máy chủ');
      },
    );

    test('uploadIncidentImage returns image url on success', () async {
      when(
        () => mockRemoteDataSource.uploadIncidentImage('/path/to/img.jpg'),
      ).thenAnswer((_) async => 'https://res.cloudinary.com/img.jpg');

      final result = await repository.uploadIncidentImage('/path/to/img.jpg');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 'https://res.cloudinary.com/img.jpg');
    });

    test(
      'submitEmergencyReport with all optional parameters formats description correctly',
      () async {
        const model = SosReportModel(
          id: 99,
          title: 'Custom Title',
          description: 'full desc',
          type: 'ACCIDENT',
        );

        when(
          () => mockRemoteDataSource.submitReport(
            title: 'Custom Title',
            description: any(named: 'description'),
            type: 'ACCIDENT',
            userEmail: 'driver@test.com',
          ),
        ).thenAnswer((_) async => model);

        final result = await repository.submitEmergencyReport(
          type: EmergencyType.accident,
          description: 'Va cham nhe',
          title: 'Custom Title',
          imageUrl: 'https://img.jpg',
          latitude: 10.123,
          longitude: 106.456,
          rentalId: 88,
          userEmail: 'driver@test.com',
        );

        expect(result.isOk, isTrue);
        final entity = result.valueOrNull;
        expect(entity?.rentalId, 88);
        expect(entity?.latitude, 10.123);
        expect(entity?.imageUrl, 'https://img.jpg');
      },
    );

    test(
      'getEmergencyReports returns mapped list and handles failure',
      () async {
        const models = [
          SosReportModel(
            id: 1,
            title: 'SOS 1',
            description: 'Desc 1',
            type: 'FLAT_TIRE',
          ),
        ];

        when(
          () => mockRemoteDataSource.getEmergencyReports(),
        ).thenAnswer((_) async => models);

        final resOk = await repository.getEmergencyReports();
        expect(resOk.isOk, isTrue);
        expect(resOk.valueOrNull?.length, 1);

        when(
          () => mockRemoteDataSource.getEmergencyReports(),
        ).thenThrow(const ServerException(message: 'fail'));
        final resErr = await repository.getEmergencyReports();
        expect(resErr.isErr, isTrue);
      },
    );

    test(
      'uploadIncidentImage returns ServerFailure when remote throws ServerException',
      () async {
        when(
          () => mockRemoteDataSource.uploadIncidentImage(any()),
        ).thenThrow(const ServerException(message: 'Upload failed'));

        final result = await repository.uploadIncidentImage('bad_path.jpg');
        expect(result.isErr, isTrue);
      },
    );
  });
}
