import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class FilterStaffRentalsUseCase {
  const FilterStaffRentalsUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<List<RentalDetailEntity>>> call({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.filterRentals(
      search: search,
      status: status,
      page: page,
      limit: limit,
    );
  }
}
