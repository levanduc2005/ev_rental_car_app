import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class CancelReservationUseCase {
  const CancelReservationUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<bool>> call({required String code, String? reason}) {
    return _repository.cancelReservation(code: code, reason: reason);
  }
}
