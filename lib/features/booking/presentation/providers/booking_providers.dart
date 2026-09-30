import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source_impl.dart';
import 'package:rental_car/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/domain/usecases/cancel_reservation_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/confirm_payos_payment_usecase.dart';
import 'package:rental_car/features/booking/domain/usecases/get_reservation_detail_usecase.dart';

// --- Data Layer Providers ---
final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((
  ref,
) {
  return BookingRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(
    remoteDataSource: ref.watch(bookingRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final getReservationDetailUseCaseProvider =
    Provider<GetReservationDetailUseCase>((ref) {
      return GetReservationDetailUseCase(ref.watch(bookingRepositoryProvider));
    });

final confirmPayOSPaymentUseCaseProvider = Provider<ConfirmPayOSPaymentUseCase>(
  (ref) {
    return ConfirmPayOSPaymentUseCase(ref.watch(bookingRepositoryProvider));
  },
);

final cancelReservationUseCaseProvider = Provider<CancelReservationUseCase>((
  ref,
) {
  return CancelReservationUseCase(ref.watch(bookingRepositoryProvider));
});
