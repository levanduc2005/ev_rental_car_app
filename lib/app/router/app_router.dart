import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_car/app/router/app_routes.dart';
import 'package:rental_car/features/active_trip/presentation/pages/active_trip_page.dart';
import 'package:rental_car/features/auth/domain/entities/user_entity.dart';
import 'package:rental_car/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:rental_car/features/auth/presentation/pages/login_page.dart';
import 'package:rental_car/features/auth/presentation/pages/otp_page.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_confirmation_page.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_payment_page.dart';
import 'package:rental_car/features/booking/presentation/pages/booking_success_page.dart';
import 'package:rental_car/features/booking/presentation/pages/my_reservations_page.dart';
import 'package:rental_car/features/booking/presentation/pages/reservation_detail_page.dart';
import 'package:rental_car/features/checkin/presentation/pages/check_in_page.dart';
import 'package:rental_car/features/checkout/presentation/pages/checkout_summary_page.dart';
import 'package:rental_car/features/checkout/presentation/pages/rental_checkout_page.dart';
import 'package:rental_car/features/checkout/presentation/pages/return_location_verification_page.dart';
import 'package:rental_car/features/checkout/presentation/pages/return_vehicle_log_page.dart';
import 'package:rental_car/features/emergency/presentation/pages/emergency_report_page.dart';
import 'package:rental_car/features/emergency/presentation/pages/support_emergency_page.dart';
import 'package:rental_car/features/home/presentation/pages/home_page.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:rental_car/features/profile/presentation/pages/kyc_status_page.dart';
import 'package:rental_car/features/profile/presentation/pages/kyc_upload_page.dart';
import 'package:rental_car/features/profile/presentation/pages/profile_page.dart';
import 'package:rental_car/features/profile/presentation/pages/rental_detail_page.dart';
import 'package:rental_car/features/profile/presentation/pages/rental_history_page.dart';
import 'package:rental_car/features/shell/presentation/scaffold_with_nav_bar.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_dashboard_page.dart';
import 'package:rental_car/features/staff/presentation/pages/staff_handover_page.dart';
import 'package:rental_car/features/vehicles/presentation/pages/map_search_page.dart';
import 'package:rental_car/features/vehicles/presentation/pages/vehicle_detail_page.dart';
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
      final location = state.matchedLocation;

      final onAuthPage =
          location == AppRoute.login.path ||
          location == AppRoute.otp.path ||
          location == AppRoute.completeProfile.path;

      // 1. Chưa đăng nhập: Điều hướng về màn hình đăng nhập
      if (!loggedIn) {
        if (location == AppRoute.otp.path && authState.emailForOtp == null) {
          return AppRoute.login.path;
        }
        return onAuthPage ? null : AppRoute.login.path;
      }

      // 2. Đã đăng nhập: Kiểm tra vai trò Staff / Admin
      final user = authState.user;
      final isStaffOrAdmin = user != null && user.isStaff;

      if (isStaffOrAdmin) {
        // Staff/Admin TUYỆT ĐỐI KHÔNG BAO GIỜ được vào trang của User/Khách
        // Chỉ được phép ở các route dành riêng cho Staff:
        final isStaffRoute =
            location == AppRoute.staffDashboard.path ||
            location == AppRoute.staffHandover.path ||
            location.startsWith('/rentals/') ||
            location.startsWith('/checkout/') ||
            location.startsWith('/checkin/') ||
            location.startsWith('/reservations/') ||
            location.startsWith('/emergency');

        if (!isStaffRoute) {
          return AppRoute.staffDashboard.path;
        }
        return null;
      }

      // 3. Người dùng bình thường (Khách hàng):
      // Nếu chưa có tên và chưa từng bấm Bỏ qua thì vào trang điền tên
      if (authState.requiresProfileSetup) {
        return location == AppRoute.completeProfile.path
            ? null
            : AppRoute.completeProfile.path;
      }

      // Khách hàng không được vào các route nội bộ của Staff
      final isStaffRoute =
          location == AppRoute.staffDashboard.path ||
          location == AppRoute.staffHandover.path;
      if (isStaffRoute) {
        return AppRoute.home.path;
      }

      // Nếu khách đang ở trang Auth thì chuyển về Home
      if (onAuthPage) {
        return AppRoute.home.path;
      }

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
              : (state.extra is String
                    ? int.tryParse(state.extra as String)
                    : null);
          final vehicleId =
              extraId ?? (queryId != null ? int.tryParse(queryId) : null);
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
        builder: (context, state) => const MapSearchPage(),
        routes: [
          GoRoute(
            path: ':id',
            redirect: (context, state) =>
                '/vehicles/${state.pathParameters['id'] ?? '1'}',
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.vehicleDetail.path,
        name: AppRoute.vehicleDetail.name,
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '1';
          return VehicleDetailPage(vehicleId: id);
        },
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (_, _) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoute.editProfile.path,
        name: AppRoute.editProfile.name,
        builder: (_, _) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoute.kycUpload.path,
        name: AppRoute.kycUpload.name,
        builder: (_, state) {
          final initialType = state.extra as DocumentType?;
          return KycUploadPage(initialType: initialType);
        },
      ),
      GoRoute(
        path: AppRoute.kycStatus.path,
        name: AppRoute.kycStatus.name,
        builder: (_, state) {
          if (state.extra is KycDocumentEntity) {
            return KycStatusPage(document: state.extra as KycDocumentEntity);
          } else if (state.extra is DocumentType) {
            return KycStatusPage(initialType: state.extra as DocumentType);
          }
          return const KycStatusPage();
        },
      ),
      GoRoute(
        path: AppRoute.rentalHistory.path,
        name: AppRoute.rentalHistory.name,
        builder: (_, _) => const RentalHistoryPage(),
      ),
      GoRoute(
        path: AppRoute.rentalDetail.path,
        name: AppRoute.rentalDetail.name,
        builder: (_, state) {
          final id =
              int.tryParse(state.pathParameters['id'] ?? '') ??
              (state.extra is int ? state.extra as int : 1);
          return RentalDetailPage(rentalId: id);
        },
      ),
      GoRoute(
        path: AppRoute.returnLocationVerification.path,
        name: AppRoute.returnLocationVerification.name,
        builder: (_, state) {
          if (state.extra is RentalDetailEntity) {
            final rental = state.extra as RentalDetailEntity;
            return ReturnLocationVerificationPage(
              rentalId: rental.id,
              vehicleId: rental.vehicleId,
              staffId: rental.staffId,
              stationName: rental.stationName,
              stationAddress: rental.stationAddress,
              stationLat: rental.stationLatitude,
              stationLng: rental.stationLongitude,
            );
          }
          final rentalId = state.extra is int ? state.extra as int : null;
          return ReturnLocationVerificationPage(rentalId: rentalId);
        },
      ),
      GoRoute(
        path: AppRoute.returnVehicleLog.path,
        name: AppRoute.returnVehicleLog.name,
        builder: (_, state) {
          final rentalId = state.extra is int ? state.extra as int : null;
          return ReturnVehicleLogPage(rentalId: rentalId);
        },
      ),
      GoRoute(
        path: AppRoute.checkoutSummary.path,
        name: AppRoute.checkoutSummary.name,
        builder: (_, state) {
          final rentalId = state.extra is int ? state.extra as int : null;
          return CheckoutSummaryPage(rentalId: rentalId);
        },
      ),
      GoRoute(
        path: AppRoute.emergencyReport.path,
        name: AppRoute.emergencyReport.name,
        builder: (_, state) {
          final rentalId = state.extra as int?;
          return EmergencyReportPage(rentalId: rentalId);
        },
      ),
      GoRoute(
        path: AppRoute.checkIn.path,
        name: AppRoute.checkIn.name,
        builder: (_, state) {
          final idStr = state.pathParameters['id'];
          final id =
              int.tryParse(idStr ?? '') ??
              (state.extra is RentalDetailEntity
                  ? (state.extra as RentalDetailEntity).id
                  : (state.extra is int ? state.extra as int : 0));
          final initialRental = state.extra is RentalDetailEntity
              ? state.extra as RentalDetailEntity
              : null;
          return CheckInPage(rentalId: id, initialRental: initialRental);
        },
      ),
      GoRoute(
        path: AppRoute.rentalCheckout.path,
        name: AppRoute.rentalCheckout.name,
        builder: (_, state) {
          final idStr = state.pathParameters['id'];
          final id =
              int.tryParse(idStr ?? '') ??
              (state.extra is RentalDetailEntity
                  ? (state.extra as RentalDetailEntity).id
                  : (state.extra is int ? state.extra as int : 0));
          final initialRental = state.extra is RentalDetailEntity
              ? state.extra as RentalDetailEntity
              : null;
          return RentalCheckoutPage(rentalId: id, initialRental: initialRental);
        },
      ),
      GoRoute(
        path: AppRoute.activeTrip.path,
        name: AppRoute.activeTrip.name,
        builder: (_, state) {
          final rentalId = state.extra is int ? state.extra as int : null;
          return ActiveTripPage(rentalId: rentalId);
        },
      ),
      GoRoute(
        path: AppRoute.staffDashboard.path,
        name: AppRoute.staffDashboard.name,
        builder: (_, _) => const StaffDashboardPage(),
      ),
      GoRoute(
        path: AppRoute.staffHandover.path,
        name: AppRoute.staffHandover.name,
        builder: (_, state) {
          final res = state.extra is ReservationEntity
              ? state.extra as ReservationEntity
              : null;
          final rental = state.extra is RentalDetailEntity
              ? state.extra as RentalDetailEntity
              : null;
          return StaffHandoverPage(reservation: res, rental: rental);
        },
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
          // Branch 1: Tab 2 - Đơn hàng & Thuê xe (My Trip / Reservations & Rentals)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.myTrip.path,
                name: AppRoute.myTrip.name,
                builder: (context, state) => const MyReservationsPage(),
              ),
            ],
          ),
          // Branch 2: Tab 3 - Thông báo (Notification)
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
          // Branch 3: Tab 4 - Hỗ trợ & Cứu hộ SOS (Support & Emergency)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.support.path,
                name: AppRoute.support.name,
                builder: (context, state) => const SupportEmergencyPage(),
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
