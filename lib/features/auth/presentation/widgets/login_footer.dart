import 'package:flutter/material.dart';

/// Chân trang đăng nhập gồm liên kết đăng ký tài khoản mới và thông tin phiên bản.
class LoginFooter extends StatelessWidget {
  const LoginFooter({this.onCreateAccountTap, super.key});

  final VoidCallback? onCreateAccountTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
              ),
              GestureDetector(
                onTap: onCreateAccountTap ?? () {},
                child: const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'e-Motion v1  •  Clean Mobility Verified',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
