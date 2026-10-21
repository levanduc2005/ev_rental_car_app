import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class CreateCheckoutChecklistUseCase {
  const CreateCheckoutChecklistUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<RentalChecklistEntity>> call({
    required int rentalId,
    required double currentBattery,
    required String img,
    String? staffEmail,
  }) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê không hợp lệ')),
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

    return _repository.createChecklist(
      rentalId: rentalId,
      type: 'CHECK_OUT',
      currentBattery: currentBattery,
      img: img,
      staffEmail: staffEmail,
    );
  }
}
