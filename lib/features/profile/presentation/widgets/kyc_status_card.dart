import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';

class KycStatusCard extends StatelessWidget {
  const KycStatusCard({
    required this.status,
    super.key,
    this.document,
    this.rejectReason,
    this.onRetry,
    this.onRentCar,
  });

  final KycStatus status;
  final KycDocumentEntity? document;
  final String? rejectReason;
  final VoidCallback? onRetry;
  final VoidCallback? onRentCar;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      KycStatus.approved => _buildApprovedCard(context),
      KycStatus.pending => _buildPendingCard(context),
      KycStatus.rejected => _buildRejectedCard(context),
      KycStatus.none => _buildNoneCard(context),
    };
  }

  Widget _buildApprovedCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.success,
                  size: 32,
                ),
              ),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đã xác thực thành công',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hồ sơ GPLX hợp lệ. Bạn đã đủ điều kiện thuê xe điện.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (document != null) ...[
            const Divider(height: AppSpacing.lg),
            _buildDetailRow(
              'Loại giấy tờ',
              document!.type == DocumentType.license
                  ? 'Giấy phép lái xe (GPLX)'
                  : 'CCCD gắn chip',
            ),
            const SizedBox(height: AppSpacing.xs),
            _buildDetailRow('Số giấy tờ', document!.number),
            if (document!.licenseClass != null) ...[
              const SizedBox(height: AppSpacing.xs),
              _buildDetailRow('Hạng bằng lái', document!.licenseClass!),
            ],
            if (document!.expiryDate != null) ...[
              const SizedBox(height: AppSpacing.xs),
              _buildDetailRow(
                'Ngày hết hạn',
                '${document!.expiryDate!.day.toString().padLeft(2, '0')}/${document!.expiryDate!.month.toString().padLeft(2, '0')}/${document!.expiryDate!.year}',
              ),
            ],
          ],
          if (onRentCar != null) ...[
            const Gap(AppSpacing.md),
            AppButton(
              label: 'Tìm & Thuê xe ngay',
              icon: Icons.directions_car_filled_rounded,
              onPressed: onRentCar,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.warning,
                  size: 32,
                ),
              ),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hồ sơ đang chờ duyệt',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hệ thống đang tiến hành đối soát OCR và duyệt giấy tờ của bạn.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (document != null) ...[
            const Divider(height: AppSpacing.lg),
            _buildDetailRow('Số giấy tờ đã nộp', document!.number),
          ],
          const Gap(AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.warning),
                Gap.h(AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Thời gian phê duyệt thông thường từ 1 - 5 phút.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedCard(BuildContext context) {
    final effectiveReason =
        rejectReason ??
        document?.rejectReason ??
        'Thông tin giấy tờ không trùng khớp hoặc ảnh chụp không đủ điều kiện xét duyệt.';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 32,
                ),
              ),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hồ sơ bị từ chối',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Rất tiếc, thông tin xác minh của bạn chưa đạt yêu cầu.',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.report_problem_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    Gap.h(AppSpacing.xs),
                    Text(
                      'Lý do từ chối từ hệ thống OCR:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  effectiveReason,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const Gap(AppSpacing.lg),
            AppButton(
              label: 'Chụp lại & Nộp lại giấy tờ',
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoneCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const Gap.h(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chưa xác thực bằng lái',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Xác thực GPLX để mở khóa tính năng thuê xe điện không cần thế chấp.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            const Gap(AppSpacing.md),
            AppButton(
              label: 'Xác thực ngay',
              icon: Icons.arrow_forward_rounded,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.subtitleSmall),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
