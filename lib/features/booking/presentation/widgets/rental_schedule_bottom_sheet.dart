import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

class RentalScheduleBottomSheet extends StatefulWidget {
  const RentalScheduleBottomSheet({
    required this.initialStart,
    required this.initialEnd,
    required this.onScheduleChanged,
    super.key,
  });

  final DateTime initialStart;
  final DateTime initialEnd;
  final void Function(DateTime start, DateTime end) onScheduleChanged;

  static Future<void> show({
    required BuildContext context,
    required DateTime initialStart,
    required DateTime initialEnd,
    required void Function(DateTime start, DateTime end) onScheduleChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => RentalScheduleBottomSheet(
        initialStart: initialStart,
        initialEnd: initialEnd,
        onScheduleChanged: onScheduleChanged,
      ),
    );
  }

  @override
  State<RentalScheduleBottomSheet> createState() =>
      _RentalScheduleBottomSheetState();
}

class _RentalScheduleBottomSheetState extends State<RentalScheduleBottomSheet> {
  late DateTime _start;
  late DateTime _end;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  void _validate() {
    final now = DateTime.now();
    if (_start.isBefore(now.add(const Duration(hours: 3)))) {
      _validationError =
          'Thời gian nhận xe phải sau hiện tại ít nhất 3 tiếng.';
    } else if (_end.difference(_start).inHours < 4) {
      _validationError = 'Thời lượng thuê xe tối thiểu là 4 tiếng.';
    } else {
      _validationError = null;
    }
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final current = isStart ? _start : _end;
    final firstAllowedDate = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: firstAllowedDate,
      lastDate: firstAllowedDate.add(const Duration(days: 90)),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current.hour, minute: 0),
      helpText: 'Chọn giờ nhận xe (Chỉ chọn giờ tròn :00)',
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      final updated = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
      );

      if (isStart) {
        _start = updated;
        if (_end.isBefore(_start.add(const Duration(hours: 4)))) {
          _end = _start.add(const Duration(hours: 4));
        }
      } else {
        _end = updated;
      }
      _validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final durationHours = _end.difference(_start).inHours;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn thời gian thuê xe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Quy định: Thời gian nhận xe sau hiện tại tối thiểu 3 tiếng, giờ tròn :00, thuê tối thiểu 4 tiếng.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // Khung chọn Nhận xe
          InkWell(
            onTap: () => _pickDateTime(isStart: true),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thời gian nhận xe',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        BookingFormatters.formatDateTime(_start),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Đổi',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Khung chọn Trả xe
          InkWell(
            onTap: () => _pickDateTime(isStart: false),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thời gian trả xe',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        BookingFormatters.formatDateTime(_end),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Đổi',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Badge hiển thị tổng thời gian
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thời lượng dự kiến:',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                ),
                Text(
                  '$durationHours tiếng (${(durationHours / 24).toStringAsFixed(1)} ngày)',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E40AF),
                  ),
                ),
              ],
            ),
          ),

          if (_validationError != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationError!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            onPressed: _validationError != null
                ? null
                : () {
                    widget.onScheduleChanged(_start, _end);
                    Navigator.of(context).pop();
                  },
            child: const Text(
              'Áp dụng thời gian thuê',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
