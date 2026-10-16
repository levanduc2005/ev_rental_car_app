import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';

class ConfirmContractSignedUseCase {
  const ConfirmContractSignedUseCase(this._repository);

  final CheckinRepository _repository;

  Future<Result<ContractConfirmResultEntity>> call(int rentalId) {
    if (rentalId <= 0) {
      return Future.value(
        const Result.err(DataFailure(message: 'Mã đơn thuê xe không hợp lệ')),
      );
    }
    return _repository.confirmContractSigned(rentalId);
  }
}
