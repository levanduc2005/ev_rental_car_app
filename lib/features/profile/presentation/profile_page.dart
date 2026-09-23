import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/theme/app_text_styles.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/features/profile/presentation/widgets/kyc_status_badge.dart';
import 'package:rental_car/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:rental_car/l10n/l10n.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmMessage,
      confirmLabel: l10n.logout,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (!confirmed) return;
    await ref.read(authControllerProvider.notifier).logout();
  }

  void _onKycItemTap(BuildContext context, KycDocumentEntity? document) {
    if (document != null) {
      context.push(AppRoute.kycStatus.path, extra: document);
    } else {
      context.push(AppRoute.kycUpload.path);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;

    final doc =
        user?.licenseDocument ??
        (user?.documents.isNotEmpty == true ? user!.documents.first : null);
    final hasDoc = doc != null;
    final last4 = hasDoc && doc.number.length >= 4
        ? doc.number.substring(doc.number.length - 4)
        : (hasDoc ? doc.number : '');
    final kycSubtitle = hasDoc
        ? 'Đã xác minh (Số: •••• $last4)'
        : 'Chưa cập nhật';
    final kycStatus = hasDoc ? KycStatus.approved : KycStatus.none;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.profileAccountSection),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(profileControllerProvider.notifier).refreshProfile(),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // 1. Thẻ thông tin cá nhân Header
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          AppAvatar(
                            name: user?.fullName ?? user?.email ?? 'EV User',
                            radius: 32,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap.h(AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName?.isNotEmpty == true
                                  ? user!.fullName!
                                  : 'Khách hàng EV',
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? l10n.guestEmail,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (user?.phone?.isNotEmpty == true) ...[
                              const SizedBox(height: 2),
                              Text(
                                user!.phone!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.lg),

                  // Thanh điểm thưởng & Huy hiệu trạng thái bằng lái
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Huy hiệu điểm thưởng
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm + 2,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              size: 16,
                              color: Color(0xFFD97706),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '⭐ ${user?.point ?? 0} điểm',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Huy hiệu trạng thái KYC
                      InkWell(
                        onTap: () => _onKycItemTap(context, doc),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: KycStatusBadge(status: kycStatus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // 2. Nhóm chức năng: Tài khoản & Xác minh
            const SectionHeader(title: 'Tài khoản & Giấy tờ'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.badge_outlined,
                    title: 'Xác minh Bằng lái xe (GPLX) / CCCD',
                    subtitle: kycSubtitle,
                    trailing: KycStatusBadge(status: kycStatus, compact: true),
                    onTap: () => _onKycItemTap(context, doc),
                  ),
                  ProfileMenuItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.info,
                    title: 'Chỉnh sửa thông tin cá nhân',
                    subtitle: 'Cập nhật họ tên, số điện thoại',
                    onTap: () => context.push(AppRoute.editProfile.path),
                  ),
                  ProfileMenuItem(
                    icon: Icons.receipt_long_outlined,
                    iconColor: AppColors.accent,
                    title: 'Lịch sử thuê xe',
                    subtitle: 'Xem lại các chuyến đi đã hoàn thành',
                    onTap: () => context.push(AppRoute.rentalHistory.path),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            // 3. Nhóm chức năng: Cài đặt & Hỗ trợ
            const SectionHeader(title: 'Cài đặt & Ứng dụng'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    title: l10n.profileNotifications,
                    trailing: Switch.adaptive(
                      value: true,
                      activeTrackColor: AppColors.primary,
                      onChanged: (_) {},
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.headphones_outlined,
                    iconColor: const Color(0xFFEC4899),
                    title: 'Tổng đài hỗ trợ 24/7',
                    subtitle: '1900 6868 (Miễn phí)',
                    onTap: () => context.push(AppRoute.support.path),
                  ),
                  ProfileMenuItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.textSecondary,
                    title: l10n.profileAbout,
                    subtitle: 'Phiên bản 1.0.0 (EV Edition)',
                    onTap: () => context.showSnackBar(l10n.comingSoon),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.xl),

            // 4. Nút đăng xuất
            AppButton(
              label: l10n.logout,
              onPressed: () => _logout(context, ref),
              variant: AppButtonVariant.outline,
              icon: Icons.logout_rounded,
              expanded: true,
            ),
            const Gap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
