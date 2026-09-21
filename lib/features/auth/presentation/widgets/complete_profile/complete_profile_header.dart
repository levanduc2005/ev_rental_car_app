import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/core/widgets/gap.dart';

/// Phần header minh họa của trang hoàn tất hồ sơ: icon badge, câu hỏi và mô tả.
class CompleteProfileHeader extends StatelessWidget {
  const CompleteProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(24),
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.badge_outlined,
              size: 42,
              color: AppColors.primary,
            ),
          ),
        ),
        const Gap(28),
        Text(
          'Họ và tên của bạn là gì?',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(10),
        Text(
          'Giúp chúng tôi nhận diện danh tính và cá nhân hóa trải nghiệm thuê xe của bạn.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
