import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/features/rating/data/datasources/rating_remote_data_source.dart';
import 'package:rental_car/features/rating/data/models/rating_model.dart';
import 'package:rental_car/features/rating/data/repositories/rating_repository_impl.dart';

class MockRatingRemoteDataSource extends Mock
    implements RatingRemoteDataSource {}

void main() {
  late MockRatingRemoteDataSource mockRemoteDataSource;
  late RatingRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRatingRemoteDataSource();
    repository = RatingRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('RatingRepositoryImpl', () {
    test('submitRating returns RatingEntity when successful', () async {
      const model = RatingModel(
        id: 1,
        rentalId: 10,
        score: 5,
        comment: 'Rất tốt',
        userId: 2,
      );

      when(
        () => mockRemoteDataSource.submitRating(
          rentalId: 10,
          score: 5,
          comment: 'Rất tốt',
          userId: 2,
        ),
      ).thenAnswer((_) async => model);

      final result = await repository.submitRating(
        rentalId: 10,
        score: 5,
        comment: 'Rất tốt',
        userId: 2,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.rentalId, 10);
      expect(result.valueOrNull?.score, 5);
      expect(result.valueOrNull?.comment, 'Rất tốt');
      verify(
        () => mockRemoteDataSource.submitRating(
          rentalId: 10,
          score: 5,
          comment: 'Rất tốt',
          userId: 2,
        ),
      ).called(1);
    });

    test('submitRating returns ServerFailure on ServerException', () async {
      when(
        () => mockRemoteDataSource.submitRating(
          rentalId: 10,
          score: 5,
          comment: 'Rất tốt',
        ),
      ).thenThrow(const ServerException(message: 'Lỗi máy chủ'));

      final result = await repository.submitRating(
        rentalId: 10,
        score: 5,
        comment: 'Rất tốt',
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ServerFailure>());
      expect(result.failureOrNull?.message, 'Lỗi máy chủ');
    });

    test('getAllRatings returns list of RatingEntity', () async {
      const models = [
        RatingModel(id: 1, rentalId: 10, score: 5, comment: 'Tốt'),
        RatingModel(id: 2, rentalId: 11, score: 4, comment: 'Khá'),
      ];

      when(
        () => mockRemoteDataSource.getAllRatings(),
      ).thenAnswer((_) async => models);

      final result = await repository.getAllRatings();

      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.length, 2);
      expect(result.valueOrNull?.first.score, 5);
      expect(result.valueOrNull?.last.score, 4);

      when(
        () => mockRemoteDataSource.getAllRatings(),
      ).thenThrow(const ServerException(message: 'error'));
      final errRes = await repository.getAllRatings();
      expect(errRes.isErr, isTrue);
    });

    test(
      'getRatingById returns RatingEntity on success and failure on exception',
      () async {
        const model = RatingModel(
          id: 99,
          rentalId: 10,
          score: 5,
          comment: 'Đỉnh',
        );

        when(
          () => mockRemoteDataSource.getRatingById(99),
        ).thenAnswer((_) async => model);
        final okResult = await repository.getRatingById(99);
        expect(okResult.isOk, isTrue);
        expect(okResult.valueOrNull?.id, 99);

        when(
          () => mockRemoteDataSource.getRatingById(99),
        ).thenThrow(const ServerException(message: 'Not found'));
        final errResult = await repository.getRatingById(99);
        expect(errResult.isErr, isTrue);
      },
    );
  });
}
