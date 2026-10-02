import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';
import 'package:rental_car/features/booking/domain/entities/booking_fee_entity.dart';
import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/presentation/models/bank_app_item.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl({
    required BookingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BookingRemoteDataSource _remoteDataSource;

  @override
  Future<Result<BookingFeeEntity>> calculateFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
    bool rental = false,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.calculateBookingFees(
        vehicleId: vehicleId,
        startTime: startTime,
        endTime: endTime,
        rental: rental,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<ReservationEntity>> createReservation({
    required String userEmail,
    required int vehicleId,
    required int stationId,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return safeCall(() async {
      final requestModel = CreateReservationRequestModel(
        userEmail: userEmail,
        vehicleId: vehicleId,
        stationId: stationId,
        startTime: startTime,
        endTime: endTime,
      );
      final model = await _remoteDataSource.createReservation(requestModel);
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<ReservationEntity>>> getMyReservations({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 20,
    String search = '',
  }) {
    return safeCall(() async {
      final models = await _remoteDataSource.getMyReservations(
        email: email,
        status: status,
        page: page,
        limit: limit,
        search: search,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<ReservationEntity>> getReservationDetail(int reservationId) {
    return safeCall(() async {
      final model = await _remoteDataSource.getReservationDetail(reservationId);
      return model.toEntity();
    });
  }

  @override
  Future<Result<bool>> cancelReservation({
    required String code,
    String? reason,
  }) {
    return safeCall(() async {
      return await _remoteDataSource.cancelReservation(code, reason: reason);
    });
  }

  @override
  Future<Result<VehicleBookingSummary>> getVehicleDetail(int vehicleId) {
    return safeCall(() async {
      final model = await _remoteDataSource.getVehicleDetail(vehicleId);
      return model.toEntity();
    });
  }

  @override
  Future<Result<bool>> confirmPayOSPayment(String reservationCode) {
    return safeCall(() async {
      return await _remoteDataSource.confirmPayOSPayment(reservationCode);
    });
  }

  @override
  Future<Result<PayOSPaymentInfoEntity>> createPayOSPaymentLink(
    int reservationId,
  ) {
    return safeCall(() async {
      final model = await _remoteDataSource.createPayOSPaymentLink(
        reservationId,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<BankAppItem>>> getSupportedBanks() {
    return safeCall(() async {
      return await _remoteDataSource.getSupportedBanks();
    });
  }
}
