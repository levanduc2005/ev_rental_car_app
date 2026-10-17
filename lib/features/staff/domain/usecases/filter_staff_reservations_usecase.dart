import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class FilterStaffReservationsUseCase {
  const FilterStaffReservationsUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<List<ReservationEntity>>> call({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.filterReservations(
      search: search,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
