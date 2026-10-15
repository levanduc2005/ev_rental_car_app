import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';
import 'package:rental_car/features/emergency/domain/entities/sos_report_entity.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:rental_car/features/emergency/domain/usecases/submit_emergency_report_usecase.dart';

class MockEmergencyRepository extends Mock implements EmergencyRepository {}

void main() {
  late MockEmergencyRepository mockRepository;
  late SubmitEmergencyReportUseCase useCase;

  setUp(() {
    mockRepository = MockEmergencyRepository();
    useCase = SubmitEmergencyReportUseCase(mockRepository);
  });

  group('SubmitEmergencyReportUseCase', () {
    test('returns DataFailure when description is empty or blank', () async {
      final result = await useCase(
        type: EmergencyType.flatTire,
        description: '   ',
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<DataFailure>());
      expect(
        result.failureOrNull?.message,
        'Vui lòng nhập mô tả chi tiết sự cố gặp phải.',
      );
      verifyZeroInteractions(mockRepository);
    });

    test(
      'delegates to repository with trimmed description and default title',
      () async {
        const expectedEntity = SosReportEntity(
          id: 1,
          title: '[SOS] Thủng lốp / Nổ lốp',
          description: 'Bị thủng bánh sau bên phải',
          type: EmergencyType.flatTire,
          rentalId: 5,
        );

        when(
          () => mockRepository.submitEmergencyReport(
            type: EmergencyType.flatTire,
            description: 'Bị thủng bánh sau bên phải',
            title: '[SOS] Thủng lốp / Nổ lốp',
            rentalId: 5,
          ),
        ).thenAnswer((_) async => const Result.ok(expectedEntity));

        final result = await useCase(
          type: EmergencyType.flatTire,
          description: '  Bị thủng bánh sau bên phải  ',
          rentalId: 5,
        );

        expect(result.isOk, isTrue);
        expect(result.valueOrNull, expectedEntity);
        verify(
          () => mockRepository.submitEmergencyReport(
            type: EmergencyType.flatTire,
            description: 'Bị thủng bánh sau bên phải',
            title: '[SOS] Thủng lốp / Nổ lốp',
            rentalId: 5,
          ),
        ).called(1);
      },
    );
  });
}
