import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkin/data/datasources/checkin_remote_data_source.dart';
import 'package:rental_car/features/checkin/domain/entities/docuseal_contract_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/license_status_entity.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  const CheckinRepositoryImpl({
    required CheckinRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CheckinRemoteDataSource _remoteDataSource;

  @override
  Future<Result<LicenseStatusEntity>> getLicenseStatus() async {
    try {
      final model = await _remoteDataSource.getLicenseStatus();
      return Result.ok(model);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> uploadCarImage(String filePath) async {
    try {
      final url = await _remoteDataSource.uploadCarImage(filePath);
      return Result.ok(url);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<PickupChecklistEntity>> submitPickupChecklist({
    required int rentalId,
    required int odometer,
    required int batteryPercentage,
    required AccessoryChecklistEntity accessories,
    required CarImagesEntity images,
    String? note,
  }) async {
    try {
      final result = await _remoteDataSource.createPickupChecklist(
        rentalId: rentalId,
        odometer: odometer,
        batteryPercentage: batteryPercentage,
        accessories: accessories,
        images: images,
        note: note,
      );
      return Result.ok(result);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<DocuSealContractEntity>> generateContract(int rentalId) async {
    try {
      final contract = await _remoteDataSource.generateContract(rentalId);
      return Result.ok(contract);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<ContractConfirmResultEntity>> confirmContractSigned(
    int rentalId,
  ) async {
    try {
      final res = await _remoteDataSource.confirmContractSigned(rentalId);
      return Result.ok(res);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(ServerFailure(message: e.toString()));
    }
  }
}
