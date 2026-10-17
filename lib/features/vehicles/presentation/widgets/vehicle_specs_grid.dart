import 'package:flutter/material.dart';

/// Đặc điểm xe (Chuẩn 100% dữ liệu từ Backend)
class VehicleSpecsGrid extends StatelessWidget {
  const VehicleSpecsGrid({
    required this.seats,
    required this.fuelType,
    required this.consumption,
    this.category,
    this.plateNumber,
    this.pointPerHour = 4,
    super.key,
  });

  final String seats;
  final String fuelType;
  final String consumption;
  final String? category;
  final String? plateNumber;
  final int pointPerHour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đặc điểm xe',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.group_outlined,
                label: 'Số ghế',
                value: seats,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.category_outlined,
                label: 'Phân khúc',
                value: (category != null && category!.trim().isNotEmpty)
                    ? category!.trim()
                    : 'Xe điện EV',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.battery_charging_full_rounded,
                label: 'Nhiên liệu',
                value: fuelType,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.speed_rounded,
                label: 'Tiêu hao',
                value: consumption,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSpecCard(
                icon: Icons.stars_rounded,
                label: 'Điểm thưởng',
                value: '$pointPerHour điểm/h',
                iconColor: const Color(0xFFEAB308),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.badge_outlined,
                label: 'Biển số xe',
                value: (plateNumber != null && plateNumber!.trim().isNotEmpty)
                    ? plateNumber!.trim()
                    : 'Chưa cập nhật',
                iconColor: const Color(0xFF1976D2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecCard({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(icon, size: 18, color: iconColor ?? const Color(0xFF1976D2)),
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
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
