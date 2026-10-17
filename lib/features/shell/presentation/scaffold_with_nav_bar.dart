import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/core/theme/app_colors.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';
import 'package:rental_car/l10n/l10n.dart';

/// The app shell that hosts the bottom [NavigationBar].
///
/// Driven by go_router's [StatefulNavigationShell]: each tab is a branch with
/// its own navigation stack, so switching tabs preserves each tab's state and
/// the back button behaves per-tab.
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF334155) : AppColors.border,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          height: 64,
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => _onDestinationSelected(index, ref),
          destinations: [
            // Thuê xe
            NavigationDestination(
              icon: const Icon(Icons.directions_car_outlined),
              selectedIcon: const Icon(Icons.directions_car_rounded),
              label: l10n.tabRent,
            ),
            // Đơn hàng (Đơn đặt trước & Đơn thuê)
            NavigationDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: l10n.tabMyTrip,
            ),
            // Thông báo
            NavigationDestination(
              icon: const Icon(Icons.notifications_none_rounded),
              selectedIcon: const Icon(Icons.notifications_rounded),
              label: l10n.tabNotification,
            ),
            // Hỗ trợ & Cứu hộ SOS
            NavigationDestination(
              icon: const Icon(Icons.headset_mic_outlined),
              selectedIcon: const Icon(Icons.headset_mic_rounded),
              label: l10n.tabSupport,
            ),
          ],
        ),
      ),
    );
  }

  void _onDestinationSelected(int index, WidgetRef ref) {
    if (index == 1 || index == 3) {
      // Khi chọn Tab Đơn thuê hoặc Hỗ trợ, tự động làm mới danh sách đơn thuê
      ref.read(rentalHistoryControllerProvider.notifier).refresh();
      if (index == 1) {
        ref.read(myReservationsControllerProvider.notifier).loadReservations();
      }
    }

    // `initialLocation: true` re-selecting the current tab pops it to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
