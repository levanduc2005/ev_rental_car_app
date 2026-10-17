import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/features/emergency/domain/entities/emergency_type.dart';

class EmergencyTypeSelector extends StatelessWidget {
  const EmergencyTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final EmergencyType selectedType;
  final ValueChanged<EmergencyType> onTypeSelected;

  IconData _getIcon(EmergencyType type) {
    return switch (type) {
      EmergencyType.outOfBattery => Icons.battery_alert_rounded,
      EmergencyType.flatTire => Icons.tire_repair_rounded,
      EmergencyType.accident => Icons.car_crash_rounded,
      EmergencyType.technicalFault => Icons.build_circle_rounded,
    };
  }

  Color _getColor(EmergencyType type) {
    return switch (type) {
      EmergencyType.outOfBattery => const Color(0xFFF59E0B),
      EmergencyType.flatTire => const Color(0xFFEF4444),
      EmergencyType.accident => const Color(0xFFDC2626),
      EmergencyType.technicalFault => const Color(0xFF8B5CF6),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFDC2626),
              size: 20,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Chọn loại sự cố gặp phải:',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.35,
          ),
          itemCount: EmergencyType.values.length,
          itemBuilder: (context, index) {
            final type = EmergencyType.values[index];
            final isSelected = type == selectedType;
            final typeColor = _getColor(type);

            return InkWell(
              onTap: () => onTypeSelected(type),
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? typeColor.withValues(alpha: 0.12)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected ? typeColor : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(type),
                            color: typeColor,
                            size: 22,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: typeColor,
                            size: 20,
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.displayName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? typeColor
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          type.shortDescription,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
