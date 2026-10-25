import 'package:rental_car/features/active_trip/domain/entities/vehicle_schedule_entity.dart';

class VehicleScheduleModel {
  const VehicleScheduleModel({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  factory VehicleScheduleModel.fromJson(Map<String, dynamic> json) {
    return VehicleScheduleModel(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );
  }

  VehicleScheduleEntity toEntity() =>
      VehicleScheduleEntity(startTime: startTime, endTime: endTime);
}
