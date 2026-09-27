import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';
import 'package:rental_car/features/home/domain/repositories/home_repository.dart';

class GetStationsByCityUseCase {
  const GetStationsByCityUseCase({required HomeRepository repository})
    : _repository = repository;

  final HomeRepository _repository;

  Future<Result<List<StationEntity>>> call(String city) {
    return _repository.getStationsByCity(city);
  }
}
