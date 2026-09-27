import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';

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
  });

  final List<ReservationEntity> reservations;
  final bool isLoading;
  final bool isCancelling;
  final ReservationTabFilter selectedFilter;
  final String? errorMessage;
  final String? actionMessage;

  List<ReservationEntity> get filteredReservations {
    return switch (selectedFilter) {
      ReservationTabFilter.all => reservations,
      ReservationTabFilter.pending =>
        reservations.where((r) => r.isPending).toList(),
      ReservationTabFilter.confirmed =>
        reservations.where((r) => r.isConfirmed).toList(),
      ReservationTabFilter.active => reservations
          .where((r) =>
              r.status.toUpperCase() == 'ACTIVE' ||
              r.status.toUpperCase() == 'IN_PROGRESS')
          .toList(),
      ReservationTabFilter.completed =>
        reservations.where((r) => r.isCompleted).toList(),
      ReservationTabFilter.cancelled => reservations
          .where((r) => r.isCancelled || r.isFailed || r.isOverdue)
          .toList(),
    };
  }

  MyReservationsState copyWith({
    List<ReservationEntity>? reservations,
    bool? isLoading,
    bool? isCancelling,
    ReservationTabFilter? selectedFilter,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearActionMessage = false,
  }) {
    return MyReservationsState(
      reservations: reservations ?? this.reservations,
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionMessage:
          clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }
}
