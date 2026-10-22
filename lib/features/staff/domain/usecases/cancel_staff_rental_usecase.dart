import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class CancelStaffRentalUseCase {
  const CancelStaffRentalUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<bool>> call(int rentalId) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    return _repository.cancelRental(rentalId);
  }
}
