import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/features/auth/presentation/widgets/emotion_logo.dart';
import 'package:rental_car/l10n/l10n.dart';

/// Phần tiêu đề trang đăng nhập gồm logo, lời chào và mô tả.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const EmotionLogo(width: 140),
        const SizedBox(height: 28),
        Text(
          context.l10n.loginEmailTitle,
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.loginEmailSubtitle,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
