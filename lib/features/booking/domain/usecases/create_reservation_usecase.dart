import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class CreateReservationUseCase {
  const CreateReservationUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<ReservationEntity>> call({
    required String userEmail,
    required int vehicleId,
    required int stationId,
    required DateTime startTime,
    required DateTime endTime,
    bool isInstant = false,
  }) {
    return _repository.createReservation(
      userEmail: userEmail,
      vehicleId: vehicleId,
      stationId: stationId,
      startTime: startTime,
      endTime: endTime,
      isInstant: isInstant,
    );
  }
}
