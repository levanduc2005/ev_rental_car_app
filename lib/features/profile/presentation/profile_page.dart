import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/theme/app_spacing.dart';
import 'package:rental_car/core/widgets/widgets.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/l10n/l10n.dart';

/// The "Profile" tab.
///
/// Shows placeholder account info and a logout action, and demonstrates
/// several kit widgets (`AppAvatar`, `AppCard`, `SectionHeader`, the confirm
/// dialog and the snackbar helper).
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
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileAccountSection)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Row(
              children: [
                const AppAvatar(name: 'Demo User', radius: 28),
                const Gap.h(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.guestName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        l10n.guestEmail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.lg),
          SectionHeader(title: l10n.profileAccountSection),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.badge_outlined, color: Colors.blue),
                  title: const Text('Xác minh Bằng lái xe (GPLX B2)'),
                  subtitle: const Text('Trạng thái: Chưa cập nhật'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.showSnackBar(
                      'Cập nhật GPLX B2 trực tiếp tại Profile',
                    );
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(l10n.profileNotifications),
                  trailing: Switch(value: true, onChanged: (_) {}),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.profileAbout),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.showSnackBar(l10n.comingSoon),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.xl),
          AppButton(
            label: l10n.logout,
            onPressed: () => _logout(context, ref),
            variant: AppButtonVariant.outline,
            icon: Icons.logout,
            expanded: true,
          ),
        ],
      ),
    );
  }
}
