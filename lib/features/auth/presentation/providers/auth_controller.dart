import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/features/auth/domain/usecases/check_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/set_profile_setup_skipped_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:rental_car/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_providers.dart';
import 'package:rental_car/features/auth/presentation/providers/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final CheckProfileSetupSkippedUseCase _checkProfileSetupSkippedUseCase;
  late final SetProfileSetupSkippedUseCase _setProfileSetupSkippedUseCase;
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final CompleteProfileUseCase _completeProfileUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final SignInWithGoogleUseCase _signInWithGoogleUseCase;

  @override
  AuthState build() {
    _getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);
    _checkProfileSetupSkippedUseCase = ref.watch(
      checkProfileSetupSkippedUseCaseProvider,
    );
    _setProfileSetupSkippedUseCase = ref.watch(
      setProfileSetupSkippedUseCaseProvider,
    );
    _sendOtpUseCase = ref.watch(sendOtpUseCaseProvider);
    _verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
    _completeProfileUseCase = ref.watch(completeProfileUseCaseProvider);
    _logoutUseCase = ref.watch(logoutUseCaseProvider);
    _signInWithGoogleUseCase = ref.watch(signInWithGoogleUseCaseProvider);

    // Tự động kiểm tra phiên đăng nhập khi mở app
    Future.microtask(checkAuthStatus);

    return const AuthState();
  }

  Future<void> checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();

    await result.when(
      ok: (user) async {
        if (user != null) {
          final skippedResult = await _checkProfileSetupSkippedUseCase(
            user.email,
          );
          final hasSkipped = skippedResult.when(
            ok: (v) => v,
            err: (_) => false,
          );
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
            hasSkippedProfile: hasSkipped,
          );
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

    final result = await _sendOtpUseCase(email: email);

    return result.when(
      ok: (_) {
        state = state.copyWith(
          status: AuthStatus.otpSent,
          emailForOtp: email.trim().toLowerCase(),
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

    final result = await _verifyOtpUseCase(email: email, otp: otp);

    return await result.when(
      ok: (user) async {
        final skippedResult = await _checkProfileSetupSkippedUseCase(email);
        final hasSkipped = skippedResult.when(ok: (v) => v, err: (_) => false);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          hasSkippedProfile: hasSkipped,
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

    final result = await _completeProfileUseCase(fullName: fullName);

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

  Future<void> skipProfileSetup() async {
    final email = state.user?.email ?? state.emailForOtp;
    if (email != null && email.isNotEmpty) {
      await _setProfileSetupSkippedUseCase(email);
    }
    state = state.copyWith(hasSkippedProfile: true);
  }

  void resetOtp() {
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearError: true,
      isLoading: false,
    );
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _signInWithGoogleUseCase();

    return await result.when(
      ok: (user) async {
        final skippedResult = await _checkProfileSetupSkippedUseCase(
          user.email,
        );
        final hasSkipped = skippedResult.when(ok: (v) => v, err: (_) => false);
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          hasSkippedProfile: hasSkipped,
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
    await _logoutUseCase();
    // reset về state trắng
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
