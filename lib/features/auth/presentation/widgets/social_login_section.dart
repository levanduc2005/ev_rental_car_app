import 'package:flutter/material.dart';

/// Khối đăng nhập qua mạng xã hội (Apple, Google) kèm đường phân cách.
class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({
    this.onAppleSignIn,
    this.onGoogleSignIn,
    super.key,
  });

  final VoidCallback? onAppleSignIn;
  final VoidCallback? onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                'or continue with',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
          ],
        ),
        const SizedBox(height: 22),
        SocialButton(
          onPressed: onAppleSignIn ?? () {},
          icon: const Icon(Icons.apple, color: Colors.black, size: 22),
          label: 'Continue with Apple',
        ),
        const SizedBox(height: 12),
        SocialButton(
          onPressed: onGoogleSignIn ?? () {},
          icon: const GoogleIcon(),
          label: 'Continue with Google',
        ),
      ],
    );
  }
}

/// Nút đăng nhập bên thứ ba với viền bo góc và hiệu ứng click mềm.
class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Biểu tượng Google chữ G đặc trưng.
class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w900,
          color: Color(0xFFEA4335),
        ),
      ),
    );
  }
}
