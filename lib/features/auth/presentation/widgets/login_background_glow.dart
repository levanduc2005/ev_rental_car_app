import 'package:flutter/material.dart';

/// Hiệu ứng ánh sáng xanh mờ trang trí dạng RadialGradient phía trên đầu trang đăng nhập.
class LoginBackgroundGlow extends StatelessWidget {
  const LoginBackgroundGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -60,
      left: 0,
      right: 0,
      height: 280,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 0.9,
            colors: [
              const Color(0xFFD6E8FF).withValues(alpha: 0.7),
              const Color(0xFFF8FAFC).withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}
