import 'package:flutter/material.dart';

class RentalStatusBadge extends StatelessWidget {
  const RentalStatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status.toUpperCase()) {
      'ONGOING' => ('Đang thuê', const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
      'CONFIRM' => ('Đã xác nhận', const Color(0xFFECFDF5), const Color(0xFF059669)),
      'CHECKING' => ('Đang kiểm tra xe', const Color(0xFFFFFBEB), const Color(0xFFD97706)),
      'PENDING_FEE' => ('Chờ quyết toán phí', const Color(0xFFFFFBEB), const Color(0xFFD97706)),
      'OVERDUE' => ('Quá hạn trả', const Color(0xFFFEF2F2), const Color(0xFFDC2626)),
      'COMPLETED' => ('Hoàn thành', const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
      _ => ('Đã hủy', const Color(0xFFF1F5F9), const Color(0xFF64748B)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
