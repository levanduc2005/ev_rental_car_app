import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';
import 'package:rental_car/features/active_trip/data/models/active_rental_model.dart';
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
  });
}
