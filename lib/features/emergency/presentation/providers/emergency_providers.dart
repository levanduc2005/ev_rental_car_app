import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/emergency/data/datasources/emergency_remote_data_source.dart';
import 'package:rental_car/features/emergency/data/repositories/emergency_repository_impl.dart';
import 'package:rental_car/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:rental_car/features/emergency/domain/usecases/submit_emergency_report_usecase.dart';
import 'package:rental_car/features/emergency/domain/usecases/upload_incident_image_usecase.dart';
import 'package:rental_car/features/emergency/presentation/providers/emergency_controller.dart';

// --- Data Layer Providers ---
final emergencyRemoteDataSourceProvider = Provider<EmergencyRemoteDataSource>((
  ref,
) {
  return EmergencyRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final emergencyRepositoryProvider = Provider<EmergencyRepository>((ref) {
  return EmergencyRepositoryImpl(
    remoteDataSource: ref.watch(emergencyRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final submitEmergencyReportUseCaseProvider =
    Provider<SubmitEmergencyReportUseCase>((ref) {
      return SubmitEmergencyReportUseCase(
        ref.watch(emergencyRepositoryProvider),
      );
    });

final uploadIncidentImageUseCaseProvider = Provider<UploadIncidentImageUseCase>(
  (ref) {
    return UploadIncidentImageUseCase(ref.watch(emergencyRepositoryProvider));
  },
);

// --- Presentation Layer Controller Provider ---
final emergencyControllerProvider =
    NotifierProvider<EmergencyController, EmergencyState>(
      EmergencyController.new,
    );
