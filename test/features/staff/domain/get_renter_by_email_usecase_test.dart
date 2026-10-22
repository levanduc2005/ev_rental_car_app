import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/get_renter_by_email_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository mockRepository;
  late GetRenterByEmailUseCase useCase;

  setUp(() {
    mockRepository = MockStaffRepository();
    useCase = GetRenterByEmailUseCase(mockRepository);
  });

  group('GetRenterByEmailUseCase', () {
    test('returns DataFailure when email is empty', () async {
      final result = await useCase('   ');

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<DataFailure>()),
      );
    });

    test('delegates to repository when email is valid', () async {
      const renter = RenterEntity(
        email: 'customer@gmail.com',
        fullName: 'Nguyen Van A',
        phone: '0901234567',
        point: 100,
      );

      when(
        () => mockRepository.getRenterByEmail('customer@gmail.com'),
      ).thenAnswer((_) async => const Result.ok(renter));

      final result = await useCase('customer@gmail.com');

      expect(result.isOk, true);
      result.when(
        ok: (entity) {
          expect(entity.email, 'customer@gmail.com');
          expect(entity.fullName, 'Nguyen Van A');
          expect(entity.phone, '0901234567');
          expect(entity.blocked, false);
          expect(entity.point, 100);
        },
        err: (_) => fail('Expected ok'),
      );
    });

    test('propagates failure from repository', () async {
      when(
        () => mockRepository.getRenterByEmail('notfound@gmail.com'),
      ).thenAnswer(
        (_) async => const Result.err(
          ServerFailure(message: 'Không tìm thấy người dùng', statusCode: 404),
        ),
      );

      final result = await useCase('notfound@gmail.com');

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Expected err'),
        err: (failure) => expect(failure, isA<ServerFailure>()),
      );
    });
  });
}
