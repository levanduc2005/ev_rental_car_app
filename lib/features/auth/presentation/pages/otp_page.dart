import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/widgets/auth_top_bar.dart';
import 'package:rental_car/features/auth/presentation/widgets/otp_verification_form.dart';

/// Trang xác thực mã OTP 6 số độc lập theo chuẩn Route-driven.
class OtpPage extends ConsumerWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(
      authControllerProvider.select((s) => s.emailForOtp ?? ''),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(
              onClose: () {
                ref.read(authControllerProvider.notifier).resetOtp();
                context.goNamed(AppRoute.login.name);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: OtpVerificationForm(email: email),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
