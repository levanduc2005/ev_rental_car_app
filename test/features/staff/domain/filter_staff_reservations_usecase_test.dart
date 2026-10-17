import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_reservations_usecase.dart';

class MockStaffRepository extends Mock implements StaffRepository {}

void main() {
  late MockStaffRepository repository;
  late FilterStaffReservationsUseCase useCase;

  setUp(() {
    repository = MockStaffRepository();
    useCase = FilterStaffReservationsUseCase(repository);
  });

  group('FilterStaffReservationsUseCase', () {
    test('delegates to repository with parameters', () async {
      final reservations = [
        const ReservationEntity(
          id: 1,
          code: 'RES-001',
          status: 'PENDING',
          stationName: 'Trạm Landmark 81',
        ),
      ];

      when(
        () => repository.filterReservations(search: 'RES', status: ['PENDING']),
      ).thenAnswer((_) async => Result.ok(reservations));

      final result = await useCase(search: 'RES', status: ['PENDING']);

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list.first.code, 'RES-001');
        },
        err: (_) => fail('Expected ok'),
      );
      verify(
        () => repository.filterReservations(search: 'RES', status: ['PENDING']),
      ).called(1);
    });

    test('returns failure when repository fails', () async {
      when(
        () => repository.filterReservations(
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
