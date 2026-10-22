import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source_impl.dart';
import 'package:rental_car/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/check_rental_compensation_payment_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_checkout_checklist_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_or_update_vehicle_log_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/create_rental_compensation_payment_link_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_checklists_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_rental_overview_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_vehicle_log_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/process_checkout_payment_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/update_checkout_checklist_usecase.dart';

final checkoutRemoteDataSourceProvider = Provider<CheckoutRemoteDataSource>((
  ref,
) {
  return CheckoutRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepositoryImpl(
    remoteDataSource: ref.watch(checkoutRemoteDataSourceProvider),
  );
});

final getRentalOverviewUseCaseProvider = Provider<GetRentalOverviewUseCase>((
  ref,
) {
  return GetRentalOverviewUseCase(ref.watch(checkoutRepositoryProvider));
});

final processCheckoutPaymentUseCaseProvider =
    Provider<ProcessCheckoutPaymentUseCase>((ref) {
      return ProcessCheckoutPaymentUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final getChecklistsByRentalIdUseCaseProvider =
    Provider<GetChecklistsByRentalIdUseCase>((ref) {
      return GetChecklistsByRentalIdUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final createCheckoutChecklistUseCaseProvider =
    Provider<CreateCheckoutChecklistUseCase>((ref) {
      return CreateCheckoutChecklistUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final createOrUpdateVehicleLogUseCaseProvider =
    Provider<CreateOrUpdateVehicleLogUseCase>((ref) {
      return CreateOrUpdateVehicleLogUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final getVehicleLogByRentalIdUseCaseProvider =
    Provider<GetVehicleLogByRentalIdUseCase>((ref) {
      return GetVehicleLogByRentalIdUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final updateCheckoutChecklistUseCaseProvider =
    Provider<UpdateCheckoutChecklistUseCase>((ref) {
      return UpdateCheckoutChecklistUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final createRentalCompensationPaymentLinkUseCaseProvider =
    Provider<CreateRentalCompensationPaymentLinkUseCase>((ref) {
      return CreateRentalCompensationPaymentLinkUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });

final checkRentalCompensationPaymentUseCaseProvider =
    Provider<CheckRentalCompensationPaymentUseCase>((ref) {
      return CheckRentalCompensationPaymentUseCase(
        ref.watch(checkoutRepositoryProvider),
      );
    });
