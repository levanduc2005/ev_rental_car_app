/// Thực thể biểu diễn một khoảng thời gian xe đã bận (lịch thuê/đặt trước)
class VehicleScheduleEntity {
  const VehicleScheduleEntity({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;
}
