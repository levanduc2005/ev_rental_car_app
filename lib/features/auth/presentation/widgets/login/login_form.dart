import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/core/utils/validators.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/widgets/login/google_sign_in_button.dart';
import 'package:rental_car/l10n/l10n.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();

    final success = await ref
        .read(authControllerProvider.notifier)
        .sendOtp(email);

    if (!mounted) return;

    if (success) {
      context.pushNamed(AppRoute.otp.name);
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleContinue(),
              style: AppTextStyles.inputText,
              decoration: const InputDecoration(
                hintText: 'name@gmail.com',
                hintStyle: AppTextStyles.hint,
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              validator: (value) => AppValidators.email(
                value,
                requiredMessage: context.l10n.emailRequired,
                invalidMessage: context.l10n.emailInvalid,
              ),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 52,

            child: ElevatedButton(
              onPressed: isLoading ? null : _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.lgAll,
                ),
                disabledBackgroundColor: AppColors.primary.withValues(
                  alpha: 0.4,
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      context.l10n.continueButton,
                      style: AppTextStyles.button,
                    ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(
                child: Divider(color: AppColors.border, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  context.l10n.orDivider,
                  style: AppTextStyles.caption,
                ),
              ),
              const Expanded(
                child: Divider(color: AppColors.border, thickness: 1),
              ),
            ],
          ),
          const SizedBox(height: 24),

          GoogleSignInButton(
            onPressed: isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();

                    if (!context.mounted) return;

                    if (!success) {
                      final error = ref
                          .read(authControllerProvider)
                          .errorMessage;
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
                  },
          ),
        ],
      ),
    );
  }
}
