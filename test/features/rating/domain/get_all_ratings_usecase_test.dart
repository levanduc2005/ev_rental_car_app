import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';
import 'package:rental_car/features/rating/domain/usecases/get_all_ratings_usecase.dart';

class MockRatingRepository extends Mock implements RatingRepository {}

void main() {
  late MockRatingRepository repository;
  late GetAllRatingsUseCase useCase;

  setUp(() {
    repository = MockRatingRepository();
    useCase = GetAllRatingsUseCase(repository);
  });

  group('GetAllRatingsUseCase', () {
    test('delegates to repository.getAllRatings on success', () async {
      final ratings = [
        RatingEntity(
          id: 1,
          rentalId: 10,
          score: 5,
          comment: 'Xe rat moi va tot',
          createdAt: DateTime(2026, 10),
        ),
      ];

      when(
        () => repository.getAllRatings(),
      ).thenAnswer((_) async => Result.ok(ratings));

      final result = await useCase();

      expect(result.isOk, isTrue);
      result.when(
        ok: (list) {
          expect(list.length, 1);
          expect(list.first.score, 5);
          expect(list.first.comment, 'Xe rat moi va tot');
        },
        err: (_) => fail('Expected ok'),
      );
      verify(() => repository.getAllRatings()).called(1);
    });

    test('returns Failure when repository fails', () async {
      when(() => repository.getAllRatings()).thenAnswer(
        (_) async => const Result.err(ServerFailure(message: 'Server error')),
      );

      final result = await useCase();

      expect(result.isErr, isTrue);
      verify(() => repository.getAllRatings()).called(1);
    });
  });
}
