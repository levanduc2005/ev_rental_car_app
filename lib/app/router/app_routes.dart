/// Type-safe route definitions.
///
/// Using an enum for route names avoids stringly-typed navigation bugs.
/// Reference routes as `AppRoute.posts.name` / `AppRoute.posts.path`.
enum AppRoute {
  login('/login'),
  otp('/login/otp'),
  completeProfile('/login/complete-profile'),
  home('/home'),
  mapSearch('/map-search'),
  control('/control'), // Điều khiển
  myTrip('/my-trip'), // Đơn thuê
  notification('/notification'), // Thông báo
  support('/support'), // Hỗ trợ
  vehicleDetail('/vehicles/:id'),
  booking('/booking'),
  qrScan('/home/qr-scan'),
  instantBooking('/booking/instant'),
  activeTrip('/active-trip'),
  payment('/payment'),
  bookingSuccess('/booking-success'),
  reservationDetail('/reservations/:id'),
  profile('/profile'),
  editProfile('/profile/edit'),
  kycUpload('/profile/kyc-upload'),
  kycStatus('/profile/kyc-status'),
  rentalHistory('/profile/rental-history'),
  rentalDetail('/rentals/:id'),
  returnLocationVerification('/checkout/verify-location'),
  returnVehicleLog('/checkout/vehicle-log'),
  checkoutSummary('/checkout/summary'),
  checkIn('/checkin/:id'),
  emergencyReport('/emergency-report'),
  staffDashboard('/staff/dashboard'),
  staffHandover('/staff/handover');

  const AppRoute(this.path);

  final String path;
}
