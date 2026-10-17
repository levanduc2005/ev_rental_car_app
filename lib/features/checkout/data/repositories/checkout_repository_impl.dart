import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_log_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl({
    required CheckoutRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CheckoutRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<RentalChecklistEntity>>> getChecklistsByRentalId(
    int rentalId,
  ) {
    return safeCall(() async {
      return await _remoteDataSource.getChecklistsByRentalId(rentalId);
    });
  }

  @override
  Future<Result<RentalChecklistEntity>> createChecklist({
    required int rentalId,
    required String type,
    required double currentBattery,
    required String img,
    String? staffEmail,
  }) {
    return safeCall(() async {
      return await _remoteDataSource.createChecklist(
        rentalId: rentalId,
        type: type,
        currentBattery: currentBattery,
        img: img,
        staffEmail: staffEmail,
      );
    });
  }

  @override
  Future<Result<VehicleLogEntity?>> getVehicleLogByRentalId(int rentalId) {
    return safeCall(() async {
      return await _remoteDataSource.getVehicleLogByRentalId(rentalId);
    });
  }

  @override
  Future<Result<VehicleLogEntity>> createOrUpdateVehicleLog({
    required int rentalId,
    required int vehicleId,
    required List<Map<String, dynamic>> repairItems,
    required List<String> imgs,
    int? staffId,
    int? logId,
  }) {
    return safeCall(() async {
      return await _remoteDataSource.createOrUpdateVehicleLog(
        rentalId: rentalId,
        vehicleId: vehicleId,
        repairItems: repairItems,
        imgs: imgs,
        staffId: staffId,
        logId: logId,
      );
    });
  }

  @override
  Future<Result<RentalOverviewEntity>> getRentalOverview(int rentalId) {
    return safeCall(() async {
      return await _remoteDataSource.getRentalOverview(rentalId);
    });
  }

  @override
  Future<Result<Map<String, dynamic>>> processCheckoutPayment(int rentalId) {
    return safeCall(() async {
      return await _remoteDataSource.processCheckoutPayment(rentalId);
    });
  }
}
