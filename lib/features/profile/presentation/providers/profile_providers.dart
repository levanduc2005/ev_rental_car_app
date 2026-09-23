import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:rental_car/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';
import 'package:rental_car/features/profile/domain/usecases/delete_kyc_document_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/get_kyc_status_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/get_rental_history_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:rental_car/features/profile/domain/usecases/upload_kyc_document_usecase.dart';
import 'package:rental_car/features/profile/presentation/controllers/kyc_controller.dart';
import 'package:rental_car/features/profile/presentation/controllers/kyc_state.dart';
import 'package:rental_car/features/profile/presentation/controllers/profile_controller.dart';
import 'package:rental_car/features/profile/presentation/controllers/profile_state.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_controller.dart';
import 'package:rental_car/features/profile/presentation/controllers/rental_history_state.dart';

// --- Data Layer Providers ---
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
});

final uploadKycDocumentUseCaseProvider = Provider<UploadKycDocumentUseCase>((
  ref,
) {
  return UploadKycDocumentUseCase(ref.watch(profileRepositoryProvider));
});

final getKycStatusUseCaseProvider = Provider<GetKycStatusUseCase>((ref) {
  return GetKycStatusUseCase(ref.watch(profileRepositoryProvider));
});

final deleteKycDocumentUseCaseProvider = Provider<DeleteKycDocumentUseCase>((
  ref,
) {
  return DeleteKycDocumentUseCase(ref.watch(profileRepositoryProvider));
});

final getRentalHistoryUseCaseProvider = Provider<GetRentalHistoryUseCase>((
  ref,
) {
  return GetRentalHistoryUseCase(ref.watch(profileRepositoryProvider));
});

// --- Presentation Layer Controllers ---
final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);

final kycControllerProvider = NotifierProvider<KycController, KycState>(
  KycController.new,
);

final rentalHistoryControllerProvider =
    NotifierProvider<RentalHistoryController, RentalHistoryState>(
      RentalHistoryController.new,
    );
