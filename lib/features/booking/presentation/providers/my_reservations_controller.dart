import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';
import 'package:rental_car/features/booking/presentation/providers/my_reservations_state.dart';

class MyReservationsController extends Notifier<MyReservationsState> {
  late final BookingRepository _repository;

  @override
  MyReservationsState build() {
    _repository = ref.watch(bookingRepositoryProvider);

    // Tự động tải danh sách đơn thuê khi vào trang
    Future.microtask(loadReservations);

    return const MyReservationsState(isLoading: true);
  }

  /// Tải danh sách đơn đặt xe thực tế của user từ API GET /api/reservations/email
  Future<void> loadReservations() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final currentUser = ref.read(authControllerProvider).user;
    final email = currentUser?.email ?? '';

    if (email.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        reservations: const [],
        errorMessage: 'Vui lòng đăng nhập để xem danh sách chuyến đi của bạn.',
      );
      return;
    }

    final result = await _repository.getMyReservations(email: email);

    result.when(
      ok: (list) {
        state = state.copyWith(
          reservations: list,
          isLoading: false,
        );
      },
      err: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Đổi tab lọc (Tất cả, Chờ thanh toán, Đã cọc, Hoàn thành, Đã hủy)
  void setFilter(ReservationTabFilter filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Hủy đơn đặt xe qua API PUT /api/reservations/{code}/cancel
  Future<bool> cancelReservation(String reservationCode) async {
    state = state.copyWith(isCancelling: true, clearError: true);

    final result = await _repository.cancelReservation(code: reservationCode);

    return result.when(
      ok: (success) {
        state = state.copyWith(
          isCancelling: false,
          actionMessage: 'Đã hủy đơn thuê $reservationCode thành công.',
        );
        // Refresh lại danh sách
        loadReservations();
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isCancelling: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}

final myReservationsControllerProvider =
    NotifierProvider<MyReservationsController, MyReservationsState>(
  MyReservationsController.new,
);
