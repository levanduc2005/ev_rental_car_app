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

  void _openKycDetail(
    BuildContext context, {
    KycDocumentEntity? document,
    DocumentType? type,
  }) {
    if (document != null) {
      context.push(AppRoute.kycStatus.path, extra: document);
    } else {
      context.push(AppRoute.kycUpload.path, extra: type);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileState = ref.watch(profileControllerProvider);
    final user = profileState.user;

    final licenseDoc = user?.licenseDocument;
    final cccdDoc = user?.cccdDocument;

    final hasLicense = licenseDoc != null;
    final licenseLast4 = hasLicense && licenseDoc.number.length >= 4
        ? licenseDoc.number.substring(licenseDoc.number.length - 4)
        : (hasLicense ? licenseDoc.number : '');
    final licenseSubtitle = hasLicense
        ? 'Đã xác minh (Số: •••• $licenseLast4)'
        : 'Chưa cập nhật (Bắt buộc để thuê xe)';
    final licenseStatus = licenseDoc?.status ?? KycStatus.none;

    final hasCccd = cccdDoc != null;
    final cccdLast4 = hasCccd && cccdDoc.number.length >= 4
        ? cccdDoc.number.substring(cccdDoc.number.length - 4)
        : (hasCccd ? cccdDoc.number : '');
    final cccdSubtitle = hasCccd
        ? 'Đã xác minh (Số: •••• $cccdLast4)'
        : 'Chưa cập nhật (Xác thực danh tính)';
    final cccdStatus = cccdDoc?.status ?? KycStatus.none;

    final overallStatus = (hasLicense && hasCccd)
        ? KycStatus.approved
        : (hasLicense || hasCccd ? KycStatus.approved : KycStatus.none);

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
                        onTap: () => context.push(AppRoute.kycStatus.path),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: KycStatusBadge(status: overallStatus),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            if (user?.role.toUpperCase() == 'ROLE_STAFF' ||
                user?.role.toUpperCase() == 'ROLE_ADMIN') ...[
              const SectionHeader(title: 'Dành cho Nhân viên trạm'),
              AppCard(
                padding: EdgeInsets.zero,
                child: ProfileMenuItem(
                  icon: Icons.badge_rounded,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Bàn giao xe tại trạm (Staff)',
                  subtitle: 'Quản lý đơn nhận, hợp đồng DocuSeal & bàn giao xe',
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  ),
                  onTap: () => context.push(AppRoute.staffDashboard.path),
                  showDivider: false,
                ),
              ),
              const Gap(AppSpacing.lg),
            ],

            // 2. Nhóm chức năng: Tài khoản & Xác minh
            const SectionHeader(title: 'Tài khoản & Giấy tờ'),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.directions_car_outlined,
                    title: 'Bằng lái xe (GPLX)',
                    subtitle: licenseSubtitle,
                    trailing: KycStatusBadge(
                      status: licenseStatus,
                      compact: true,
                    ),
                    onTap: () => _openKycDetail(
                      context,
                      document: licenseDoc,
                      type: DocumentType.license,
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.credit_card_outlined,
                    iconColor: const Color(0xFF0284C7),
                    title: 'Căn cước công dân (CCCD)',
                    subtitle: cccdSubtitle,
                    trailing: KycStatusBadge(status: cccdStatus, compact: true),
                    onTap: () => _openKycDetail(
                      context,
                      document: cccdDoc,
                      type: DocumentType.cccd,
                    ),
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
