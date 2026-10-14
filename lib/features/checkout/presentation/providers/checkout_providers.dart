import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source_impl.dart';
import 'package:rental_car/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_checklists_by_rental_id_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/get_rental_overview_usecase.dart';
import 'package:rental_car/features/checkout/domain/usecases/process_checkout_payment_usecase.dart';

final checkoutRemoteDataSourceProvider =
    Provider<CheckoutRemoteDataSource>((ref) {
  return CheckoutRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepositoryImpl(
    remoteDataSource: ref.watch(checkoutRemoteDataSourceProvider),
  );
});

final getRentalOverviewUseCaseProvider =
    Provider<GetRentalOverviewUseCase>((ref) {
  return GetRentalOverviewUseCase(ref.watch(checkoutRepositoryProvider));
});

final processCheckoutPaymentUseCaseProvider =
    Provider<ProcessCheckoutPaymentUseCase>((ref) {
  return ProcessCheckoutPaymentUseCase(ref.watch(checkoutRepositoryProvider));
});

final getChecklistsByRentalIdUseCaseProvider =
    Provider<GetChecklistsByRentalIdUseCase>((ref) {
  return GetChecklistsByRentalIdUseCase(ref.watch(checkoutRepositoryProvider));
});
