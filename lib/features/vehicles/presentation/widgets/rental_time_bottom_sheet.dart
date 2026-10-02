import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Modal Bottom Sheet chọn ngày và giờ thuê xe chuyên nghiệp
class RentalTimeBottomSheet extends StatefulWidget {
  const RentalTimeBottomSheet({
    this.initialStartTime,
    this.initialEndTime,
    this.initialHourPackage,
    this.onApply,
    super.key,
  });

  final DateTime? initialStartTime;
  final DateTime? initialEndTime;
  final int? initialHourPackage;
  final void Function(DateTime startTime, DateTime endTime, int? hourPackage)?
  onApply;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    DateTime? initialStartTime,
    DateTime? initialEndTime,
    int? initialHourPackage,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RentalTimeBottomSheet(
        initialStartTime: initialStartTime,
        initialEndTime: initialEndTime,
        initialHourPackage: initialHourPackage,
        onApply: (start, end, pkg) {
          Navigator.of(
            context,
          ).pop({'startTime': start, 'endTime': end, 'hourPackage': pkg});
        },
      ),
    );
  }

  @override
  State<RentalTimeBottomSheet> createState() => _RentalTimeBottomSheetState();
}

class _RentalTimeBottomSheetState extends State<RentalTimeBottomSheet> {
  late DateTime _startTime;
  late DateTime _endTime;
  int? _selectedPackage;

  final List<Map<String, dynamic>> _quickPackages = [
    {'label': '4 giờ', 'hours': 4},
    {'label': '8 giờ', 'hours': 8},
    {'label': '12 giờ', 'hours': 12},
    {'label': '24 giờ (1 ngày)', 'hours': 24},
    {'label': '2 ngày (48h)', 'hours': 48},
    {'label': '3 ngày (72h)', 'hours': 72},
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // BE quy định: startTime phải sau thời điểm hiện tại ít nhất 3 giờ và theo giờ chẵn (:00)
    final minStartHour = now.hour + (now.minute > 0 ? 4 : 3);
    final calculatedStart = DateTime(
      now.year,
      now.month,
      now.day,
      minStartHour,
    );
    final rawStart = widget.initialStartTime ?? calculatedStart;
    _startTime = rawStart.isBefore(now.add(const Duration(hours: 3)))
        ? calculatedStart
        : DateTime(rawStart.year, rawStart.month, rawStart.day, rawStart.hour);

    _selectedPackage = widget.initialHourPackage;
    if (widget.initialEndTime != null) {
      _endTime = DateTime(
        widget.initialEndTime!.year,
        widget.initialEndTime!.month,
        widget.initialEndTime!.day,
        widget.initialEndTime!.hour,
      );
    } else if (_selectedPackage != null) {
      _endTime = _startTime.add(Duration(hours: _selectedPackage!));
    } else {
      _selectedPackage = 24;
      _endTime = _startTime.add(const Duration(hours: 24));
    }
  }

  int get _totalHours {
    final diff = _endTime.difference(_startTime).inHours;
    return diff > 0 ? diff : 4;
  }

  String get _durationSummary {
    final hours = _totalHours;
    if (hours < 24) return '$hours giờ';
    final days = hours ~/ 24;
    final rem = hours % 24;
    if (rem == 0) return '$days ngày ($hours giờ)';
    return '$days ngày $rem giờ ($hours giờ)';
  }

  void _selectQuickPackage(int hours) {
    setState(() {
      _selectedPackage = hours;
      _endTime = _startTime.add(Duration(hours: hours));
    });
  }

  Future<void> _pickDate(bool isStart) async {
    final initialDate = isStart ? _startTime : _endTime;
    final firstDate = isStart ? DateTime.now() : _startTime;
    final lastDate = DateTime.now().add(const Duration(days: 90));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2),
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _startTime.hour,
          );
          // Nếu ngày kết thúc nhỏ hơn ngày bắt đầu, đẩy lùi kết thúc
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(Duration(hours: _selectedPackage ?? 24));
          }
        } else {
          _endTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            _endTime.hour,
          );
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(const Duration(hours: 4));
          }
          _selectedPackage = null;
        }
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final currentTime = TimeOfDay.fromDateTime(isStart ? _startTime : _endTime);
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1976D2),
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          DateTime newStart = DateTime(
            _startTime.year,
            _startTime.month,
            _startTime.day,
            picked.hour,
          );
          final now = DateTime.now();
          if (newStart.isBefore(now.add(const Duration(hours: 3)))) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Giờ nhận xe phải sau thời điểm hiện tại ít nhất 3 giờ',
                ),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 2),
              ),
            );
            newStart = DateTime(
              now.year,
              now.month,
              now.day,
              now.hour + (now.minute > 0 ? 4 : 3),
            );
          }
          _startTime = newStart;
          if (_endTime.isBefore(_startTime.add(const Duration(hours: 4)))) {
            _endTime = _startTime.add(Duration(hours: _selectedPackage ?? 24));
          }
        } else {
          DateTime newEnd = DateTime(
            _endTime.year,
            _endTime.month,
            _endTime.day,
            picked.hour,
          );
          if (newEnd.isBefore(_startTime.add(const Duration(hours: 4)))) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Thời gian trả xe phải sau giờ nhận tối thiểu 4 giờ',
                ),
                backgroundColor: Color(0xFFEF4444),
                duration: Duration(seconds: 2),
              ),
            );
            newEnd = _startTime.add(const Duration(hours: 4));
          }
          _endTime = newEnd;
          _selectedPackage = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh gạt modal
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tiêu đề + Nút Đóng
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF1976D2),
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Thời gian thuê xe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: const Color(0xFF64748B),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Khối chọn Nhận xe và Trả xe
            Row(
              children: [
                // Cột Nhận xe
                Expanded(
                  child: _DateTimeBox(
                    title: 'NHẬN XE',
                    titleColor: const Color(0xFF10B981),
                    icon: Icons.flight_land_rounded,
                    dateText: dateFormat.format(_startTime),
                    timeText: timeFormat.format(_startTime),
                    onTapDate: () => _pickDate(true),
                    onTapTime: () => _pickTime(true),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                ),
                // Cột Trả xe
                Expanded(
                  child: _DateTimeBox(
                    title: 'TRẢ XE',
                    titleColor: const Color(0xFFEF4444),
                    icon: Icons.flight_takeoff_rounded,
                    dateText: dateFormat.format(_endTime),
                    timeText: timeFormat.format(_endTime),
                    onTapDate: () => _pickDate(false),
                    onTapTime: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Tiêu đề chọn gói nhanh
            const Text(
              'Gói thời gian phổ biến',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),

            // Danh sách chip gói nhanh
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickPackages.map((pkg) {
                final hours = pkg['hours'] as int;
                final label = pkg['label'] as String;
                final isSelected = _selectedPackage == hours;

                return InkWell(
                  onTap: () => _selectQuickPackage(hours),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1976D2)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1976D2)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Thanh tóm tắt tổng thời gian
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: Color(0xFF16A34A),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Tổng thời gian thuê: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _durationSummary,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Nút Áp dụng
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply?.call(_startTime, _endTime, _selectedPackage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Áp dụng thời gian',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeBox extends StatelessWidget {
  const _DateTimeBox({
    required this.title,
    required this.titleColor,
    required this.icon,
    required this.dateText,
    required this.timeText,
    required this.onTapDate,
    required this.onTapTime,
  });

  final String title;
  final Color titleColor;
  final IconData icon;
  final String dateText;
  final String timeText;
  final VoidCallback onTapDate;
  final VoidCallback onTapTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: titleColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Nút bấm chọn ngày
          InkWell(
            onTap: onTapDate,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Nút bấm chọn giờ
          InkWell(
            onTap: onTapTime,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      timeText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
