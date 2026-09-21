import 'package:rental_car/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial, // trạng thái khởi tạo: đang kiểm tra phiên đăng nhập cũ trong máy
  unauthenticated, // chưa đăng nhập -> màn hình email
  otpSent, // đã gửi OTP -> màn hình nhập OTP
  authenticated, // đã đăng nhập thành công
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? emailForOtp;
  final bool isLoading;
  final String? errorMessage;
  final bool hasSkippedProfile;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.emailForOtp,
    this.isLoading = false,
    this.errorMessage,
    this.hasSkippedProfile = false,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get requiresProfileSetup =>
      isAuthenticated &&
      (user?.fullName == null || user!.fullName!.trim().isEmpty) &&
      !hasSkippedProfile;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? emailForOtp,
    bool? isLoading,
    String? errorMessage,
    bool? hasSkippedProfile,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      emailForOtp: emailForOtp ?? this.emailForOtp,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasSkippedProfile: hasSkippedProfile ?? this.hasSkippedProfile,
    );
  }
}
