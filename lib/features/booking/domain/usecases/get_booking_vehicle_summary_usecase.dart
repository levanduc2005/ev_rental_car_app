import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class GetBookingVehicleSummaryUseCase {
  const GetBookingVehicleSummaryUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<VehicleBookingSummary>> call(int vehicleId) {
    return _repository.getVehicleDetail(vehicleId);
  }
}
