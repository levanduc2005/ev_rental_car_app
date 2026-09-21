import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/l10n/l10n.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border, width: 1.2),
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
          borderRadius: AppRadius.lgAll,
          onTap: onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _GoogleIcon(),
              const SizedBox(width: 10),
              Text(
                context.l10n.continueWithGoogle,
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('public/google_logo.svg', width: 20, height: 20);
  }
}
