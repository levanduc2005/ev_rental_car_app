import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source_impl.dart';
import 'package:rental_car/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';

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
