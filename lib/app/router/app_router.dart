import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/app/router/app_routes.dart';
import 'package:flutter_template/features/active_trip/presentation/active_trip_page.dart';
import 'package:flutter_template/features/auth/presentation/auth_controller.dart';
import 'package:flutter_template/features/auth/presentation/login_page.dart';
import 'package:flutter_template/features/booking/presentation/booking_page.dart';
import 'package:flutter_template/features/home/presentation/home_page.dart';
import 'package:flutter_template/features/payment/presentation/payment_page.dart';
import 'package:flutter_template/features/profile/presentation/profile_page.dart';
import 'package:flutter_template/features/shell/presentation/scaffold_with_nav_bar.dart';
import 'package:flutter_template/features/vehicles/presentation/map_search_page.dart';
import 'package:flutter_template/features/vehicles/presentation/vehicle_detail_page.dart';
import 'package:flutter_template/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

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
          // Branch 0: Home Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Map & Vehicle Search Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.mapSearch.path,
                name: AppRoute.mapSearch.name,
                builder: (context, state) => const MapSearchPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoute.vehicleDetail.name,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '1';
                      return VehicleDetailPage(vehicleId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Active Trip Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.activeTrip.path,
                name: AppRoute.activeTrip.name,
                builder: (context, state) => const ActiveTripPage(),
              ),
            ],
          ),
          // Branch 3: Profile Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                builder: (context, state) => const ProfilePage(),
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
