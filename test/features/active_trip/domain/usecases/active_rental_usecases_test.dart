import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_active_rental_detail_use_case.dart';
import 'package:rental_car/features/active_trip/domain/usecases/get_current_active_rental_use_case.dart';

class MockActiveRentalRepository extends Mock
    implements ActiveRentalRepository {}

void main() {
  late MockActiveRentalRepository mockRepository;
  late GetActiveRentalDetailUseCase getDetailUseCase;
  late GetCurrentActiveRentalUseCase getCurrentUseCase;

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
}
