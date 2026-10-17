import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class UpdateRentalStatusUseCase {
  const UpdateRentalStatusUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<void>> call({required int rentalId, required String status}) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    if (status.trim().isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Trạng thái cần cập nhật không hợp lệ'),
        ),
      );
    }
    return _repository.updateRentalStatus(
      rentalId: rentalId,
      status: status.trim(),
    );
  }
}
