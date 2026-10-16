import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/checkin/data/datasources/checkin_remote_data_source.dart';
import 'package:rental_car/features/checkin/data/repositories/checkin_repository_impl.dart';
import 'package:rental_car/features/checkin/domain/repositories/checkin_repository.dart';
import 'package:rental_car/features/checkin/domain/usecases/check_license_status_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/confirm_contract_signed_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/generate_contract_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/submit_pickup_checklist_usecase.dart';
import 'package:rental_car/features/checkin/domain/usecases/upload_car_image_usecase.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_controller.dart';
import 'package:rental_car/features/checkin/presentation/controllers/checkin_state.dart';

// --- Data Layer Providers ---
final checkinRemoteDataSourceProvider = Provider<CheckinRemoteDataSource>((
  ref,
) {
  return CheckinRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return CheckinRepositoryImpl(
    remoteDataSource: ref.watch(checkinRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final checkLicenseStatusUseCaseProvider = Provider<CheckLicenseStatusUseCase>((
  ref,
) {
  return CheckLicenseStatusUseCase(ref.watch(checkinRepositoryProvider));
});

final uploadCarImageUseCaseProvider = Provider<UploadCarImageUseCase>((ref) {
  return UploadCarImageUseCase(ref.watch(checkinRepositoryProvider));
});

final submitPickupChecklistUseCaseProvider =
    Provider<SubmitPickupChecklistUseCase>((ref) {
      return SubmitPickupChecklistUseCase(ref.watch(checkinRepositoryProvider));
    });

final generateContractUseCaseProvider = Provider<GenerateContractUseCase>((
  ref,
) {
  return GenerateContractUseCase(ref.watch(checkinRepositoryProvider));
});

final confirmContractSignedUseCaseProvider =
    Provider<ConfirmContractSignedUseCase>((ref) {
      return ConfirmContractSignedUseCase(ref.watch(checkinRepositoryProvider));
    });

// --- Presentation Controller Provider ---
final checkInControllerProvider =
    NotifierProvider<CheckInController, CheckInState>(CheckInController.new);
