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

class KycStatusScreen extends ConsumerStatefulWidget {
  const KycStatusScreen({this.document, this.initialType, super.key});

  final KycDocumentEntity? document;
  final DocumentType? initialType;

  @override
  ConsumerState<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends ConsumerState<KycStatusScreen> {
  late DocumentType _selectedTab;

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      _selectedTab = widget.document!.type;
    } else if (widget.initialType != null) {
      _selectedTab = widget.initialType!;
    } else {
      _selectedTab = DocumentType.license;
    }
  }

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
          'Bạn có chắc chắn muốn gỡ giấy tờ này? Sau khi gỡ, bạn sẽ cần xác thực lại nếu muốn tiếp tục thuê xe.',
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
      await ref.read(profileControllerProvider.notifier).refreshProfile();
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
      await ref.read(profileControllerProvider.notifier).refreshProfile();
      if (!context.mounted) return;
      context.pushReplacement(AppRoute.kycUpload.path, extra: doc.type);
    } else {
      final error =
          ref.read(kycControllerProvider).errorMessage ?? 'Thao tác thất bại.';
      context.showSnackBar(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider).user;
    final kycState = ref.watch(kycControllerProvider);

    final licenseDoc =
        profile?.licenseDocument ??
        (kycState.uploadedDocument?.type == DocumentType.license
            ? kycState.uploadedDocument
            : null);

    final cccdDoc =
        profile?.cccdDocument ??
        (kycState.uploadedDocument?.type == DocumentType.cccd
            ? kycState.uploadedDocument
            : null);

    final targetDoc = _selectedTab == DocumentType.license
        ? licenseDoc
        : cccdDoc;
    final otherDoc = _selectedTab == DocumentType.license
        ? cccdDoc
        : licenseDoc;
    final otherType = _selectedTab == DocumentType.license
        ? DocumentType.cccd
        : DocumentType.license;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Bộ chuyển đổi loại giấy tờ: GPLX / CCCD
              SegmentedButton<DocumentType>(
                segments: [
                  ButtonSegment(
                    value: DocumentType.license,
                    icon: Icon(
                      licenseDoc != null
                          ? Icons.check_circle_rounded
                          : Icons.directions_car_outlined,
                      color: licenseDoc != null ? AppColors.success : null,
                      size: 18,
                    ),
                    label: Text(
                      licenseDoc != null ? 'GPLX (Đã có)' : 'GPLX (Chưa có)',
                    ),
                  ),
                  ButtonSegment(
                    value: DocumentType.cccd,
                    icon: Icon(
                      cccdDoc != null
                          ? Icons.check_circle_rounded
                          : Icons.credit_card_outlined,
                      color: cccdDoc != null ? AppColors.success : null,
                      size: 18,
                    ),
                    label: Text(
                      cccdDoc != null ? 'CCCD (Đã có)' : 'CCCD (Chưa có)',
                    ),
                  ),
                ],
                selected: {_selectedTab},
                onSelectionChanged: (set) {
                  setState(() {
                    _selectedTab = set.first;
                  });
                },
              ),
              const Gap(AppSpacing.md),

              if (targetDoc != null) ...[
                // Banner trạng thái
                _buildStatusBanner(targetDoc.status),
                const Gap(AppSpacing.md),

                // Hình ảnh giấy tờ kèm preview zoom
                _buildImageCard(context, targetDoc),
                const Gap(AppSpacing.md),

                // Thông tin chi tiết giấy tờ
                _buildDetailsCard(context, targetDoc, profile?.email),
                const Gap(AppSpacing.lg),

                // Các nút hành động (Chụp lại / Gỡ giấy tờ)
                if (isActionBusy)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else ...[
                  AppButton(
                    label: 'Chụp lại / Cập nhật mới',
                    icon: Icons.camera_alt_outlined,
                    onPressed: () => _handleReupload(context, ref, targetDoc),
                  ),
                  const Gap(AppSpacing.sm),
                  AppButton(
                    label: 'Gỡ giấy tờ này',
                    icon: Icons.delete_outline_rounded,
                    variant: AppButtonVariant.outline,
                    onPressed: () =>
                        _handleDeleteDocument(context, ref, targetDoc),
                  ),
                ],

                // Gợi ý tải lên loại giấy tờ còn lại nếu chưa có
                if (otherDoc == null) ...[
                  const Gap(AppSpacing.lg),
                  _buildRemainingDocPrompt(context, otherType),
                ],
              ] else ...[
                // Hiển thị khung tải lên khi chưa có loại giấy tờ này
                _buildEmptyStateForType(context, _selectedTab),
              ],
              const Gap(AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(KycStatus status) {
    final isApproved = status == KycStatus.approved;
    final isPending = status == KycStatus.pending;
    final isRejected = status == KycStatus.rejected;

    final color = isApproved
        ? AppColors.success
        : isPending
        ? AppColors.warning
        : isRejected
        ? AppColors.error
        : AppColors.textMuted;

    final title = isApproved
        ? 'Đã xác thực hợp lệ'
        : isPending
        ? 'Đang chờ xét duyệt'
        : isRejected
        ? 'Xác thực không thành công'
        : 'Chưa xác thực';

    final message = isApproved
        ? 'Giấy tờ của bạn đã được hệ thống OCR xác thực thành công và đủ điều kiện thuê xe.'
        : isPending
        ? 'Giấy tờ đang trong hàng đợi xử lý. Vui lòng quay lại sau ít phút.'
        : 'Ảnh chụp chưa đạt yêu cầu hoặc thông tin không trùng khớp. Vui lòng chụp lại.';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              isApproved
                  ? Icons.check_circle_rounded
                  : isPending
                  ? Icons.hourglass_top_rounded
                  : Icons.error_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
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
    );
  }

  Widget _buildImageCard(BuildContext context, KycDocumentEntity targetDoc) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ảnh chụp giấy tờ', style: AppTextStyles.title),
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
                ? () => _showFullScreenImage(context, targetDoc.imgUrl)
                : null,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
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
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
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
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    KycDocumentEntity targetDoc,
    String? profileEmail,
  ) {
    final isLicense = targetDoc.type == DocumentType.license;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin chi tiết hồ sơ', style: AppTextStyles.title),
          const Divider(height: AppSpacing.md),

          // Loại giấy tờ
          _buildDetailItem(
            icon: Icons.assignment_ind_outlined,
            label: 'Loại giấy tờ',
            value: isLicense
                ? 'Giấy phép lái xe (GPLX)'
                : 'Thẻ Căn cước công dân (CCCD)',
          ),
          const Divider(height: AppSpacing.md),

          // Hạng bằng lái (nếu có)
          if (isLicense && targetDoc.licenseClass != null) ...[
            _buildDetailItem(
              icon: Icons.card_membership_outlined,
              label: 'Hạng bằng lái',
              value: 'Hạng ${targetDoc.licenseClass}',
            ),
            const Divider(height: AppSpacing.md),
          ],

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
                    const Text('Số giấy tờ', style: AppTextStyles.caption),
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
                    context.showSnackBar('Đã sao chép số: ${targetDoc.number}');
                  }
                },
              ),
            ],
          ),
          const Divider(height: AppSpacing.md),

          // Ngày hết hạn (nếu có)
          if (targetDoc.expiryDate != null) ...[
            _buildDetailItem(
              icon: Icons.calendar_today_outlined,
              label: 'Ngày hết hạn',
              value:
                  '${targetDoc.expiryDate!.day.toString().padLeft(2, '0')}/${targetDoc.expiryDate!.month.toString().padLeft(2, '0')}/${targetDoc.expiryDate!.year}',
            ),
            const Divider(height: AppSpacing.md),
          ],

          // Email đăng ký
          _buildDetailItem(
            icon: Icons.email_outlined,
            label: 'Email đăng ký',
            value: targetDoc.email ?? profileEmail ?? 'Chưa cập nhật',
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
    );
  }

  Widget _buildRemainingDocPrompt(
    BuildContext context,
    DocumentType otherType,
  ) {
    final isLicense = otherType == DocumentType.license;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.add_task_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const Gap.h(AppSpacing.sm),
              Expanded(
                child: Text(
                  isLicense
                      ? 'Bạn chưa tải lên Bằng lái xe (GPLX)'
                      : 'Bạn chưa tải lên Căn cước công dân (CCCD)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isLicense
                ? 'Bằng lái xe hợp lệ là bắt buộc để bạn có thể nhận và lái xe điện.'
                : 'Bổ sung CCCD/CMND để hoàn tất 100% hồ sơ định danh người thuê xe.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const Gap(AppSpacing.md),
          AppButton(
            label: isLicense ? 'Tải lên GPLX ngay' : 'Tải lên CCCD ngay',
            icon: Icons.upload_file_rounded,
            onPressed: () =>
                context.push(AppRoute.kycUpload.path, extra: otherType),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateForType(BuildContext context, DocumentType type) {
    final isLicense = type == DocumentType.license;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xl,
          horizontal: AppSpacing.md,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLicense
                    ? Icons.directions_car_outlined
                    : Icons.credit_card_outlined,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const Gap(AppSpacing.md),
            Text(
              isLicense
                  ? 'Chưa có Bằng lái xe (GPLX)'
                  : 'Chưa có Căn cước công dân (CCCD)',
              style: AppTextStyles.heading3,
            ),
            const Gap(AppSpacing.xs),
            Text(
              isLicense
                  ? 'Bạn chưa tải lên GPLX. Cần có GPLX hợp lệ để đủ điều kiện thuê và lái xe điện.'
                  : 'Bạn chưa tải lên CCCD. Tải lên để hoàn tất hồ sơ xác thực danh tính cá nhân.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(AppSpacing.lg),
            AppButton(
              label: isLicense ? 'Tải lên GPLX ngay' : 'Tải lên CCCD ngay',
              icon: Icons.upload_file_rounded,
              onPressed: () =>
                  context.push(AppRoute.kycUpload.path, extra: type),
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
