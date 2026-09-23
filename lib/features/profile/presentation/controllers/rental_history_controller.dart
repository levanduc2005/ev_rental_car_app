import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_history_usecase.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class RentalHistoryController extends Notifier<RentalHistoryState> {
  late final GetRentalHistoryUseCase _getRentalHistoryUseCase;

  @override
  RentalHistoryState build() {
    _getRentalHistoryUseCase = ref.watch(getRentalHistoryUseCaseProvider);
    Future.microtask(() => loadHistory());
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
        state = state.copyWith(
          status: RentalHistoryStatus.success,
          items: items,
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
