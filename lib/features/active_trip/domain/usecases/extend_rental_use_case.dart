import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class ExtendRentalUseCase {
  const ExtendRentalUseCase({required ActiveRentalRepository repository})
    : _repository = repository;

  final ActiveRentalRepository _repository;

  Future<Result<ExtendRentalResultEntity>> call({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return _repository.extendRental(
      rentalId: rentalId,
      newReturnTime: newReturnTime,
    );
  }
}
