import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class CreateRentalCompensationPaymentLinkUseCase {
  const CreateRentalCompensationPaymentLinkUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<PayOSPaymentInfoEntity>> call(int rentalId, {double? amount}) {
    return _repository.createRentalCompensationPaymentLink(
      rentalId,
      amount: amount,
    );
  }
}
