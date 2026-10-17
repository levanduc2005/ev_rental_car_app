import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/active_trip/data/datasources/active_rental_remote_data_source.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';
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
}
