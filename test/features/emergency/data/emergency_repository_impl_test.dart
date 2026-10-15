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
  });
}
