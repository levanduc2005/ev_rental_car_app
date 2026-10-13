import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_controller.dart';
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

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onDestinationSelected(index, ref),
        destinations: [
          //Thuê xe
          NavigationDestination(
            icon: const Icon(Icons.directions_car_outlined),
            selectedIcon: const Icon(Icons.directions_car),
            label: l10n.tabRent,
          ),
          //Đơn hàng (Đơn đặt trước & Đơn thuê)
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.tabMyTrip,
          ),
          //Thông báo
          NavigationDestination(
            icon: const Icon(Icons.notifications_outlined),
            selectedIcon: const Icon(Icons.notifications),
            label: l10n.tabNotification,
          ),
          //Hỗ trợ
          NavigationDestination(
            icon: const Icon(Icons.headphones_outlined),
            selectedIcon: const Icon(Icons.headphones),
            label: l10n.tabSupport,
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index, WidgetRef ref) {
    if (index == 1) {
      // Khi chọn Tab Đơn thuê (My Trip), tự động làm mới danh sách chuyến đi & đơn thuê
      ref.read(myReservationsControllerProvider.notifier).loadReservations();
    }

    // `initialLocation: true` re-selecting the current tab pops it to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
