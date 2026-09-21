import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/widgets/otp/otp_header.dart';
import 'package:rental_car/features/auth/presentation/widgets/otp/otp_input_field.dart';
import 'package:rental_car/features/auth/presentation/widgets/otp/otp_resend_button.dart';

/// Form xử lý toàn bộ luồng xác nhận mã OTP 6 số.
class OtpVerificationForm extends ConsumerStatefulWidget {
  const OtpVerificationForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<OtpVerificationForm> createState() =>
      _OtpVerificationFormState();
}

class _OtpVerificationFormState extends ConsumerState<OtpVerificationForm> {
  int _resetCount = 0;

  Future<void> _handleVerify(String otp) async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(email: widget.email, otp: otp);

    if (!mounted) return;

    if (!success) {
      setState(() {
        _resetCount++;
      });

      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleResendOtp() async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .sendOtp(widget.email);

    if (!mounted) return;

    if (success) {
      setState(() {
        _resetCount++;
      });
    } else {
      final error = ref.read(authControllerProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.isLoading),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpHeader(
          email: widget.email,
          onChangeEmail: () {
            ref.read(authControllerProvider.notifier).resetOtp();
            context.goNamed(AppRoute.login.name);
          },
        ),

        const SizedBox(height: 32),
        OtpInputField(
          key: ValueKey(_resetCount),
          enabled: !isLoading,
          onCompleted: _handleVerify,
        ),

        const SizedBox(height: 28),
        OtpResendButton(isLoading: isLoading, onResend: _handleResendOtp),
      ],
    );
  }
}
