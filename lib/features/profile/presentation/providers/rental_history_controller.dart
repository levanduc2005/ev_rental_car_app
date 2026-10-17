import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_history_usecase.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

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

class RentalHistoryController extends Notifier<RentalHistoryState> {
  GetRentalHistoryUseCase get _getRentalHistoryUseCase =>
      ref.read(getRentalHistoryUseCaseProvider);

  @override
  RentalHistoryState build() {
    final authState = ref.watch(authControllerProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      Future.microtask(() => loadHistory());
    }
    return const RentalHistoryState();
  }

  Future<void> loadHistory({RentalHistoryTab? tab}) async {
    final targetTab = tab ?? state.selectedTab;
    state = state.copyWith(
      status: RentalHistoryStatus.loading,
      selectedTab: targetTab,
      clearError: true,
    );

    final profileUser = ref.read(profileControllerProvider).user;
    final authUser = ref.read(authControllerProvider).user;
    final email = profileUser?.email ?? authUser?.email;

    if (email == null || email.isEmpty) {
      state = state.copyWith(
        status: RentalHistoryStatus.failure,
        errorMessage: 'Chưa có thông tin tài khoản đăng nhập.',
      );
      return;
    }

    final result = await _getRentalHistoryUseCase(
      email: email,
      status: targetTab.statuses,
      limit: 20,
    );

    result.when(
      ok: (items) {
        final sorted = [...items]
          ..sort((a, b) {
            if (b.createdAt != null && a.createdAt != null) {
              return b.createdAt!.compareTo(a.createdAt!);
            }
            return b.id.compareTo(a.id);
          });
        state = state.copyWith(
          status: RentalHistoryStatus.success,
          items: sorted,
          clearError: true,
        );
      },
      err: (failure) {
        state = state.copyWith(
          status: RentalHistoryStatus.failure,
          errorMessage: failure.message,
        );
      },
    );
  }

  void changeTab(RentalHistoryTab tab) {
    if (state.selectedTab == tab &&
        state.status == RentalHistoryStatus.success) {
      return;
    }
    loadHistory(tab: tab);
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}
