import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/active_trip/presentation/active_trip_page.dart';
import 'package:rental_car/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:rental_car/features/auth/presentation/pages/login_page.dart';
import 'package:rental_car/features/auth/presentation/pages/otp_page.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_confirmation_page.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_payment_page.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_success_page.dart';
import 'package:rental_car/features/booking/presentation/pages/my_reservations_page.dart';
import 'package:rental_car/features/booking/presentation/pages/reservation_detail_page.dart';
import 'package:rental_car/features/home/presentation/pages/home_page.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:rental_car/features/profile/presentation/pages/kyc_status_screen.dart';
import 'package:rental_car/features/profile/presentation/pages/kyc_upload_screen.dart';
import 'package:rental_car/features/profile/presentation/pages/rental_history_screen.dart';
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
      final authState = ref.read(authControllerProvider);
      final loggedIn = authState.isAuthenticated;
      final onAuthPage =
          state.matchedLocation == AppRoute.login.path ||
          state.matchedLocation == AppRoute.otp.path ||
          state.matchedLocation == AppRoute.completeProfile.path;

      if (!loggedIn) {
        if (state.matchedLocation == AppRoute.otp.path &&
            authState.emailForOtp == null) {
          return AppRoute.login.path;
        }
        return onAuthPage ? null : AppRoute.login.path;
      }

      // Đã đăng nhập: Nếu user chưa có tên và chưa từng bấm Bỏ qua thì vào trang điền tên
      if (authState.requiresProfileSetup) {
        return state.matchedLocation == AppRoute.completeProfile.path
            ? null
            : AppRoute.completeProfile.path;
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
        path: AppRoute.completeProfile.path,
        name: AppRoute.completeProfile.name,
        builder: (_, _) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: AppRoute.booking.path,
        name: AppRoute.booking.name,
        builder: (_, state) {
          final queryId = state.uri.queryParameters['vehicleId'];
          final extraId = state.extra is int
              ? state.extra as int
              : (state.extra is String ? int.tryParse(state.extra as String) : null);
          final vehicleId = extraId ?? (queryId != null ? int.tryParse(queryId) : null);
          return BookingConfirmationPage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: AppRoute.payment.path,
        name: AppRoute.payment.name,
        builder: (_, _) => const BookingPaymentPage(),
      ),
      GoRoute(
        path: AppRoute.bookingSuccess.path,
        name: AppRoute.bookingSuccess.name,
        builder: (_, _) => const BookingSuccessPage(),
      ),
      GoRoute(
        path: AppRoute.reservationDetail.path,
        name: AppRoute.reservationDetail.name,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
          return ReservationDetailPage(reservationId: id);
        },
      ),
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
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (_, _) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoute.editProfile.path,
        name: AppRoute.editProfile.name,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.kycUpload.path,
        name: AppRoute.kycUpload.name,
        builder: (_, _) => const KycUploadScreen(),
      ),
      GoRoute(
        path: AppRoute.kycStatus.path,
        name: AppRoute.kycStatus.name,
        builder: (_, state) {
          final doc = state.extra as KycDocumentEntity?;
          return KycStatusScreen(document: doc);
        },
      ),
      GoRoute(
        path: AppRoute.rentalHistory.path,
        name: AppRoute.rentalHistory.name,
        builder: (_, _) => const RentalHistoryScreen(),
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
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          // Branch 1: Tab 2 - Đơn thuê(My Trip)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.myTrip.path,
                name: AppRoute.myTrip.name,
                builder: (context, state) => const MyReservationsPage(),
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
