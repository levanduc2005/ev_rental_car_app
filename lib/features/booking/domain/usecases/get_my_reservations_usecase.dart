import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

class GetMyReservationsUseCase {
  const GetMyReservationsUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<List<ReservationEntity>>> call({required String email}) {
    return _repository.getMyReservations(email: email);
  }
}
