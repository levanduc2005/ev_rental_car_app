import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/usecases/cancel_reservation_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_my_reservations_usecase.dart';
import 'package:rental_car/features/booking/presentation/providers/booking_providers.dart';

enum ReservationTabFilter {
  all,
  pending,
  confirmed,
  active,
  completed,
  cancelled,
}

class MyReservationsState {
  const MyReservationsState({
    this.reservations = const [],
    this.isLoading = false,
    this.isCancelling = false,
    this.selectedFilter = ReservationTabFilter.all,
    this.errorMessage,
    this.actionMessage,
    this.actionErrorMessage,
  });

  final List<ReservationEntity> reservations;
  final bool isLoading;
  final bool isCancelling;
  final ReservationTabFilter selectedFilter;
  final String? errorMessage;
  final String? actionMessage;
  final String? actionErrorMessage;

  /// Danh sách các đơn còn hiệu lực / chuyến đi (không bao gồm đơn đã hủy / quá hạn)
  List<ReservationEntity> get activeTrips => reservations
      .where((r) => !r.isCancelled && !r.isFailed && !r.isOverdue)
      .toList();

  /// Danh sách các đơn đã hủy / quá hạn / hết hạn thanh toán
  List<ReservationEntity> get cancelledTrips => reservations
      .where((r) => r.isCancelled || r.isFailed || r.isOverdue)
      .toList();

  /// Các đơn theo bộ lọc trong tab Chuyến đi
  List<ReservationEntity> get filteredActiveTrips {
    return switch (selectedFilter) {
      ReservationTabFilter.all => activeTrips,
      ReservationTabFilter.pending =>
        activeTrips.where((r) => r.isPending).toList(),
      ReservationTabFilter.confirmed =>
        activeTrips.where((r) => r.isConfirmed).toList(),
      ReservationTabFilter.active =>
        activeTrips.where((r) => r.isActive).toList(),
      ReservationTabFilter.completed =>
        activeTrips.where((r) => r.isCompleted).toList(),
      ReservationTabFilter.cancelled => activeTrips,
    };
  }

  List<ReservationEntity> get filteredReservations {
    final list = switch (selectedFilter) {
      ReservationTabFilter.all => reservations,
      ReservationTabFilter.pending =>
        reservations.where((r) => r.isPending).toList(),
      ReservationTabFilter.confirmed =>
        reservations.where((r) => r.isConfirmed).toList(),
      ReservationTabFilter.active =>
        reservations.where((r) => r.isActive).toList(),
      ReservationTabFilter.completed =>
        reservations.where((r) => r.isCompleted).toList(),
      ReservationTabFilter.cancelled =>
        reservations
            .where((r) => r.isCancelled || r.isFailed || r.isOverdue)
            .toList(),
    };

    return [...list]..sort((a, b) {
      if (b.createdAt != null && a.createdAt != null) {
        return b.createdAt!.compareTo(a.createdAt!);
      }
      return b.id.compareTo(a.id);
    });
  }

  MyReservationsState copyWith({
    List<ReservationEntity>? reservations,
    bool? isLoading,
    bool? isCancelling,
    ReservationTabFilter? selectedFilter,
    String? errorMessage,
    String? actionMessage,
    String? actionErrorMessage,
    bool clearError = false,
    bool clearActionMessage = false,
    bool clearActionErrorMessage = false,
  }) {
    return MyReservationsState(
      reservations: reservations ?? this.reservations,
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionMessage: clearActionMessage
          ? null
          : (actionMessage ?? this.actionMessage),
      actionErrorMessage: clearActionErrorMessage
          ? null
          : (actionErrorMessage ?? this.actionErrorMessage),
    );
  }
}

class MyReservationsController extends Notifier<MyReservationsState> {
  GetMyReservationsUseCase get _getMyReservationsUseCase =>
      ref.read(getMyReservationsUseCaseProvider);

  CancelReservationUseCase get _cancelReservationUseCase =>
      ref.read(cancelReservationUseCaseProvider);

  @override
  MyReservationsState build() {
    final authState = ref.watch(authControllerProvider);

    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      Future.microtask(loadReservations);
      return const MyReservationsState(isLoading: true);
    } else {
      return const MyReservationsState();
    }
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

    final result = await _getMyReservationsUseCase(email: email);

    result.when(
      ok: (list) {
        final sorted = [...list]
          ..sort((a, b) {
            if (b.createdAt != null && a.createdAt != null) {
              return b.createdAt!.compareTo(a.createdAt!);
            }
            return b.id.compareTo(a.id);
          });
        state = state.copyWith(reservations: sorted, isLoading: false);
      },
      err: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
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

    final result = await _cancelReservationUseCase(code: reservationCode);

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
          clearError: true,
          actionErrorMessage: failure.message,
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
