import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

class AccessoriesChecklistCard extends StatelessWidget {
  const AccessoriesChecklistCard({
    super.key,
    required this.accessories,
    required this.onChanged,
  });

  final AccessoryChecklistEntity accessories;
  final void Function({
    bool? hasPortableCharger,
    bool? hasTireRepairKit,
    bool? hasChargingCard,
  })
  onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist_rounded, color: Color(0xFF2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                'Phụ kiện & Trang thiết bị đi kèm',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Kiểm tra và tích chọn các phụ kiện hiện có trong xe lúc nhận:',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Divider(height: 20),

          // 1. Cáp sạc di động
          _buildItem(
            icon: Icons.power_rounded,
            title: 'Cáp sạc di động',
            subtitle: 'Bộ sạc 220V kèm adapter cắm ổ điện dân dụng',
            value: accessories.hasPortableCharger,
            onChanged: (val) => onChanged(hasPortableCharger: val),
          ),
          const Divider(height: 12),

          // 2. Bộ kích lốp & bơm vá lốp
          _buildItem(
            icon: Icons.build_circle_outlined,
            title: 'Bộ kích lốp & Bơm vá lốp khẩn cấp',
            subtitle: 'Đặt dưới tấm lót khoang hành lý phía sau',
            value: accessories.hasTireRepairKit,
            onChanged: (val) => onChanged(hasTireRepairKit: val),
          ),
          const Divider(height: 12),

          // 3. Thẻ sạc xe e-Motion
          _buildItem(
            icon: Icons.credit_card_rounded,
            title: 'Thẻ sạc xe e-Motion',
            subtitle:
                'Dùng để cắm và kích hoạt sạc tại tất cả các trạm e-Motion',
            value: accessories.hasChargingCard,
            onChanged: (val) => onChanged(hasChargingCard: val),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: value ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: const Color(0xFF2563EB),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
