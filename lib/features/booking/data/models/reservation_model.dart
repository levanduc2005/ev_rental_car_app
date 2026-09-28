import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/booking/data/models/vehicle_booking_summary_model.dart';
import 'package:rental_car/features/booking/domain/entities/reservation_entity.dart';
import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

class ReservationModel {
  const ReservationModel({
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
    this.vehicleName,
    this.vehicleImage,
    this.paymentUrl,
    this.paymentInfo,
    this.depositAmount,
    this.totalRentAmount,
  });

  final int id;
  final String code;
  final String status;
  final String? createdAt;
  final String? startTime;
  final String? endTime;
  final String? userEmail;
  final int? stationId;
  final String? stationName;
  final String? stationAddress;
  final VehicleBookingSummaryModel? vehicle;
  final String? vehicleName;
  final String? vehicleImage;
  final String? paymentUrl;
  final PayOSPaymentInfoModel? paymentInfo;
  final double? depositAmount;
  final double? totalRentAmount;

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    // 1. Trường hợp bọc trong response createReservation Map: { "reservation": {...}, "vnpayUrl": "...", "payos": {...}, "deposit": {...} }
    if (json.containsKey('reservation') &&
        json['reservation'] is Map<String, dynamic>) {
      final resJson = json['reservation'] as Map<String, dynamic>;
      final vnpayUrl = json['vnpayUrl'] as String?;
      final depositJson = json['deposit'] as Map<String, dynamic>?;
      final depositAmount = (depositJson?['amount'] as num?)?.toDouble();

      PayOSPaymentInfoModel? paymentInfo;
      if (json.containsKey('payos') && json['payos'] is Map<String, dynamic>) {
        paymentInfo = PayOSPaymentInfoModel.fromJson(
          json['payos'] as Map<String, dynamic>,
        );
      }

      return ReservationModel.fromJson(resJson).copyWith(
        paymentUrl: vnpayUrl,
        paymentInfo: paymentInfo,
        depositAmount: depositAmount ?? paymentInfo?.amount,
      );
    }

    VehicleBookingSummaryModel? parsedVehicle;
    if (json['vehicle'] is Map<String, dynamic>) {
      parsedVehicle = VehicleBookingSummaryModel.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      );
    }

    final code = json['code']?.toString() ?? json['id']?.toString() ?? '';
    final paymentUrl = json['paymentUrl'] as String?;
    PayOSPaymentInfoModel? paymentInfo;
    if (json.containsKey('payos') && json['payos'] is Map<String, dynamic>) {
      paymentInfo = PayOSPaymentInfoModel.fromJson(
        json['payos'] as Map<String, dynamic>,
      );
    }

    final station = json['station'] as Map<String, dynamic>?;
    final stationAddress =
        json['stationAddress'] as String? ?? station?['address'] as String?;
    final depositAmount =
        (json['depositAmount'] as num?)?.toDouble() ??
        (json['depositFee'] as num?)?.toDouble();
    final totalRentAmount =
        (json['totalRentAmount'] as num?)?.toDouble() ??
        (json['totalAmount'] as num?)?.toDouble();

    return ReservationModel(
      id: json['id'] as int? ?? 0,
      code: code,
      status: json['status'] as String? ?? 'PENDING',
      createdAt: json['createdAt'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      userEmail: json['userEmail'] as String?,
      stationId: json['stationId'] as int?,
      stationName: json['stationName'] as String?,
      stationAddress: stationAddress,
      vehicle: parsedVehicle,
      vehicleName: json['vehicleName'] as String?,
      vehicleImage: json['vehicleImage'] as String?,
      paymentUrl: paymentUrl,
      paymentInfo: paymentInfo,
      depositAmount: depositAmount,
      totalRentAmount: totalRentAmount,
    );
  }

  ReservationModel copyWith({
    int? id,
    String? code,
    String? status,
    String? createdAt,
    String? startTime,
    String? endTime,
    String? userEmail,
    int? stationId,
    String? stationName,
    String? stationAddress,
    VehicleBookingSummaryModel? vehicle,
    String? vehicleName,
    String? vehicleImage,
    String? paymentUrl,
    PayOSPaymentInfoModel? paymentInfo,
    double? depositAmount,
    double? totalRentAmount,
  }) {
    return ReservationModel(
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
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleImage: vehicleImage ?? this.vehicleImage,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      depositAmount: depositAmount ?? this.depositAmount,
      totalRentAmount: totalRentAmount ?? this.totalRentAmount,
    );
  }

  ReservationEntity toEntity() {
    return ReservationEntity(
      id: id,
      code: code,
      status: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      startTime: startTime != null ? DateTime.tryParse(startTime!) : null,
      endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
      userEmail: userEmail,
      stationId: stationId,
      stationName: stationName,
      stationAddress: stationAddress,
      vehicle:
          vehicle?.toEntity() ??
          (vehicleName != null
              ? VehicleBookingSummary(
                  id: 0,
                  name: vehicleName!,
                  imageUrl: vehicleImage,
                  stationName: stationName,
                  stationAddress: stationAddress,
                )
              : null),
      paymentUrl: paymentUrl,
      paymentInfo: paymentInfo?.toEntity(),
      depositAmount: depositAmount,
      totalRentAmount: totalRentAmount,
    );
  }
}
