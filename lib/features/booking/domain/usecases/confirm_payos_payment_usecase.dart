import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class ConfirmPayOSPaymentUseCase {
  const ConfirmPayOSPaymentUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<bool>> call(String reservationCode) {
    return _repository.confirmPayOSPayment(reservationCode);
  }
}
