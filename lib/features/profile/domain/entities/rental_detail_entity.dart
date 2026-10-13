import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';

class RentalDetailEntity {
  const RentalDetailEntity({
    required this.id,
    required this.status,
    this.startTime,
    this.endTime,
    this.rentFee = 0.0,
    this.discountPoint = 0,
    this.createdAt,
    required this.vehicleName,
    this.vehiclePlateNumber,
    this.vehicleImage,
    this.batteryCapacity,
    this.currentBattery,
    this.seatCapacity,
    this.pricePerHour,
    this.pricePerDay,
    this.stationName,
    this.stationAddress,
    this.stationLatitude,
    this.stationLongitude,
    this.reservationCode,
    this.userEmail,
    this.contractStatus,
    this.contractUrl,
    this.rentalDepositAmount = 0.0,
    this.rentalDepositStatus,
    this.reservationDepositAmount = 0.0,
    this.reservationDepositStatus,
    this.checkInChecklist,
    this.checkOutChecklist,
    this.vehicleDamages = const [],
    this.vehicleDamageCost = 0.0,
    this.vehicleDamageImages = const [],
    this.vehicleId,
    this.staffId,
    this.staffName,
    this.staffPhone,
    this.paymentUrl,
  });

  final int id;
  final int? vehicleId;
  final int? staffId;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final double rentFee;
  final int discountPoint;
  final DateTime? createdAt;
  final String vehicleName;
  final String? vehiclePlateNumber;
  final String? vehicleImage;
  final double? batteryCapacity;
  final double? currentBattery;
  final int? seatCapacity;
  final double? pricePerHour;
  final double? pricePerDay;
  final String? stationName;
  final String? stationAddress;
  final double? stationLatitude;
  final double? stationLongitude;
  final String? reservationCode;
  final String? userEmail;
  final String? contractStatus;
  final String? contractUrl;
  final double rentalDepositAmount;
  final String? rentalDepositStatus;
  final double reservationDepositAmount;
  final String? reservationDepositStatus;
  final RentalChecklistEntity? checkInChecklist;
  final RentalChecklistEntity? checkOutChecklist;
  final List<VehicleDamageItemEntity> vehicleDamages;
  final double vehicleDamageCost;
  final List<String> vehicleDamageImages;
  final String? staffName;
  final String? staffPhone;
  final String? paymentUrl;

  bool get isOngoing => status.toUpperCase() == 'ONGOING';
  bool get isConfirm => status.toUpperCase() == 'CONFIRM';
  bool get isPendingFee => status.toUpperCase() == 'PENDING_FEE';
  bool get isChecking => status.toUpperCase() == 'CHECKING';
  bool get isOverdue => status.toUpperCase() == 'OVERDUE';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  double get totalDeposit => rentalDepositAmount + reservationDepositAmount;

  bool get isOverdueTime {
    if (endTime == null) return false;
    return isOngoing && DateTime.now().isAfter(endTime!);
  }
}
