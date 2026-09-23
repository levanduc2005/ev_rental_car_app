import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';

/// Thanh top bar của trang Hoàn tất hồ sơ với tiêu đề căn giữa và nút "Bỏ qua" bên phải.
class CompleteProfileTopBar extends StatelessWidget {
  const CompleteProfileTopBar({
    required this.onSkip,
    this.isSkipEnabled = true,
    super.key,
  });

  final VoidCallback onSkip;
  final bool isSkipEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // Cân đối tiêu đề giữa
          const Text('Hoàn tất hồ sơ', style: AppTextStyles.heading3),
          TextButton(
            onPressed: isSkipEnabled ? onSkip : null,
            child: Text(
              'Bỏ qua',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
