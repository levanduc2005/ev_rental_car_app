import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';

class CheckInKycWarningDialog extends StatelessWidget {
  const CheckInKycWarningDialog({
    super.key,
    this.licenseStatus = 'NOT_SUBMITTED',
    this.rejectReason,
  });

  final String licenseStatus;
  final String? rejectReason;

  static Future<void> show(
    BuildContext context, {
    String licenseStatus = 'NOT_SUBMITTED',
    String? rejectReason,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => CheckInKycWarningDialog(
        licenseStatus: licenseStatus,
        rejectReason: rejectReason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final (badgeText, badgeBg, badgeColor, description) = switch (licenseStatus
        .toUpperCase()) {
      'PENDING' => (
        'ĐANG CHỜ DUYỆT',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
        'Hồ sơ giấy phép lái xe của bạn đang được nhân viên xét duyệt. Vui lòng quay lại nhận xe sau khi hồ sơ được duyệt.',
      ),
      'REJECTED' => (
        'ĐÃ BỊ TỪ CHỐI',
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
        rejectReason != null && rejectReason!.isNotEmpty
            ? 'Lý do từ chối: $rejectReason. Vui lòng nộp lại giấy phép lái xe hợp lệ để nhận xe.'
            : 'Giấy phép lái xe chưa hợp lệ. Vui lòng nộp lại thông tin bằng lái mới.',
      ),
      _ => (
        'CHƯA XÁC THỰC',
        const Color(0xFFF1F5F9),
        const Color(0xFF64748B),
        'Bằng lái xe của bạn chưa được phê duyệt. Vui lòng hoàn tất nộp giấy phép lái xe trước khi nhận xe!',
      ),
    };

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Icon
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  size: 34,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
            const Gap(AppSpacing.md),

            // Title
            const Text(
              'Yêu cầu xác thực Bằng lái xe',
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),

            // Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.md),

            // Description
            Text(
              description,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.lg),

            // Action Buttons
            AppButton(
              label: 'Nộp giấy phép lái xe ngay',
              icon: Icons.upload_file_rounded,
              onPressed: () {
                Navigator.of(context).pop();
                context.pushNamed(AppRoute.kycUpload.name);
              },
            ),
            const Gap(AppSpacing.sm),
            AppButton(
              label: 'Để sau',
              variant: AppButtonVariant.outline,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
