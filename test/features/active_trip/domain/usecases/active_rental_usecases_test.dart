import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';
import 'package:rental_car/features/active_trip/domain/usecases/check_extend_payment_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/extend_rental_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_active_rental_detail_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_current_active_rental_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_vehicle_schedule_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/preview_extend_rental_use_case.dart';

class MockActiveRentalRepository extends Mock
    implements ActiveRentalRepository {}

void main() {
  late MockActiveRentalRepository mockRepository;
  late GetActiveRentalDetailUseCase getDetailUseCase;
  late GetCurrentActiveRentalUseCase getCurrentUseCase;
  late GetVehicleScheduleUseCase getScheduleUseCase;
  late ExtendRentalUseCase extendRentalUseCase;
  late PreviewExtendRentalUseCase previewExtendRentalUseCase;

  final now = DateTime.now();
  final testRental = ActiveRentalEntity(
    id: 101,
    status: 'IN_PROGRESS',
    startTime: now.subtract(const Duration(hours: 1)),
    endTime: now.add(const Duration(hours: 3)),
    rentFee: 650000,
    vehicleId: 5,
    vehicleName: 'VinFast VF 8',
    vehicleBrand: 'VINFAST',
    vehiclePlate: '30H-888.99',
  );

  setUp(() {
    mockRepository = MockActiveRentalRepository();
    getDetailUseCase = GetActiveRentalDetailUseCase(repository: mockRepository);
    getCurrentUseCase = GetCurrentActiveRentalUseCase(
      repository: mockRepository,
    );
    getScheduleUseCase = GetVehicleScheduleUseCase(repository: mockRepository);
    extendRentalUseCase = ExtendRentalUseCase(repository: mockRepository);
    previewExtendRentalUseCase = PreviewExtendRentalUseCase(mockRepository);
  });

  group('GetActiveRentalDetailUseCase', () {
    test('delegates to repository.getActiveRentalDetail', () async {
      when(
        () => mockRepository.getActiveRentalDetail(101),
      ).thenAnswer((_) async => Result.ok(testRental));

      final result = await getDetailUseCase(101);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.id, 101);
      verify(() => mockRepository.getActiveRentalDetail(101)).called(1);
    });
  });

  group('GetCurrentActiveRentalUseCase', () {
    test('delegates to repository.getCurrentActiveRental with email', () async {
      when(
        () => mockRepository.getCurrentActiveRental(email: 'duc@example.com'),
      ).thenAnswer((_) async => Result.ok(testRental));

      final result = await getCurrentUseCase(email: 'duc@example.com');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.vehiclePlate, '30H-888.99');
      verify(
        () => mockRepository.getCurrentActiveRental(email: 'duc@example.com'),
      ).called(1);
    });
  });

  group('GetVehicleScheduleUseCase', () {
    test('delegates to repository.getVehicleSchedule', () async {
      final schedules = [
        VehicleScheduleEntity(
          startTime: now.add(const Duration(hours: 4)),
          endTime: now.add(const Duration(hours: 8)),
        ),
      ];
      when(
        () => mockRepository.getVehicleSchedule(5),
      ).thenAnswer((_) async => Result.ok(schedules));

      final result = await getScheduleUseCase(5);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.length, 1);
      verify(() => mockRepository.getVehicleSchedule(5)).called(1);
    });
  });

  group('PreviewExtendRentalUseCase', () {
    test('delegates to repository.previewExtendRental', () async {
      final newReturnTime = now.add(const Duration(hours: 5));
      final previewResult = ExtendRentalPreviewEntity(
        additionalFee: 100000,
        newRentFee: 1000000,
        currentRentFee: 900000,
        additionalHours: 2,
        newReturnTime: newReturnTime,
      );
      when(
        () => mockRepository.previewExtendRental(
          rentalId: 101,
          newReturnTime: newReturnTime,
        ),
      ).thenAnswer((_) async => Result.ok(previewResult));

      final result = await previewExtendRentalUseCase(
        rentalId: 101,
        newReturnTime: newReturnTime,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.additionalFee, 100000);
      expect(result.valueOrNull?.newRentFee, 1000000);
      verify(
        () => mockRepository.previewExtendRental(
          rentalId: 101,
          newReturnTime: newReturnTime,
        ),
      ).called(1);
    });
  });

  group('ExtendRentalUseCase', () {
    test('delegates to repository.extendRental', () async {
      const extendResult = ExtendRentalResultEntity(
        url: 'https://pay.payos.vn/web/12345',
        qrCode: 'https://img.vietqr.io/...',
      );
      final newReturnTime = now.add(const Duration(hours: 5));
      when(
        () => mockRepository.extendRental(
          rentalId: 101,
          newReturnTime: newReturnTime,
        ),
      ).thenAnswer((_) async => const Result.ok(extendResult));

      final result = await extendRentalUseCase(
        rentalId: 101,
        newReturnTime: newReturnTime,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.url, 'https://pay.payos.vn/web/12345');
      verify(
        () => mockRepository.extendRental(
          rentalId: 101,
          newReturnTime: newReturnTime,
        ),
      ).called(1);
    });
  });

  group('CheckExtendPaymentUseCase', () {
    test('delegates to repository.checkExtendPayment', () async {
      final checkUseCase = CheckExtendPaymentUseCase(mockRepository);
      when(
        () => mockRepository.checkExtendPayment(101),
      ).thenAnswer((_) async => const Result.ok(true));

      final result = await checkUseCase(101);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isTrue);
      verify(() => mockRepository.checkExtendPayment(101)).called(1);
    });
  });
}
