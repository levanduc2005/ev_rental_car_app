import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class GetCheckInPaymentUrlUseCase {
  const GetCheckInPaymentUrlUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<String>> call({required int rentalId, int point = 0}) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    return _repository.getCheckInPaymentUrl(
      rentalId: rentalId,
      point: point < 0 ? 0 : point,
    );
  }
}
