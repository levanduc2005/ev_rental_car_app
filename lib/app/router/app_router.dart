import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/active_trip/presentation/active_trip_page.dart';
import 'package:rental_car/features/auth/presentation/pages/login_page.dart';
import 'package:rental_car/features/auth/presentation/pages/otp_page.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/presentation/booking_page.dart';
import 'package:rental_car/features/home/presentation/home_page.dart';
import 'package:rental_car/features/payment/presentation/payment_page.dart';
import 'package:rental_car/features/profile/presentation/profile_page.dart';
import 'package:rental_car/features/shell/presentation/scaffold_with_nav_bar.dart';
import 'package:rental_car/features/vehicles/presentation/map_search_page.dart';
import 'package:rental_car/features/vehicles/presentation/vehicle_detail_page.dart';
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
      final loggedIn = ref.read(authControllerProvider).isAuthenticated;
      final onAuthPage =
          state.matchedLocation == AppRoute.login.path ||
          state.matchedLocation == AppRoute.otp.path;

      if (!loggedIn) {
        if (state.matchedLocation == AppRoute.otp.path &&
            ref.read(authControllerProvider).emailForOtp == null) {
          return AppRoute.login.path;
        }
        return onAuthPage ? null : AppRoute.login.path;
      }
      if (onAuthPage) return AppRoute.home.path;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.otp.path,
        name: AppRoute.otp.name,
        builder: (_, _) => const OtpPage(),
      ),
      GoRoute(
        path: AppRoute.booking.path,
        name: AppRoute.booking.name,
        builder: (_, _) => const BookingPage(),
      ),
      GoRoute(
        path: AppRoute.payment.path,
        name: AppRoute.payment.name,
        builder: (_, _) => const PaymentPage(),
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
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Map & Vehicle Search Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.mapSearch.path,
                name: AppRoute.mapSearch.name,
                builder: (_, _) => const MapSearchPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoute.vehicleDetail.name,
                    builder: (_, state) {
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
                builder: (_, _) => const ActiveTripPage(),
              ),
            ],
          ),
          // Branch 3: Profile Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                builder: (_, _) => const ProfilePage(),
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
