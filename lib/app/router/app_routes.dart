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
  vehicleDetail('/vehicles/:id'),
  booking('/booking'),
  activeTrip('/active-trip'),
  payment('/payment'),
  profile('/profile');

  const AppRoute(this.path);

  final String path;
}
