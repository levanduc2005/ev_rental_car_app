import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class GetCurrentActiveRentalUseCase {
  const GetCurrentActiveRentalUseCase({
    required ActiveRentalRepository repository,
  }) : _repository = repository;

  final ActiveRentalRepository _repository;

  Future<Result<ActiveRentalEntity?>> call({required String email}) {
    return _repository.getCurrentActiveRental(email: email);
  }
}
