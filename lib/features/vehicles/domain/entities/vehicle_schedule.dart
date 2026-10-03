/// Một khoảng thời gian xe đã bận (đã có người đặt / đang thuê)
class VehicleScheduleSlot {
  const VehicleScheduleSlot({required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  /// Kiểm tra xem khoảng thời gian [from, to] có xung đột với slot bận này không
  bool conflictsWith(DateTime from, DateTime to) {
    return from.isBefore(endTime) && to.isAfter(startTime);
  }

  /// Kiểm tra xem một ngày cụ thể có nằm trong khoảng bận không
  bool containsDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return conflictsWith(dayStart, dayEnd);
  }
}
