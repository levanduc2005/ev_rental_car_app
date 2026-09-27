import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/home/data/datasources/home_remote_data_source.dart';
import 'package:rental_car/features/home/data/models/station_model.dart';
import 'package:rental_car/features/home/data/models/vehicle_model.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';
import 'package:rental_car/features/home/domain/entities/vehicle_entity.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<VehicleEntity>>> getHomeVehicles() {
    return safeCall(() async {
      final models = await _remoteDataSource.getHomeVehicles();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<List<String>>> getVehicleBrands() {
    return safeCall(() async {
      return await _remoteDataSource.getVehicleBrands();
    });
  }

  @override
  Future<Result<List<StationEntity>>> getStationsByCity(String city) {
    return safeCall(() async {
      final models = await _remoteDataSource.getStationsByCity(city);
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
