import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';

class SubmitPickupChecklistUseCase {
  const SubmitPickupChecklistUseCase(this._repository);

  final CheckinRepository _repository;

  Future<Result<PickupChecklistEntity>> call({
    required int rentalId,
    required int odometer,
    required int batteryPercentage,
    required AccessoryChecklistEntity accessories,
    required CarImagesEntity images,
    String? note,
  }) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    if (odometer <= 0) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Số công-tơ-mét (ODO) phải lớn hơn 0'),
        ),
      );
    }
    if (batteryPercentage <= 0 || batteryPercentage > 100) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Phần trăm pin xe phải từ 1% đến 100%'),
        ),
      );
    }
    if (!images.isComplete) {
      return Future.value(
        const Result.err(
          DataFailure(
            message:
                'Vui lòng chụp và tải lên ít nhất một ảnh ngoại quan của xe',
          ),
        ),
      );
    }

    return _repository.submitPickupChecklist(
      rentalId: rentalId,
      odometer: odometer,
      batteryPercentage: batteryPercentage,
      accessories: accessories,
      images: images,
      note: note,
    );
  }
}
