import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_result_entity.dart';
import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class ActiveRentalRepositoryImpl implements ActiveRentalRepository {
  const ActiveRentalRepositoryImpl({
    required ActiveRentalRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ActiveRentalRemoteDataSource _remoteDataSource;

  @override
  Future<Result<ActiveRentalEntity>> getActiveRentalDetail(int rentalId) {
    return safeCall(() async {
      final model = await _remoteDataSource.getRentalDetail(rentalId);
      return model.toEntity();
    });
  }

  @override
  Future<Result<ActiveRentalEntity?>> getCurrentActiveRental({
    required String email,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.getCurrentActiveRental(
        email: email,
      );
      return model?.toEntity();
    });
  }

  @override
  Future<Result<List<VehicleScheduleEntity>>> getVehicleSchedule(
    int vehicleId,
  ) {
    return safeCall(() async {
      final models = await _remoteDataSource.getVehicleSchedule(vehicleId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<ExtendRentalPreviewEntity>> previewExtendRental({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.previewExtendRental(
        rentalId: rentalId,
        newReturnTime: newReturnTime,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<ExtendRentalResultEntity>> extendRental({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.extendRental(
        rentalId: rentalId,
        newReturnTime: newReturnTime,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<bool>> checkExtendPayment(int rentalId) {
    return safeCall(() => _remoteDataSource.checkExtendPayment(rentalId));
  }
}
