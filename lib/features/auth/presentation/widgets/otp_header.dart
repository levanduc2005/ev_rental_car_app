import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/theme.dart';
import 'package:rental_car/l10n/l10n.dart';

/// Phần header của màn hình OTP: Icon phong bì, Tiêu đề, Email nhận OTP và nút Đổi email.
class OtpHeader extends StatelessWidget {
  const OtpHeader({
    required this.email,
    required this.onChangeEmail,
    super.key,
  });

  final String email;
  final VoidCallback onChangeEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Biểu tượng phong bì thư điện tử
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                size: 32,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Tiêu đề: "Xác nhận mã OTP"
        Text(
          context.l10n.otpVerificationTitle,
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),

        // Mô tả: "Nhập mã OTP được gửi tới email"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.subtitle,
              children: [
                TextSpan(
                  text: context.l10n
                      .otpSentToMessage('')
                      .replaceAll(' ', ' ')
                      .trim(),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: email,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onChangeEmail,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit_outlined,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.changeEmail,
                  style: AppTextStyles.subtitleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
