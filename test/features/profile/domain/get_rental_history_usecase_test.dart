import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_history_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late GetRentalHistoryUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = GetRentalHistoryUseCase(mockRepository);
  });

  test('GetRentalHistoryUseCase calls repository.getRentalHistory()', () async {
    const rentals = [
      RentalItemEntity(
        id: 1,
        vehicleName: 'VinFast VF 8 Plus',
        status: 'ONGOING',
      ),
    ];

    when(
      () => mockRepository.getRentalHistory(
        email: 'customer@test.com',
        status: ['ONGOING'],
      ),
    ).thenAnswer((_) async => const Result.ok(rentals));

    final result = await useCase(
      email: 'customer@test.com',
      status: ['ONGOING'],
    );

    expect(result.isOk, isTrue);
    expect(result.valueOrNull?.first.vehicleName, 'VinFast VF 8 Plus');
    verify(
      () => mockRepository.getRentalHistory(
        email: 'customer@test.com',
        status: ['ONGOING'],
      ),
    ).called(1);
  });
}
