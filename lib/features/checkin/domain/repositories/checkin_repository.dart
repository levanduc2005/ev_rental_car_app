import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

abstract interface class CheckinRepository {
  Future<Result<LicenseStatusEntity>> getLicenseStatus();

  Future<Result<String>> uploadCarImage(String filePath);

  Future<Result<PickupChecklistEntity>> submitPickupChecklist({
    required int rentalId,
    required int odometer,
    required int batteryPercentage,
    required AccessoryChecklistEntity accessories,
    required CarImagesEntity images,
    String? note,
  });

  Future<Result<DocuSealContractEntity>> generateContract(int rentalId);

  Future<Result<ContractConfirmResultEntity>> confirmContractSigned(
    int rentalId,
  );
}
