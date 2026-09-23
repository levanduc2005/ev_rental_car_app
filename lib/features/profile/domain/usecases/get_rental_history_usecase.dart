import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class GetRentalHistoryUseCase {
  const GetRentalHistoryUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<RentalItemEntity>>> call({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 10,
    String search = '',
  }) {
    return _repository.getRentalHistory(
      email: email,
      status: status,
      page: page,
      limit: limit,
      search: search,
    );
  }
}
