import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';

class RentalOverviewEntity {
  const RentalOverviewEntity({
    required this.rentalId,
    this.vehicleId,
    this.vehicleName,
    this.vehiclePlateNumber,
    this.stationName,
    this.stationAddress,
    this.stationLatitude,
    this.stationLongitude,
    this.checkListFee = 0.0,
    this.reservationDeposit = 0.0,
    this.rentalDeposit = 0.0,
    this.vehicleDamages = const [],
    this.vehicleDamageFee = 0.0,
    this.vehicleDamageImages = const [],
    this.refundEligible = true,
  });

  final int rentalId;
  final int? vehicleId;
  final String? vehicleName;
  final String? vehiclePlateNumber;
  final String? stationName;
  final String? stationAddress;
  final double? stationLatitude;
  final double? stationLongitude;
  final double checkListFee; // Phí phạt trễ giờ + phí sạc bù pin
  final double reservationDeposit;
  final double rentalDeposit;
  final List<VehicleDamageItemEntity> vehicleDamages;
  final double vehicleDamageFee; // Phí sửa chữa hư hại từ VehicleLog
  final List<String> vehicleDamageImages;
  final bool refundEligible;

  double get totalDeposits => reservationDeposit + rentalDeposit;
  double get totalCharges => checkListFee + vehicleDamageFee;

  /// Số tiền quyết toán:
  /// Nếu >= 0: Tiền hoàn cọc thực nhận
  /// Nếu < 0: Tiền phạt vượt cọc cần thanh toán bù
  double get balance => totalDeposits - totalCharges;

  bool get requiresAdditionalPayment => balance < 0;

  double get refundAmount => balance >= 0 ? balance : 0.0;
  double get additionalPaymentAmount => balance < 0 ? balance.abs() : 0.0;
}
