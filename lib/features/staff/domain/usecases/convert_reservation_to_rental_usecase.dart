import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class ConvertReservationToRentalUseCase {
  const ConvertReservationToRentalUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<RentalDetailEntity>> call({
    required String reservationCode,
    required int staffId,
  }) {
    if (reservationCode.trim().isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Mã đơn đặt xe không được để trống'),
        ),
      );
    }
    if (staffId <= 0) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Thông tin nhân viên phụ trách không hợp lệ'),
        ),
      );
    }
    return _repository.convertReservationToRental(
      reservationCode: reservationCode.trim(),
      staffId: staffId,
    );
  }
}
