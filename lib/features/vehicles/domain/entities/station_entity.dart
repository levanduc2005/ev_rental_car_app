import 'package:freezed_annotation/freezed_annotation.dart';

part 'station_entity.freezed.dart';

@freezed
abstract class StationEntity with _$StationEntity {
  const factory StationEntity({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int availableVehiclesCount,
    required int totalSlots,
  }) = _StationEntity;
}
