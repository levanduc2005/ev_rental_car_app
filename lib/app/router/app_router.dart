import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/active_trip/presentation/active_trip_page.dart';
import 'package:rental_car/features/auth/presentation/auth_controller.dart';
import 'package:rental_car/features/auth/presentation/pages/login_page.dart';
import 'package:rental_car/features/booking/presentation/booking_page.dart';
import 'package:rental_car/features/home/presentation/pages/home_page.dart';
import 'package:rental_car/features/payment/presentation/payment_page.dart';
import 'package:rental_car/features/shell/presentation/scaffold_with_nav_bar.dart';
import 'package:rental_car/l10n/l10n.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Rebuild the redirect logic whenever auth state changes.
  final refresh = _AuthRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = ref.read(authControllerProvider);
      final onLoginPage = state.matchedLocation == AppRoute.login.path;

      if (!loggedIn) return onLoginPage ? null : AppRoute.login.path;
      if (onLoginPage) return AppRoute.home.path;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.booking.path,
        name: AppRoute.booking.name,
        builder: (context, state) => const BookingPage(),
      ),
      GoRoute(
        path: AppRoute.payment.path,
        name: AppRoute.payment.name,
        builder: (context, state) => const PaymentPage(),
      ),
      // The tabbed app shell. Each branch keeps its own navigation stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          // Branch 0: Tab 1 - Thuê xe (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Tab 2 - Đơn thuê(My Trip)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.myTrip.path,
                name: AppRoute.myTrip.name,
                builder: (context, state) => const BookingPage(),
              ),
            ],
          ),
          // Branch 2: Tab 3 - Điều khiển xe (Control)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.control.path,
                name: AppRoute.control.name,
                builder: (context, state) => const ActiveTripPage(),
              ),
            ],
          ),
          // Branch 3: Tab 4 - Thông báo (Notification)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.notification.path,
                name: AppRoute.notification.name,
                builder: (context, state) => Scaffold(
                  appBar: AppBar(title: Text(context.l10n.tabNotification)),
                  body: const Center(
                    child: Icon(Icons.notification_add_outlined, size: 64),
                  ),
                ),
              ),
            ],
          ),
          // Branch 4: Tab 5 - Hỗ trợ (Support)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.support.path,
                name: AppRoute.support.name,
                builder: (context, state) => Scaffold(
                  appBar: AppBar(title: Text(context.l10n.tabSupport)),
                  body: const Center(
                    child: Icon(Icons.support_agent_outlined, size: 64),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(context.l10n.routeNotFound(state.uri.toString())),
      ),
    ),
  );
});

/// Bridges the Riverpod auth state to a [Listenable] that go_router can watch,
/// so navigation redirects re-run when the user logs in or out.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}
