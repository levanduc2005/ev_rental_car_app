import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class GetRentalDetailUseCase {
  const GetRentalDetailUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<RentalDetailEntity>> call(int id) {
    return _repository.getRentalDetail(id);
  }
}
