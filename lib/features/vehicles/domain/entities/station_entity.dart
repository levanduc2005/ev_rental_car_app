import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_entity.freezed.dart';

@freezed
abstract class StationEntity with _$StationEntity {
  const factory StationEntity({
    required int id,
    required String name,
    @Default('') String address,
    String? city,
    double? latitude,
    double? longitude,
    String? status,
    int? availableVehiclesCount,
    int? totalSlots,
  }) = _StationEntity;
}
