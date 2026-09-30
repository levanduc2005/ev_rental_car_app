import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  const VehicleRepositoryImpl({
    required VehicleRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final VehicleRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<VehicleEntity>>> getVehicles({VehicleFilter? filter}) {
    return safeCall(() async {
      final models = await _remoteDataSource.getVehicles(filter: filter);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<VehicleEntity>>> getHomeVehicles() {
    return safeCall(() async {
      final models = await _remoteDataSource.getVehicles();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<VehicleEntity>> getVehicleDetail(String id) {
    return safeCall(() async {
      final model = await _remoteDataSource.getVehicleDetail(id);
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<String>>> getVehicleBrands() {
    return safeCall(() => _remoteDataSource.getVehicleBrands());
  }

  @override
  Future<Result<List<String>>> getVehicleCategories() {
    return safeCall(() => _remoteDataSource.getVehicleCategories());
  }
}
