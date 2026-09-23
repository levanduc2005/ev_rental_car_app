import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/presentation/controllers/kyc_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class KycStatusScreen extends ConsumerWidget {
  const KycStatusScreen({this.document, super.key});

  final KycDocumentEntity? document;

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: const Text(
                      'Không thể tải ảnh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: IconButton(
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDeleteDocument(
    BuildContext context,
    WidgetRef ref,
    KycDocumentEntity doc,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Gỡ giấy tờ xác thực?',
      message:
          'Bạn có chắc chắn muốn gỡ giấy tờ này? Sau khi gỡ, bạn sẽ không thể thực hiện đặt thuê xe cho đến khi xác thực lại.',
      confirmLabel: 'Gỡ giấy tờ',
      cancelLabel: 'Giữ lại',
      isDestructive: true,
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(kycControllerProvider.notifier)
        .deleteDocument(doc.id);

    if (!context.mounted) return;

    if (success) {
      context.showSnackBar('Đã gỡ giấy tờ thành công.');
      context.pushReplacement(AppRoute.kycUpload.path);
    } else {
      final error =
          ref.read(kycControllerProvider).errorMessage ??
          'Gỡ giấy tờ thất bại.';
      context.showSnackBar(error);
    }
  }

  Future<void> _handleReupload(
    BuildContext context,
    WidgetRef ref,
    KycDocumentEntity doc,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Cập nhật lại giấy tờ?',
      message:
          'Backend không cho ghi đè nên hệ thống sẽ tự động gỡ giấy tờ cũ trước, sau đó mở màn hình để bạn chụp ảnh mới. Bạn có muốn tiếp tục?',
      confirmLabel: 'Tiếp tục & Chụp mới',
      cancelLabel: 'Hủy',
    );

    if (!confirmed || !context.mounted) return;

    final success = await ref
        .read(kycControllerProvider.notifier)
        .deleteDocument(doc.id);

    if (!context.mounted) return;

    if (success) {
      context.showSnackBar('Đã gỡ giấy tờ cũ. Hãy tải lên ảnh mới.');
      context.pushReplacement(AppRoute.kycUpload.path);
    } else {
      final error =
          ref.read(kycControllerProvider).errorMessage ?? 'Thao tác thất bại.';
      context.showSnackBar(error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider).user;
    final kycState = ref.watch(kycControllerProvider);

    // Xác định giấy tờ hiển thị
    final targetDoc =
        document ??
        kycState.uploadedDocument ??
        profile?.licenseDocument ??
        (profile?.documents.isNotEmpty == true
            ? profile!.documents.first
            : null);

    final isActionBusy = kycState.stepStatus == KycStepStatus.uploadingImage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Thông tin xác thực (KYC)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: targetDoc == null
            ? _buildEmptyState(context)
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Banner trạng thái: Đã xác thực hợp lệ
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const Gap.h(AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Đã xác thực hợp lệ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Giấy tờ của bạn đã được hệ thống OCR xác thực thành công và đủ điều kiện thuê xe.',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(AppSpacing.md),

                    // 2. Hình ảnh giấy tờ (imgUrl) kèm preview zoom
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ảnh chụp giấy tờ',
                                style: AppTextStyles.title,
                              ),
                              Text(
                                'Chạm vào ảnh để phóng to',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.md),
                          InkWell(
                            onTap: targetDoc.imgUrl.isNotEmpty
                                ? () => _showFullScreenImage(
                                    context,
                                    targetDoc.imgUrl,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 10,
                                    child: targetDoc.imgUrl.isNotEmpty
                                        ? Image.network(
                                            targetDoc.imgUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                _buildImageErrorPlaceholder(),
                                          )
                                        : _buildImageErrorPlaceholder(),
                                  ),
                                ),
                                Positioned(
                                  bottom: AppSpacing.xs,
                                  right: AppSpacing.xs,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.65,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.sm,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.zoom_in_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Xem to',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(AppSpacing.md),

                    // 3. Khối thông tin chi tiết (100% dữ liệu backend)
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin chi tiết hồ sơ',
                            style: AppTextStyles.title,
                          ),
                          const Divider(height: AppSpacing.md),

                          // Loại giấy tờ
                          _buildDetailItem(
                            icon: Icons.assignment_ind_outlined,
                            label: 'Loại giấy tờ',
                            value: targetDoc.type == DocumentType.license
                                ? 'Giấy phép lái xe (GPLX)'
                                : 'Thẻ Căn cước công dân (CCCD)',
                          ),
                          const Divider(height: AppSpacing.md),

                          // Số giấy tờ + nút sao chép
                          Row(
                            children: [
                              const Icon(
                                Icons.credit_card_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const Gap.h(AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Số giấy tờ',
                                      style: AppTextStyles.caption,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      targetDoc.number,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                tooltip: 'Sao chép số giấy tờ',
                                onPressed: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: targetDoc.number),
                                  );
                                  if (context.mounted) {
                                    context.showSnackBar(
                                      'Đã sao chép số: ${targetDoc.number}',
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const Divider(height: AppSpacing.md),

                          // Email đăng ký
                          _buildDetailItem(
                            icon: Icons.email_outlined,
                            label: 'Email đăng ký',
                            value:
                                targetDoc.email ??
                                profile?.email ??
                                'Chưa cập nhật',
                          ),
                          const Divider(height: AppSpacing.md),

                          // Mã định danh hồ sơ
                          _buildDetailItem(
                            icon: Icons.tag_rounded,
                            label: 'Mã định danh hồ sơ (ID)',
                            value: '#${targetDoc.id}',
                          ),
                        ],
                      ),
                    ),
                    const Gap(AppSpacing.lg),

                    // 4. Khu vực các nút hành động (Actions)
                    if (isActionBusy)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      // Nút Chụp lại / Cập nhật mới (Re-upload)
                      AppButton(
                        label: 'Chụp lại / Cập nhật mới',
                        icon: Icons.camera_alt_outlined,
                        onPressed: () =>
                            _handleReupload(context, ref, targetDoc),
                      ),
                      const Gap(AppSpacing.sm),

                      // Nút Gỡ giấy tờ này (Delete Document)
                      AppButton(
                        label: 'Gỡ giấy tờ này',
                        icon: Icons.delete_outline_rounded,
                        variant: AppButtonVariant.outline,
                        onPressed: () =>
                            _handleDeleteDocument(context, ref, targetDoc),
                      ),
                    ],
                    const Gap(AppSpacing.lg),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.badge_outlined,
              size: 56,
              color: AppColors.textMuted,
            ),
            const Gap(AppSpacing.md),
            const Text('Chưa có hồ sơ giấy tờ', style: AppTextStyles.title),
            const Gap(AppSpacing.xs),
            Text(
              'Bạn chưa tải lên GPLX hoặc CCCD. Hãy nộp giấy tờ để đủ điều kiện thuê xe.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(AppSpacing.lg),
            AppButton(
              label: 'Nộp giấy tờ ngay',
              icon: Icons.upload_file_rounded,
              onPressed: () => context.pushReplacement(AppRoute.kycUpload.path),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: AppColors.border,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.textMuted,
            ),
            SizedBox(height: 4),
            Text(
              'Không thể hiển thị ảnh',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const Gap.h(AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
