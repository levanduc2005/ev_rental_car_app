import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/utils/booking_formatters.dart';

/// Card thông tin lịch trình thuê xe (thời gian nhận/trả & địa điểm)
class BookingScheduleCard extends StatelessWidget {
  const BookingScheduleCard({
    required this.startDateTime,
    required this.endDateTime,
    required this.pickupLocation,
    required this.returnLocation,
    this.title = 'Lịch trình thuê xe',
    this.onEditSchedule,
    super.key,
  });

  final DateTime startDateTime;
  final DateTime endDateTime;
  final String pickupLocation;
  final String returnLocation;
  final String title;
  final VoidCallback? onEditSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (onEditSchedule != null)
                TextButton(
                  onPressed: onEditSchedule,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Thay đổi', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          const Divider(height: 20),
          _ScheduleItem(
            icon: Icons.login_rounded,
            iconColor: Colors.green.shade600,
            label: 'Thời gian nhận xe',
            value: BookingFormatters.formatDateTime(startDateTime),
          ),
          const SizedBox(height: 12),
          _ScheduleItem(
            icon: Icons.logout_rounded,
            iconColor: Colors.orange.shade700,
            label: 'Thời gian trả xe',
            value: BookingFormatters.formatDateTime(endDateTime),
          ),
          const SizedBox(height: 12),
          _ScheduleItem(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFF2563EB),
            label: 'Điểm nhận & trả xe',
            value: pickupLocation,
          ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
