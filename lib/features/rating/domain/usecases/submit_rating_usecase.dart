import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';

/// UseCase gửi đánh giá cho chuyến thuê xe
class SubmitRatingUseCase {
  const SubmitRatingUseCase(this._repository);

  final RatingRepository _repository;

  Future<Result<RatingEntity>> call({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  }) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã chuyến thuê không hợp lệ.')),
      );
    }
    if (score < 1 || score > 5) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Điểm đánh giá phải từ 1 đến 5 sao.'),
        ),
      );
    }
    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Vui lòng nhập nhận xét chuyến đi.'),
        ),
      );
    }

    return _repository.submitRating(
      rentalId: rentalId,
      score: score,
      comment: trimmedComment,
      userId: userId,
    );
  }
}
