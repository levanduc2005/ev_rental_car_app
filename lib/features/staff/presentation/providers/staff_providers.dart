import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:rental_car/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/staff/domain/usecases/convert_reservation_to_rental_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_rentals_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/filter_staff_reservations_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/generate_staff_contract_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_checkin_payment_url_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_checklists_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_staff_profile_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/get_station_vehicles_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/submit_staff_checklist_usecase.dart';
import 'package:rental_car/features/staff/domain/usecases/update_rental_status_usecase.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_dashboard_controller.dart';
import 'package:rental_car/features/staff/presentation/providers/staff_handover_controller.dart';

// --- Data Layer Providers ---
final staffRemoteDataSourceProvider = Provider<StaffRemoteDataSource>((ref) {
  return StaffRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepositoryImpl(
    remoteDataSource: ref.watch(staffRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final getStaffProfileUseCaseProvider = Provider<GetStaffProfileUseCase>((ref) {
  return GetStaffProfileUseCase(ref.watch(staffRepositoryProvider));
});

final filterStaffReservationsUseCaseProvider =
    Provider<FilterStaffReservationsUseCase>((ref) {
      return FilterStaffReservationsUseCase(ref.watch(staffRepositoryProvider));
    });

final filterStaffRentalsUseCaseProvider = Provider<FilterStaffRentalsUseCase>((
  ref,
) {
  return FilterStaffRentalsUseCase(ref.watch(staffRepositoryProvider));
});

final convertReservationToRentalUseCaseProvider =
    Provider<ConvertReservationToRentalUseCase>((ref) {
      return ConvertReservationToRentalUseCase(
        ref.watch(staffRepositoryProvider),
      );
    });

final generateStaffContractUseCaseProvider =
    Provider<GenerateStaffContractUseCase>((ref) {
      return GenerateStaffContractUseCase(ref.watch(staffRepositoryProvider));
    });

final getCheckInPaymentUrlUseCaseProvider =
    Provider<GetCheckInPaymentUrlUseCase>((ref) {
      return GetCheckInPaymentUrlUseCase(ref.watch(staffRepositoryProvider));
    });

final updateRentalStatusUseCaseProvider = Provider<UpdateRentalStatusUseCase>((
  ref,
) {
  return UpdateRentalStatusUseCase(ref.watch(staffRepositoryProvider));
});

final submitStaffCheckListUseCaseProvider =
    Provider<SubmitStaffCheckListUseCase>((ref) {
      return SubmitStaffCheckListUseCase(ref.watch(staffRepositoryProvider));
    });

final getStaffChecklistsUseCaseProvider = Provider<GetStaffChecklistsUseCase>((
  ref,
) {
  return GetStaffChecklistsUseCase(ref.watch(staffRepositoryProvider));
});

final getStationVehiclesUseCaseProvider = Provider<GetStationVehiclesUseCase>((
  ref,
) {
  return GetStationVehiclesUseCase(ref.watch(staffRepositoryProvider));
});

// --- Presentation Layer Controllers ---
final staffDashboardControllerProvider =
    NotifierProvider<StaffDashboardController, StaffDashboardState>(
      StaffDashboardController.new,
    );

final staffHandoverControllerProvider =
    NotifierProvider<StaffHandoverController, StaffHandoverState>(
      StaffHandoverController.new,
    );
