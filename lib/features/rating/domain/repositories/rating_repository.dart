import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';

abstract interface class RatingRepository {
  Future<Result<RatingEntity>> submitRating({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  });

  Future<Result<List<RatingEntity>>> getAllRatings();

  Future<Result<RatingEntity>> getRatingById(int id);
}
