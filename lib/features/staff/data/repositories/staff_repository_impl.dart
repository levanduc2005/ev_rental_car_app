import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';
import 'package:rental_car/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/domain/entities/staff_station_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

class StaffRepositoryImpl implements StaffRepository {
  const StaffRepositoryImpl({required StaffRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final StaffRemoteDataSource _remoteDataSource;

  @override
  Future<Result<StaffProfileEntity>> getStaffProfile() async {
    try {
      final profile = await _remoteDataSource.getStaffProfile();
      return Result.ok(profile);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi tải hồ sơ nhân viên: $e'));
    }
  }

  @override
  Future<Result<List<ReservationEntity>>> filterReservations({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.filterReservations(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Result.ok(entities);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi nạp danh sách đặt xe: $e'));
    }
  }

  @override
  Future<Result<List<RentalDetailEntity>>> filterRentals({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.filterRentals(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Result.ok(entities);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi nạp danh sách đơn thuê: $e'));
    }
  }

  @override
  Future<Result<RentalDetailEntity>> convertReservationToRental({
    required String reservationCode,
    required int staffId,
  }) async {
    try {
      final model = await _remoteDataSource.convertReservationToRental(
        reservationCode: reservationCode,
        staffId: staffId,
      );
      return Result.ok(model.toEntity());
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi chuyển đổi đơn thuê: $e'));
    }
  }

  @override
  Future<Result<String>> generateContract(int rentalId) async {
    try {
      final url = await _remoteDataSource.generateContract(rentalId);
      return Result.ok(url);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi tạo hợp đồng DocuSeal: $e'));
    }
  }

  @override
  Future<Result<String>> getCheckInPaymentUrl({
    required int rentalId,
    int point = 0,
  }) async {
    try {
      final url = await _remoteDataSource.getCheckInPaymentUrl(
        rentalId: rentalId,
        point: point,
      );
      return Result.ok(url);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi lấy link thanh toán: $e'));
    }
  }

  @override
  Future<Result<void>> updateRentalStatus({
    required int rentalId,
    required String status,
  }) async {
    try {
      await _remoteDataSource.updateRentalStatus(
        rentalId: rentalId,
        status: status,
      );
      return const Result.ok(null);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(
        DataFailure(message: 'Lỗi cập nhật trạng thái đơn: $e'),
      );
    }
  }

  @override
  Future<Result<RentalChecklistEntity>> submitCheckInChecklist({
    required int rentalId,
    required String staffEmail,
    required int currentBattery,
    required String img,
  }) async {
    try {
      final model = await _remoteDataSource.submitCheckInChecklist(
        rentalId: rentalId,
        staffEmail: staffEmail,
        currentBattery: currentBattery,
        img: img,
      );
      return Result.ok(model);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi lập biên bản nhận xe: $e'));
    }
  }

  @override
  Future<Result<List<RentalChecklistEntity>>> getChecklists({
    String? keyword,
    String? type,
  }) async {
    try {
      final models = await _remoteDataSource.getChecklists(
        keyword: keyword,
        type: type,
      );
      return Result.ok(models);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi nạp biên bản giao nhận: $e'));
    }
  }

  @override
  Future<Result<List<VehicleEntity>>> getStationVehicles(int stationId) async {
    try {
      final vehicles = await _remoteDataSource.getStationVehicles(stationId);
      return Result.ok(vehicles);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(
        DataFailure(message: 'Lỗi nạp danh sách xe tại trạm: $e'),
      );
    }
  }

  @override
  Future<Result<RenterEntity>> getRenterByEmail(String email) async {
    try {
      final model = await _remoteDataSource.getRenterByEmail(email);
      return Result.ok(model.toEntity());
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(
        DataFailure(message: 'Lỗi tra cứu thông tin người thuê: $e'),
      );
    }
  }

  @override
  Future<Result<RentalDetailEntity>> createRental({
    required DateTime startTime,
    required DateTime endTime,
    required int vehicleId,
    required String email,
    required int staffId,
  }) async {
    try {
      final model = await _remoteDataSource.createRental(
        startTime: startTime,
        endTime: endTime,
        vehicleId: vehicleId,
        email: email,
        staffId: staffId,
      );
      return Result.ok(model.toEntity());
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi tạo hợp đồng thuê xe: $e'));
    }
  }

  @override
  Future<Result<bool>> cancelRental(int rentalId) async {
    try {
      final success = await _remoteDataSource.cancelRental(rentalId);
      return Result.ok(success);
    } on NetworkException catch (e) {
      return Result.err(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.err(ServerFailure(message: e.message));
    } catch (e) {
      return Result.err(DataFailure(message: 'Lỗi hủy đơn thuê: $e'));
    }
  }
}
