import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/rating/data/datasources/rating_remote_data_source.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  const RatingRepositoryImpl({required RatingRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final RatingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<RatingEntity>> submitRating({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.submitRating(
        rentalId: rentalId,
        score: score,
        comment: comment,
        userId: userId,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<RatingEntity>>> getAllRatings() {
    return safeCall(() async {
      final models = await _remoteDataSource.getAllRatings();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<RatingEntity>> getRatingById(int id) {
    return safeCall(() async {
      final model = await _remoteDataSource.getRatingById(id);
      return model.toEntity();
    });
  }
}
