import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';
import 'package:rental_car/features/profile/domain/usecases/get_profile_usecase.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late MockProfileRepository mockRepository;
  late GetProfileUseCase useCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = GetProfileUseCase(mockRepository);
  });

  test('GetProfileUseCase calls repository.getProfile()', () async {
    const user = UserProfileEntity(
      email: 'user@example.com',
      fullName: 'User Name',
    );

    when(
      () => mockRepository.getProfile(),
    ).thenAnswer((_) async => const Result.ok(user));

    final result = await useCase();

    expect(result.isOk, isTrue);
    expect(result.valueOrNull?.fullName, 'User Name');
    verify(() => mockRepository.getProfile()).called(1);
  });
}
