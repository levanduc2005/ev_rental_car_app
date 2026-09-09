import 'package:flutter/material.dart';
import 'package:flutter_template/app/router/app_routes.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';
import 'package:flutter_template/core/widgets/widgets.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// The "Home" tab: a small dashboard linking to the example screens.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Gap(AppSpacing.sm),
          Icon(Icons.flutter_dash, size: 64, color: theme.colorScheme.primary),
          const Gap(AppSpacing.md),
          Text(
            l10n.homeWelcome,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const Gap(AppSpacing.xs),
          Text(
            l10n.homeSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(AppSpacing.xl),
          _NavCard(
            icon: Icons.map_outlined,
            title: 'Tìm xe & Trạm sạc',
            subtitle: 'Bản đồ trực quan hiển thị xe điện gần bạn',
            onTap: () => context.goNamed(AppRoute.mapSearch.name),
          ),
          const Gap(AppSpacing.md),
          _NavCard(
            icon: Icons.electric_car_outlined,
            title: 'Chuyến đi hiện tại',
            subtitle: 'Đồng hồ đếm thời gian & Mở/Khóa cửa xe từ xa',
            onTap: () => context.goNamed(AppRoute.activeTrip.name),
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const Gap.h(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
