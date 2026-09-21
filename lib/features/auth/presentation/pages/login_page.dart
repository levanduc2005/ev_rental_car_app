import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/features/auth/presentation/widgets/common/auth_top_bar.dart';
import 'package:rental_car/features/auth/presentation/widgets/login/login_form.dart';
import 'package:rental_car/features/auth/presentation/widgets/login/login_header.dart';

/// Màn hình đăng nhập chính (Bước 1: Nhập Email).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(
              onClose: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(AppRoute.home.name);
                }
              },
            ),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    LoginHeader(),
                    SizedBox(height: 32),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
