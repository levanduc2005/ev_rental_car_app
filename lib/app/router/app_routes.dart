/// Type-safe route definitions.
///
/// Using an enum for route names avoids stringly-typed navigation bugs.
/// Reference routes as `AppRoute.posts.name` / `AppRoute.posts.path`.
enum AppRoute {
  login('/login'),
  otp('/login/otp'),
  home('/home'), // Thuê xe
  control('/control'), // Điều khiển
  myTrip('/my-trip'), // Đơn thuê
  notification('/notification'), // Thông báo
  support('/support'), // Hỗ trợ
  mapSearch('/map-search'), // Tìm xe & Trạm sạc
  vehicleDetail('/vehicles/:id'),
  booking('/booking'),
  activeTrip('/active-trip'),
  payment('/payment'),
  profile('/profile');

  const AppRoute(this.path);

  /// The URL path for this route.
  final String path;
}
