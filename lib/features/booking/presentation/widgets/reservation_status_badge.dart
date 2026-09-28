import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

/// Reusable Badge hiển thị trạng thái chuẩn của Đơn đặt xe e-Motion
class ReservationStatusBadge extends StatelessWidget {
  const ReservationStatusBadge({
    required this.status,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    super.key,
  });

  final String status;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final statusUpper = status.toUpperCase();

    final (color, label, icon) = switch (statusUpper) {
      'PENDING' || 'WAITING_PAYMENT' => (
        Colors.amber.shade800,
        'Chờ thanh toán',
        Icons.access_time_rounded,
      ),
      'CONFIRM' || 'CONFIRMED' || 'DEPOSITED' => (
        const Color(0xFF2563EB),
        'Đã cọc - Chờ nhận xe',
        Icons.verified_outlined,
      ),
      'ACTIVE' || 'IN_PROGRESS' => (
        Colors.green.shade600,
        'Đang thuê xe',
        Icons.directions_car_filled_outlined,
      ),
      'COMPLETED' => (
        Colors.teal.shade700,
        'Hoàn tất chuyến',
        Icons.check_circle_outline,
      ),
      'CANCELLED' => (Colors.grey.shade600, 'Đã hủy', Icons.cancel_outlined),
      'FAILED' => (AppColors.error, 'Hết hạn thanh toán', Icons.error_outline),
      'OVERDUE' => (
        Colors.deepOrange.shade700,
        'Quá hạn nhận xe',
        Icons.warning_amber_rounded,
      ),
      _ => (Colors.blueGrey, status, Icons.info_outline),
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
