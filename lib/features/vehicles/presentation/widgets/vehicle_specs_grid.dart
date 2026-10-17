import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

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
            color: AppColors.textPrimary,
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
                iconColor: AppColors.primary,
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
                iconColor: AppColors.accent,
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
                iconColor: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSpecCard(
                icon: Icons.speed_rounded,
                label: 'Tiêu hao',
                value: consumption,
                iconColor: AppColors.primary,
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
                iconColor: AppColors.warning,
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
                iconColor: AppColors.primary,
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 18, color: iconColor ?? AppColors.primary),
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
                    color: AppColors.textPrimary,
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
