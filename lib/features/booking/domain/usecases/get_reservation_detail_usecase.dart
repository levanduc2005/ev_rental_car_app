import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class GetReservationDetailUseCase {
  const GetReservationDetailUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<ReservationEntity>> call(int reservationId) {
    return _repository.getReservationDetail(reservationId);
  }
}
