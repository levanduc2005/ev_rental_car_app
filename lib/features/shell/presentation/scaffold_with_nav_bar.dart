import 'package:flutter/material.dart';
import 'package:rental_car/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// The app shell that hosts the bottom [NavigationBar].
///
/// Driven by go_router's [StatefulNavigationShell]: each tab is a branch with
/// its own navigation stack, so switching tabs preserves each tab's state and
/// the back button behaves per-tab.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.tabMap,
          ),
          NavigationDestination(
            icon: const Icon(Icons.electric_car_outlined),
            selectedIcon: const Icon(Icons.electric_car),
            label: l10n.tabTrip,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    // `initialLocation: true` re-selecting the current tab pops it to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
