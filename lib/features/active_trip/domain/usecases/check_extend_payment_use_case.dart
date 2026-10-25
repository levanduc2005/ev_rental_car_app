import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class CheckExtendPaymentUseCase {
  const CheckExtendPaymentUseCase(this._repository);

  final ActiveRentalRepository _repository;

  Future<Result<bool>> call(int rentalId) {
    return _repository.checkExtendPayment(rentalId);
  }
}
