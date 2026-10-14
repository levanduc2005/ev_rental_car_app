import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class CalculateBookingFeesUseCase {
  const CalculateBookingFeesUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<BookingFeeEntity>> call({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
    bool rental = false,
  }) {
    return _repository.calculateFees(
      vehicleId: vehicleId,
      startTime: startTime,
      endTime: endTime,
      rental: rental,
    );
  }
}
