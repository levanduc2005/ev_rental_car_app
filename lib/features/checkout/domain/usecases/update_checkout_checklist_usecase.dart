import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class UpdateCheckoutChecklistUseCase {
  const UpdateCheckoutChecklistUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<RentalChecklistEntity>> call({
    required int id,
    required int rentalId,
    required double currentBattery,
    required String img,
    required String staffEmail,
  }) {
    if (id <= 0 || rentalId <= 0) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Mã đơn thuê hoặc biên bản không hợp lệ'),
        ),
      );
    }
    if (currentBattery < 0 || currentBattery > 100) {
      return Future.value(
        const Result.err(
          DataFailure(
            message: 'Phần trăm pin phải nằm trong khoảng từ 0% đến 100%',
          ),
        ),
      );
    }

    return _repository.updateChecklist(
      id: id,
      rentalId: rentalId,
      type: 'CHECK_OUT',
      currentBattery: currentBattery,
      img: img,
      staffEmail: staffEmail,
    );
  }
}
