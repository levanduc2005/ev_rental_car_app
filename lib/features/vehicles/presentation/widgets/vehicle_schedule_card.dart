import 'package:flutter/material.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';

/// Thẻ hiển thị lịch xe bận và cảnh báo nếu khung giờ chọn bị trùng
class VehicleScheduleCard extends StatelessWidget {
  const VehicleScheduleCard({
    required this.scheduleSlots,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onChangeSchedule,
    this.isLoading = false,
    super.key,
  });

  final List<VehicleScheduleSlot> scheduleSlots;
  final DateTime selectedStart;
  final DateTime selectedEnd;
  final VoidCallback onChangeSchedule;
  final bool isLoading;

  String _formatSlot(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$h:$m, $d/$mo';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasConflict = scheduleSlots.any((slot) {
      return selectedStart.isBefore(slot.endTime) &&
          selectedEnd.isAfter(slot.startTime);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasConflict ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasConflict
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    hasConflict
                        ? Icons.warning_amber_rounded
                        : Icons.calendar_month_outlined,
                    size: 18,
                    color: hasConflict
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF1976D2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hasConflict ? 'LỊCH XE TRÙNG' : 'LỊCH TRÌNH CỦA XE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: hasConflict
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: hasConflict
                        ? const Color(0xFFFEE2E2)
                        : (scheduleSlots.isEmpty
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hasConflict
                        ? 'Đã có người đặt'
                        : (scheduleSlots.isEmpty
                              ? 'Xe đang trống lịch'
                              : '${scheduleSlots.length} khoảng bận'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: hasConflict
                          ? const Color(0xFFDC2626)
                          : (scheduleSlots.isEmpty
                                ? const Color(0xFF059669)
                                : const Color(0xFF475569)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Cảnh báo trùng lịch
          if (hasConflict) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF87171)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: Color(0xFFDC2626),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Xe đã có khách đặt trong khung giờ bạn chọn!',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Vui lòng đổi khung giờ nhận/trả xe khác để tiếp tục đặt xe.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFDC2626)),
                        foregroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onChangeSchedule,
                      child: const Text(
                        'Đổi giờ nhận xe',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Danh sách các khoảng bận sắp tới
          if (scheduleSlots.isNotEmpty) ...[
            const Text(
              'Các khung giờ xe bận sắp tới:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: scheduleSlots.take(4).map((slot) {
                final isCurrentConflict =
                    selectedStart.isBefore(slot.endTime) &&
                    selectedEnd.isAfter(slot.startTime);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentConflict
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentConflict
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 13,
                        color: isCurrentConflict
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${_formatSlot(slot.startTime)} - ${_formatSlot(slot.endTime)}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isCurrentConflict
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isCurrentConflict
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ] else if (!hasConflict) ...[
            const Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 15,
                  color: Color(0xFF059669),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Xe sẵn sàng phục vụ trong toàn bộ khoảng thời gian này.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
