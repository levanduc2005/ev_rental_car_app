import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:rental_car/features/auth/domain/usecases/check_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/set_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/verify_otp_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  const testUser = UserEntity(
    email: 'test@example.com',
    fullName: 'Nguyen Van A',
    phone: '0901234567',
  );

  group('SendOtpUseCase', () {
    test('trims and lowercases email before passing to repository', () async {
      final useCase = SendOtpUseCase(mockRepository);

      when(
        () => mockRepository.sendOtp(email: 'test@example.com'),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await useCase(email: '  TEST@EXAMPLE.COM  ');

      expect(result.isOk, isTrue);
      verify(() => mockRepository.sendOtp(email: 'test@example.com')).called(1);
    });
  });

  group('VerifyOtpUseCase', () {
    test('trims email and verifies otp via repository', () async {
      final useCase = VerifyOtpUseCase(mockRepository);

      when(
        () =>
            mockRepository.verifyOtp(email: 'test@example.com', otp: '123456'),
      ).thenAnswer((_) async => const Result.ok(testUser));

      final result = await useCase(email: ' test@example.com ', otp: '123456');

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.email, 'test@example.com');
      verify(
        () =>
            mockRepository.verifyOtp(email: 'test@example.com', otp: '123456'),
      ).called(1);
    });
  });

  group('CompleteProfileUseCase', () {
    test('trims full name before submitting', () async {
      final useCase = CompleteProfileUseCase(mockRepository);

      when(
        () => mockRepository.completeProfile(fullName: 'Nguyen Van A'),
      ).thenAnswer((_) async => const Result.ok(testUser));

      final result = await useCase(fullName: '  Nguyen Van A  ');

      expect(result.isOk, isTrue);
      verify(
        () => mockRepository.completeProfile(fullName: 'Nguyen Van A'),
      ).called(1);
    });
  });

  group('GetCurrentUserUseCase', () {
    test('returns currently logged in user', () async {
      final useCase = GetCurrentUserUseCase(mockRepository);

      when(
        () => mockRepository.getCurrentUser(),
      ).thenAnswer((_) async => const Result.ok(testUser));

      final result = await useCase();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, equals(testUser));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });
  });

  group('LogoutUseCase', () {
    test('calls repository logout', () async {
      final useCase = LogoutUseCase(mockRepository);

      when(
        () => mockRepository.logout(),
      ).thenAnswer((_) async => const Result.ok(null));

      final result = await useCase();

      expect(result.isOk, isTrue);
      verify(() => mockRepository.logout()).called(1);
    });
  });

  group('ProfileSetupSkipped UseCases', () {
    test(
      'CheckProfileSetupSkippedUseCase delegates with sanitized email',
      () async {
        final useCase = CheckProfileSetupSkippedUseCase(mockRepository);

        when(
          () => mockRepository.isProfileSetupSkipped('test@example.com'),
        ).thenAnswer((_) async => const Result.ok(true));

        final result = await useCase('  TEST@EXAMPLE.COM  ');

        expect(result.isOk, isTrue);
        expect(result.valueOrNull, isTrue);
        verify(
          () => mockRepository.isProfileSetupSkipped('test@example.com'),
        ).called(1);
      },
    );

    test(
      'SetProfileSetupSkippedUseCase delegates with sanitized email',
      () async {
        final useCase = SetProfileSetupSkippedUseCase(mockRepository);

        when(
          () => mockRepository.setProfileSetupSkipped('test@example.com'),
        ).thenAnswer((_) async => const Result.ok(null));

        final result = await useCase('  TEST@EXAMPLE.COM  ');

        expect(result.isOk, isTrue);
        verify(
          () => mockRepository.setProfileSetupSkipped('test@example.com'),
        ).called(1);
      },
    );
  });
}
