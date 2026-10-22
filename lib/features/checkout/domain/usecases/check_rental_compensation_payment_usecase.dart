import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class CheckRentalCompensationPaymentUseCase {
  const CheckRentalCompensationPaymentUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<bool>> call(int rentalId) {
    return _repository.checkRentalCompensationPayment(rentalId);
  }
}
