import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class CreateRentalUseCase {
  const CreateRentalUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<RentalDetailEntity>> call({
    required DateTime startTime,
    required DateTime endTime,
    required int vehicleId,
    required String email,
    required int staffId,
  }) {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Vui lòng nhập địa chỉ email người thuê.'),
        ),
      );
    }
    if (vehicleId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã xe không hợp lệ.')),
      );
    }
    if (staffId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã nhân viên không hợp lệ.')),
      );
    }
    if (!endTime.isAfter(startTime)) {
      return Future.value(
        const Result.err(
          DataFailure(
            message: 'Thời gian trả xe phải diễn ra sau thời gian nhận xe.',
          ),
        ),
      );
    }

    return _repository.createRental(
      startTime: startTime,
      endTime: endTime,
      vehicleId: vehicleId,
      email: cleanEmail,
      staffId: staffId,
    );
  }
}
