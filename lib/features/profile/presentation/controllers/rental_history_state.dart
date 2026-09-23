import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';

enum RentalHistoryTab {
  all(label: 'Tất cả', statuses: null),
  ongoing(
    label: 'Đang thuê',
    statuses: ['ONGOING', 'CONFIRM', 'PENDING_FEE', 'OVERDUE'],
  ),
  completed(label: 'Hoàn thành', statuses: ['COMPLETED']),
  cancelled(label: 'Đã hủy', statuses: ['CANCELLED']);

  const RentalHistoryTab({required this.label, required this.statuses});
  final String label;
  final List<String>? statuses;
}

enum RentalHistoryStatus { initial, loading, success, failure }

class RentalHistoryState {
  const RentalHistoryState({
    this.status = RentalHistoryStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.selectedTab = RentalHistoryTab.all,
  });

  final RentalHistoryStatus status;
  final List<RentalItemEntity> items;
  final String? errorMessage;
  final RentalHistoryTab selectedTab;

  bool get isLoading => status == RentalHistoryStatus.loading;

  RentalHistoryState copyWith({
    RentalHistoryStatus? status,
    List<RentalItemEntity>? items,
    String? errorMessage,
    bool clearError = false,
    RentalHistoryTab? selectedTab,
  }) {
    return RentalHistoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
