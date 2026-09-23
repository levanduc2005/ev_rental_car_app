import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

class KycStatusBadge extends StatelessWidget {
  const KycStatusBadge({required this.status, super.key, this.compact = false});

  final KycStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor, icon) = switch (status) {
      KycStatus.approved => (
        'Đã xác thực',
        AppColors.success.withValues(alpha: 0.12),
        AppColors.success,
        Icons.verified_rounded,
      ),
      KycStatus.pending => (
        'Chờ duyệt',
        AppColors.warning.withValues(alpha: 0.12),
        AppColors.warning,
        Icons.hourglass_top_rounded,
      ),
      KycStatus.rejected => (
        'Bị từ chối',
        AppColors.error.withValues(alpha: 0.12),
        AppColors.error,
        Icons.cancel_rounded,
      ),
      KycStatus.none => (
        'Chưa xác thực',
        AppColors.textMuted.withValues(alpha: 0.15),
        AppColors.textSecondary,
        Icons.help_outline_rounded,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 13 : 16, color: textColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
