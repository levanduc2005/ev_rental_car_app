import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetBookingFeesUseCase {
  const GetBookingFeesUseCase(this._repository);

  final VehicleRepository _repository;

  Future<Result<BookingFeeBreakdown>> call({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return _repository.getBookingFees(
      vehicleId: vehicleId,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
