import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class CreateOrUpdateVehicleLogUseCase {
  const CreateOrUpdateVehicleLogUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<VehicleLogEntity>> call({
    required int rentalId,
    required int vehicleId,
    required List<Map<String, dynamic>> repairItems,
    required List<String> imgs,
    int? staffId,
    int? logId,
  }) {
    if (rentalId <= 0 || vehicleId <= 0) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Thông tin xe hoặc đơn thuê không hợp lệ'),
        ),
      );
    }

    return _repository.createOrUpdateVehicleLog(
      rentalId: rentalId,
      vehicleId: vehicleId,
      repairItems: repairItems,
      imgs: imgs,
      staffId: staffId,
      logId: logId,
    );
  }
}
