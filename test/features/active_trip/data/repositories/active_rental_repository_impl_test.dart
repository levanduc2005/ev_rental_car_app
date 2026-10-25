import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';
import 'package:rental_car/features/active_trip/data/models/active_rental_model.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_preview_model.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_result_model.dart';
import 'package:rental_car/features/active_trip/data/models/vehicle_schedule_model.dart';
import 'package:rental_car/features/active_trip/data/repositories/active_rental_repository_impl.dart';

class MockActiveRentalRemoteDataSource extends Mock
    implements ActiveRentalRemoteDataSource {}

void main() {
  late MockActiveRentalRemoteDataSource mockRemoteDataSource;
  late ActiveRentalRepositoryImpl repository;

  final now = DateTime.now();
  final testModel = ActiveRentalModel(
    id: 50,
    status: 'IN_PROGRESS',
    startTime: now,
    endTime: now.add(const Duration(hours: 4)),
    rentFee: 400000,
    vehicleId: 1,
    vehicleName: 'VinFast VF 3',
    vehicleBrand: 'VINFAST',
    vehiclePlate: '30K-123.45',
  );

  setUp(() {
    mockRemoteDataSource = MockActiveRentalRemoteDataSource();
    repository = ActiveRentalRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('ActiveRentalRepositoryImpl', () {
    test('getActiveRentalDetail returns entity on success', () async {
      when(
        () => mockRemoteDataSource.getRentalDetail(50),
      ).thenAnswer((_) async => testModel);

      final result = await repository.getActiveRentalDetail(50);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.id, 50);
      expect(result.valueOrNull?.vehiclePlate, '30K-123.45');
      verify(() => mockRemoteDataSource.getRentalDetail(50)).called(1);
    });

    test(
      'getActiveRentalDetail returns ServerFailure on ServerException',
      () async {
        when(
          () => mockRemoteDataSource.getRentalDetail(50),
        ).thenThrow(const ServerException(message: 'Lỗi server'));

        final result = await repository.getActiveRentalDetail(50);

        expect(result.isErr, isTrue);
        expect(result.failureOrNull, isA<ServerFailure>());
      },
    );

    test('getCurrentActiveRental returns null when no active rental', () async {
      when(
        () =>
            mockRemoteDataSource.getCurrentActiveRental(email: 'user@test.com'),
      ).thenAnswer((_) async => null);

      final result = await repository.getCurrentActiveRental(
        email: 'user@test.com',
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('getVehicleSchedule maps models to entities on success', () async {
      when(() => mockRemoteDataSource.getVehicleSchedule(5)).thenAnswer(
        (_) async => [
          VehicleScheduleModel(
            startTime: now,
            endTime: now.add(const Duration(hours: 4)),
          ),
        ],
      );

      final result = await repository.getVehicleSchedule(5);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.length, 1);
      verify(() => mockRemoteDataSource.getVehicleSchedule(5)).called(1);
    });

    test('extendRental maps model to entity on success', () async {
      final newReturnTime = now.add(const Duration(hours: 4));
      when(
        () => mockRemoteDataSource.extendRental(
          rentalId: 50,
          newReturnTime: newReturnTime,
        ),
      ).thenAnswer(
        (_) async => const ExtendRentalResultModel(
          url: 'https://pay.payos.vn/web/50',
          qrCode: 'https://img.vietqr.io/50.png',
        ),
      );

      final result = await repository.extendRental(
        rentalId: 50,
        newReturnTime: newReturnTime,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.url, 'https://pay.payos.vn/web/50');
      verify(
        () => mockRemoteDataSource.extendRental(
          rentalId: 50,
          newReturnTime: newReturnTime,
        ),
      ).called(1);
    });

    test('previewExtendRental maps model to entity on success', () async {
      final newReturnTime = now.add(const Duration(hours: 4));
      when(
        () => mockRemoteDataSource.previewExtendRental(
          rentalId: 50,
          newReturnTime: newReturnTime,
        ),
      ).thenAnswer(
        (_) async => ExtendRentalPreviewModel(
          additionalFee: 100000,
          newRentFee: 1000000,
          currentRentFee: 900000,
          additionalHours: 4,
          newReturnTime: newReturnTime,
        ),
      );

      final result = await repository.previewExtendRental(
        rentalId: 50,
        newReturnTime: newReturnTime,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.additionalFee, 100000);
      expect(result.valueOrNull?.newRentFee, 1000000);
      verify(
        () => mockRemoteDataSource.previewExtendRental(
          rentalId: 50,
          newReturnTime: newReturnTime,
        ),
      ).called(1);
    });

    test('checkExtendPayment returns ok(true) on success', () async {
      when(
        () => mockRemoteDataSource.checkExtendPayment(50),
      ).thenAnswer((_) async => true);

      final result = await repository.checkExtendPayment(50);

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, isTrue);
      verify(() => mockRemoteDataSource.checkExtendPayment(50)).called(1);
    });
  });
}
