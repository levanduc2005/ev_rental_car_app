import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_rentals_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late FilterStaffRentalsUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = FilterStaffRentalsUseCase(repository);
  });

  group('FilterStaffRentalsUseCase', () {
    test('delegates to repository with parameters', () async {
      final rentals = [
        RentalDetailEntity(
          id: 101,
          status: 'ACTIVE',
          vehicleName: 'VF 8',
          rentFee: 1500000,
          rentalDepositAmount: 500000,
          createdAt: DateTime(2026, 10, 16),
          seatCapacity: 5,
          batteryCapacity: 87,
        ),
      ];

      when(
        () => repository.filterRentals(
          search: 'VF',
          status: ['ACTIVE'],
          limit: 10,
        ),
      ).thenAnswer((_) async => Result.ok(rentals));

      final result = await useCase(search: 'VF', status: ['ACTIVE'], limit: 10);

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list.first.vehicleName, 'VF 8');
        },
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.filterRentals(
          search: 'VF',
          status: ['ACTIVE'],
          limit: 10,
        ),
      ).called(1);
    });

    test('returns failure when repository fails', () async {
      when(
        () => repository.filterRentals(
          search: any(named: 'search'),
          status: any(named: 'status'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Error')),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
    });
  });
}
