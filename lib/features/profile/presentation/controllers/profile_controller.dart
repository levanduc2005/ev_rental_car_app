import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_controller.dart';
import 'package:rental_car/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:rental_car/features/profile/presentation/controllers/profile_state.dart';
import 'package:rental_car/features/profile/presentation/providers/profile_providers.dart';

class ProfileController extends Notifier<ProfileState> {
  GetProfileUseCase get _getProfileUseCase =>
      ref.read(getProfileUseCaseProvider);
  UpdateProfileUseCase get _updateProfileUseCase =>
      ref.read(updateProfileUseCaseProvider);

  @override
  ProfileState build() {
    // Tự động reset state khi đăng xuất và tải thông tin mới khi đăng nhập
    final authState = ref.watch(authControllerProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      Future.microtask(loadProfile);
    }

    return const ProfileState();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: ProfileStatus.loading, clearError: true);
    final result = await _getProfileUseCase();
    result.when(
      ok: (user) {
        state = state.copyWith(
          status: ProfileStatus.success,
          user: user,
          clearError: true,
        );
      },
      err: (failure) {
        state = state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        );
      },
    );
  }

  Future<void> refreshProfile() async {
    final result = await _getProfileUseCase();
    result.when(
      ok: (user) {
        state = state.copyWith(
          status: ProfileStatus.success,
          user: user,
          clearError: true,
        );
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
    );
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    state = state.copyWith(
      isUpdating: true,
      updateSuccess: false,
      clearError: true,
    );
    final result = await _updateProfileUseCase(
      fullName: fullName,
      phone: phone,
    );
    return result.when(
      ok: (updatedUser) {
        state = state.copyWith(
          isUpdating: false,
          updateSuccess: true,
          user: updatedUser,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(
          isUpdating: false,
          updateSuccess: false,
          errorMessage: failure.message,
        );
        return false;
      },
    );
  }
}
