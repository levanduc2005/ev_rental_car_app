import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
    this.isUpdating = false,
    this.updateSuccess = false,
  });

  final ProfileStatus status;
  final UserProfileEntity? user;
  final String? errorMessage;
  final bool isUpdating;
  final bool updateSuccess;

  bool get isLoading => status == ProfileStatus.loading;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfileEntity? user,
    String? errorMessage,
    bool? isUpdating,
    bool? updateSuccess,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUpdating: isUpdating ?? this.isUpdating,
      updateSuccess: updateSuccess ?? this.updateSuccess,
    );
  }
}
