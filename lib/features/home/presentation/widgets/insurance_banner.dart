import 'package:flutter/material.dart';
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
          color: const Color(0xFFF0F5FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD9E6FF)),
        ),
        child: Row(
          children: [
            // Icon khiên tròn
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFD6E4FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: Color(0xFF1976D2),
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
