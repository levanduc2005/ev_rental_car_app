import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class GetActiveRentalDetailUseCase {
  const GetActiveRentalDetailUseCase({
    required ActiveRentalRepository repository,
  }) : _repository = repository;

  final ActiveRentalRepository _repository;

  Future<Result<ActiveRentalEntity>> call(int rentalId) {
    return _repository.getActiveRentalDetail(rentalId);
  }
}
