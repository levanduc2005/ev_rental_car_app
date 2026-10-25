import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_rental_entity.freezed.dart';

/// Thực thể biểu diễn đơn thuê xe của người dùng (100% khớp dữ liệu BE RentalResponse)
@freezed
abstract class ActiveRentalEntity with _$ActiveRentalEntity {
  const factory ActiveRentalEntity({
    required int id,
    required String status,
    required DateTime startTime,
    required DateTime endTime,
    required double rentFee,
    @Default(0) int discountPoint,
    required int vehicleId,
    required String vehicleName,
    required String vehicleBrand,
    required String vehiclePlate,
    @Default('') String vehicleImageUrl,
    @Default(0) int batteryLevel,
    double? batteryCapacity,
    String? stationName,
    String? stationAddress,
    double? stationLat,
    double? stationLng,
    String? contractStatus,
    String? contractUrl,
    double? rentalDeposit,
    String? userEmail,
  }) = _ActiveRentalEntity;

  const ActiveRentalEntity._();

  /// Đơn thuê có đang trong trạng thái hoạt động / đang chạy không
  bool get isActive {
    final s = status.toUpperCase();
    return s == 'IN_PROGRESS' || s == 'ACTIVE' || s == 'ONGOING';
  }

  /// Đang chờ thanh toán tiền gia hạn
  bool get isPendingExtendFee => status.toUpperCase() == 'PENDING_EXTEND_FEE';

  /// Có thể thực hiện gia hạn không
  bool get canExtend =>
      (isActive || status.toUpperCase() == 'OVERDUE') && !isPendingExtendFee;

  /// Thời gian đã trôi qua kể từ khi bắt đầu nhận xe
  Duration get elapsedDuration {
    final now = DateTime.now();
    if (now.isBefore(startTime)) return Duration.zero;
    return now.difference(startTime);
  }

  /// Thời gian còn lại tới hạn phải trả xe
  Duration get remainingDuration {
    final now = DateTime.now();
    if (now.isAfter(endTime)) return Duration.zero;
    return endTime.difference(now);
  }

  /// Đã quá hạn trả xe chưa
  bool get isOverdue => DateTime.now().isAfter(endTime);
}
