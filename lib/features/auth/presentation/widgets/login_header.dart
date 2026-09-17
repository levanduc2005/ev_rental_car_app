import 'package:flutter/material.dart';
import 'package:rental_car/features/auth/presentation/widgets/emotion_logo.dart';

/// Phần tiêu đề trang đăng nhập gồm logo, lời chào và mô tả.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          EmotionLogo(),
          SizedBox(height: 24),
          Text(
            'Welcome back',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sign in to continue your journey with e-Motion',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
