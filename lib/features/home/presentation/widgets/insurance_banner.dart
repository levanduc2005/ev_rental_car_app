import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';

class InsuranceBanner extends StatelessWidget {
  const InsuranceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            // Icon khiên tròn
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Nội dung bảo hiểm
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bảo hiểm chuyến đi trọn gói',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'An tâm lăn bánh trên mọi nẻo đường cùng đối tác bảo hiểm liên kết của e-Motion.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
