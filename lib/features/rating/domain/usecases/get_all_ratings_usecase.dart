import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';

/// UseCase lấy danh sách tất cả các đánh giá
class GetAllRatingsUseCase {
  const GetAllRatingsUseCase(this._repository);

  final RatingRepository _repository;

  Future<Result<List<RatingEntity>>> call() {
    return _repository.getAllRatings();
  }
}
