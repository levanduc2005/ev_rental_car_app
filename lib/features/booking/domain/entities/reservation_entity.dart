import 'package:rental_car/features/booking/domain/entities/payos_payment_info_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

class ReservationEntity {
  const ReservationEntity({
    required this.id,
    required this.code,
    required this.status,
    this.createdAt,
    this.startTime,
    this.endTime,
    this.userEmail,
    this.stationId,
    this.stationName,
    this.stationAddress,
    this.vehicle,
    this.paymentUrl,
    this.paymentInfo,
    this.depositAmount,
    this.totalRentAmount,
  });

  final int id;
  final String code;
  final String status;
  final DateTime? createdAt;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? userEmail;
  final int? stationId;
  final String? stationName;
  final String? stationAddress;
  final VehicleBookingSummary? vehicle;
  final String? paymentUrl;
  final PayOSPaymentInfoEntity? paymentInfo;
  final double? depositAmount;
  final double? totalRentAmount;

  bool get isPending =>
      status.toUpperCase() == 'PENDING' ||
      status.toUpperCase() == 'WAITING_PAYMENT';
  bool get isConfirmed =>
      status.toUpperCase() == 'CONFIRM' ||
      status.toUpperCase() == 'CONFIRMED' ||
      status.toUpperCase() == 'DEPOSITED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isFailed => status.toUpperCase() == 'FAILED';
  bool get isOverdue => status.toUpperCase() == 'OVERDUE';

  /// Kiểm tra xem đơn có được phép hủy hay không:
  /// - Đơn PENDING: được hủy tức thì.
  /// - Đơn CONFIRM: chỉ được hủy nếu còn cách giờ nhận xe trên 5 ngày theo quy định BE.
  bool get canCancel {
    if (isPending) return true;
    if (isConfirmed) {
      final now = DateTime.now();
      return startDateTime.isAfter(now.add(const Duration(days: 5)));
    }
    return false;
  }

  // Tiện ích tương thích giao diện
  String get reservationCode => code;
  DateTime get startDateTime => startTime ?? DateTime.now();
  DateTime get endDateTime =>
      endTime ?? DateTime.now().add(const Duration(hours: 4));

  /// Tiền cọc giữ chỗ: lấy từ cổng thanh toán PayOS hoặc deposit backend
  int get depositFee =>
      paymentInfo?.depositFee ??
      (depositAmount != null ? depositAmount!.toInt() : 500000);

  /// Tổng tiền thuê xe dự tính: lấy từ API biểu phí hoặc tính theo giá xe theo giờ
  int get totalAmount {
    if (totalRentAmount != null && totalRentAmount! > 0) {
      return totalRentAmount!.toInt();
    }
    if (vehicle != null && startTime != null && endTime != null) {
      final hours = endTime!.difference(startTime!).inHours;
      if (hours <= 4 && vehicle!.price4h > 0) return vehicle!.price4h;
      if (hours <= 8 && vehicle!.price8h > 0) return vehicle!.price8h;
      if (hours <= 12 && vehicle!.price12h > 0) return vehicle!.price12h;
      final days = (hours / 24).ceil();
      if (vehicle!.price24h > 0) {
        return vehicle!.price24h * (days > 0 ? days : 1);
      }
    }
    return 0;
  }

  /// Tiền thế chấp xe (Collateral / Deposit): lấy từ cấu hình từng xe
  int get collateralFee => vehicle?.depositFee?.toInt() ?? 3000000;

  /// Địa điểm nhận xe: trích xuất theo địa chỉ trạm thật
  String get pickupLocation {
    if (stationAddress != null && stationAddress!.isNotEmpty) {
      return stationAddress!;
    }
    if (stationName != null && stationName!.isNotEmpty) {
      return stationName!;
    }
    if (stationId != null) {
      return 'Trạm #$stationId';
    }
    return 'Trạm nhận xe e-Motion';
  }

  /// Địa điểm trả xe
  String get returnLocation => pickupLocation;

  String get paymentMethod =>
      paymentInfo != null ? 'PayOS (VietQR)' : 'PayOS (VietQR)';

  ReservationEntity copyWith({
    int? id,
    String? code,
    String? status,
    DateTime? createdAt,
    DateTime? startTime,
    DateTime? endTime,
    String? userEmail,
    int? stationId,
    String? stationName,
    String? stationAddress,
    VehicleBookingSummary? vehicle,
    String? paymentUrl,
    PayOSPaymentInfoEntity? paymentInfo,
    double? depositAmount,
    double? totalRentAmount,
  }) {
    return ReservationEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      userEmail: userEmail ?? this.userEmail,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      vehicle: vehicle ?? this.vehicle,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      depositAmount: depositAmount ?? this.depositAmount,
      totalRentAmount: totalRentAmount ?? this.totalRentAmount,
    );
  }
}
