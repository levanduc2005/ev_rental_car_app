import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class GetVehicleLogByRentalIdUseCase {
  const GetVehicleLogByRentalIdUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<VehicleLogEntity?>> call(int rentalId) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê không hợp lệ')),
      );
    }

    return _repository.getVehicleLogByRentalId(rentalId);
  }
}
