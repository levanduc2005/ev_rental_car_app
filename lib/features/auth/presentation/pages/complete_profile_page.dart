import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/core/widgets/gap.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/widgets/complete_profile/complete_profile_form.dart';
import 'package:rental_car/features/auth/presentation/widgets/complete_profile/complete_profile_header.dart';
import 'package:rental_car/features/auth/presentation/widgets/complete_profile/complete_profile_top_bar.dart';

/// Màn hình hoàn tất hồ sơ (Bước 3 sau khi xác thực OTP thành công).
/// Cho phép người dùng nhập Họ & Tên hoặc Bỏ qua để vào HomePage.
class CompleteProfilePage extends ConsumerWidget {
  const CompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CompleteProfileTopBar(
              onSkip: () =>
                  ref.read(authControllerProvider.notifier).skipProfileSetup(),
              isSkipEnabled: !isLoading,
            ),
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CompleteProfileHeader(),
                    Gap(36),
                    CompleteProfileForm(),
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
