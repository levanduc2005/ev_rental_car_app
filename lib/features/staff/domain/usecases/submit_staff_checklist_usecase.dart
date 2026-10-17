import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class SubmitStaffCheckListUseCase {
  const SubmitStaffCheckListUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<RentalChecklistEntity>> call({
    required int rentalId,
    required String staffEmail,
    required int currentBattery,
    required String img,
  }) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    if (currentBattery <= 0 || currentBattery > 100) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Phần trăm pin xe phải từ 1% đến 100%'),
        ),
      );
    }
    if (img.trim().isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(
            message: 'Vui lòng chụp ít nhất 1 ảnh ngoại quan xe lúc bàn giao',
          ),
        ),
      );
    }

    return _repository.submitCheckInChecklist(
      rentalId: rentalId,
      staffEmail: staffEmail,
      currentBattery: currentBattery,
      img: img,
    );
  }
}
