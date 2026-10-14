import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class GetChecklistsByRentalIdUseCase {
  const GetChecklistsByRentalIdUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<List<RentalChecklistEntity>>> call(int rentalId) {
    return _repository.getChecklistsByRentalId(rentalId);
  }
}
