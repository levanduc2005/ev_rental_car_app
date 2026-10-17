import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';
import 'package:rental_car/features/rating/domain/usecases/submit_rating_usecase.dart';

class MockRatingRepository extends Mock implements RatingRepository {}

void main() {
  late MockRatingRepository mockRepository;
  late SubmitRatingUseCase useCase;

  setUp(() {
    mockRepository = MockRatingRepository();
    useCase = SubmitRatingUseCase(mockRepository);
  });

  group('SubmitRatingUseCase', () {
    test('returns DataFailure when rentalId is <= 0', () async {
      final result = await useCase(
        rentalId: 0,
        score: 5,
        comment: 'Dịch vụ rất tốt',
      );

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<DataFailure>());
      expect(result.failureOrNull?.message, 'Mã chuyến thuê không hợp lệ.');
      verifyZeroInteractions(mockRepository);
    });

    test(
      'returns DataFailure when score is less than 1 or greater than 5',
      () async {
        final resultLow = await useCase(
          rentalId: 10,
          score: 0,
          comment: 'Chưa tốt',
        );
        expect(resultLow.isErr, isTrue);
        expect(
          resultLow.failureOrNull?.message,
          'Điểm đánh giá phải từ 1 đến 5 sao.',
        );

        final resultHigh = await useCase(
          rentalId: 10,
          score: 6,
          comment: 'Quá tốt',
        );
        expect(resultHigh.isErr, isTrue);
        expect(
          resultHigh.failureOrNull?.message,
          'Điểm đánh giá phải từ 1 đến 5 sao.',
        );
        verifyZeroInteractions(mockRepository);
      },
    );

    test('returns DataFailure when comment is empty or blank', () async {
      final result = await useCase(rentalId: 10, score: 5, comment: '   ');

      expect(result.isErr, isTrue);
      expect(
        result.failureOrNull?.message,
        'Vui lòng nhập nhận xét chuyến đi.',
      );
      verifyZeroInteractions(mockRepository);
    });

    test('delegates to repository and trims comment when valid', () async {
      const expectedEntity = RatingEntity(
        id: 1,
        rentalId: 10,
        score: 5,
        comment: 'Xe chạy êm, trạm sạch sẽ',
        userId: 2,
      );

      when(
        () => mockRepository.submitRating(
          rentalId: 10,
          score: 5,
          comment: 'Xe chạy êm, trạm sạch sẽ',
          userId: 2,
        ),
      ).thenAnswer((_) async => const Result.ok(expectedEntity));

      final result = await useCase(
        rentalId: 10,
        score: 5,
        comment: '  Xe chạy êm, trạm sạch sẽ   ',
        userId: 2,
      );

      expect(result.isOk, isTrue);
      expect(result.valueOrNull, expectedEntity);
      verify(
        () => mockRepository.submitRating(
          rentalId: 10,
          score: 5,
          comment: 'Xe chạy êm, trạm sạch sẽ',
          userId: 2,
        ),
      ).called(1);
    });
  });
}
