import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_providers.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);

    // Tự động kiểm tra phiên đăng nhập khi mở app
    Future.microtask(checkAuthStatus);

    return const AuthState();
  }

  Future<void> checkAuthStatus() async {
    final result = await _authRepository.getCurrentUser();

    result.when(
      ok: (user) {
        if (user != null) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      },
      err: (failure) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      },
    );
  }

  Future<bool> sendOtp(String email) async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.sendOtp(email: email);

    return result.when(
      ok: (_) {
        state = state.copyWith(
          status: AuthStatus.otpSent,
          emailForOtp: email,
          isLoading: false,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
        return false;
      },
    );
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.verifyOtp(email: email, otp: otp);

    return result.when(
      ok: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
        return false;
      },
    );
  }

  Future<bool> completeProfile(String fullName) async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.completeProfile(fullName: fullName);

    return result.when(
      ok: (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(errorMessage: failure.message, isLoading: false);
        return false;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authRepository.logout();
    // reset về state trắng
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

/// `true` when a user is signed in.
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
