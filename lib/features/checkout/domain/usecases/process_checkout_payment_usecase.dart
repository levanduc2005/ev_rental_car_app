import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class ProcessCheckoutPaymentUseCase {
  const ProcessCheckoutPaymentUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<Map<String, dynamic>>> call(int rentalId) {
    return _repository.processCheckoutPayment(rentalId);
  }
}
