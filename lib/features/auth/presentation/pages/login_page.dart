import 'package:flutter/material.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_background_glow.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_footer.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_form.dart';
import 'package:rental_car/features/auth/presentation/widgets/login_header.dart';
import 'package:rental_car/features/auth/presentation/widgets/social_login_section.dart';

/// Màn hình đăng nhập của ứng dụng e-Motion.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Ánh sáng xanh mờ trang trí phía trên đầu trang
          const LoginBackgroundGlow(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Logo e-Motion & Tiêu đề
                    const LoginHeader(),
                    const SizedBox(height: 32),

                    // Form nhập thông tin & Nút Sign In
                    LoginForm(
                      onForgotPasswordTap: () {
                        // TODO: Điều hướng sang trang Forgot Password
                      },
                    ),
                    const SizedBox(height: 28),

                    // Đăng nhập liên kết mạng xã hội (Apple, Google)
                    SocialLoginSection(
                      onAppleSignIn: () {
                        // TODO: Apple Sign In
                      },
                      onGoogleSignIn: () {
                        // TODO: Google Sign In
                      },
                    ),
                    const SizedBox(height: 36),

                    // Liên kết đăng ký & Footer phiên bản
                    LoginFooter(
                      onCreateAccountTap: () {
                        // TODO: Điều hướng sang trang Register
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
