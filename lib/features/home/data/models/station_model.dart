import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/home/domain/entities/station_entity.dart';

part 'station_model.freezed.dart';
part 'station_model.g.dart';

@freezed
abstract class StationModel with _$StationModel {
  const factory StationModel({
    required int id,
    required String name,
    @Default('') String address,
    String? city,
    double? latitude,
    double? longitude,
    String? status,
  }) = _StationModel;

  factory StationModel.fromJson(Map<String, dynamic> json) =>
      _$StationModelFromJson(json);
}

extension StationModelX on StationModel {
  StationEntity toEntity() {
    return StationEntity(
      id: id,
      name: name,
      address: address,
      city: city,
      latitude: latitude,
      longitude: longitude,
      status: status,
    );
  }
}
