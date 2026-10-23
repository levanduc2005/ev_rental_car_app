import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/checkout/domain/entities/vehicle_damage_item_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_detail_entity.dart';

class RentalDetailModel {
  const RentalDetailModel({
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
    this.reservationId,
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
    this.canCheckIn = false,
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
  final int? reservationId;
  final String? reservationCode;
  final String? userEmail;
  final String? contractStatus;
  final String? contractUrl;
  final double rentalDepositAmount;
  final String? rentalDepositStatus;
  final double reservationDepositAmount;
  final String? reservationDepositStatus;
  final RentalChecklistModel? checkInChecklist;
  final RentalChecklistModel? checkOutChecklist;
  final List<VehicleDamageItemEntity> vehicleDamages;
  final double vehicleDamageCost;
  final List<String> vehicleDamageImages;
  final String? staffName;
  final String? staffPhone;
  final String? paymentUrl;
  final bool canCheckIn;

  factory RentalDetailModel.fromJson(Map<String, dynamic> json) {
    // 1. Thông tin xe & trạm
    final v = json['vehicle'] as Map<String, dynamic>?;
    final vehicleName = (v?['name'] as String?) ?? 'Xe điện e-Motion';
    final plateNumber = v?['plateNumber'] as String?;
    final batteryCap = (v?['batteryCapacity'] as num?)?.toDouble();
    final curBattery = (v?['currentBattery'] as num?)?.toDouble();
    final seats = v?['seatCapacity'] as int?;
    final pPerHour = (v?['pricePerHour'] as num?)?.toDouble();
    final pPerDay = (v?['pricePerDay'] as num?)?.toDouble();

    // Ảnh xe
    String? vImage;
    final rawImgs = v?['images'];
    if (rawImgs is List && rawImgs.isNotEmpty) {
      final imgsList = rawImgs.cast<dynamic>();
      final mainImg = imgsList.firstWhere(
        (img) => img is Map && img['main'] == true,
        orElse: () => imgsList.first,
      );
      if (mainImg is Map) {
        vImage = mainImg['url'] as String? ?? mainImg['imgUrl'] as String?;
      }
    }

    // Trạm
    final s = v?['station'] as Map<String, dynamic>?;
    final sName = s?['name'] as String?;
    final sAddress = s?['address'] as String?;
    final sLat = (s?['latitude'] as num?)?.toDouble();
    final sLng = (s?['longitude'] as num?)?.toDouble();

    // 2. Tiền cọc
    final rd = json['rentalDeposit'] as Map<String, dynamic>?;
    final rdAmount = (rd?['amount'] as num?)?.toDouble() ?? 0.0;
    final rdStatus = rd?['status'] as String?;

    final rsd = json['reservationDeposit'] as Map<String, dynamic>?;
    final rsdAmount = (rsd?['amount'] as num?)?.toDouble() ?? 0.0;
    final rsdStatus = rsd?['status'] as String?;

    // 3. Biên bản kiểm tra CHECK_IN & CHECK_OUT
    RentalChecklistModel? checkIn;
    RentalChecklistModel? checkOut;
    final cLists = json['rentalCheckLists'] as List?;
    if (cLists != null) {
      for (final c in cLists) {
        if (c is Map<String, dynamic>) {
          final model = RentalChecklistModel.fromJson(c);
          if (model.type == 'CHECK_IN') {
            checkIn = model;
          } else if (model.type == 'CHECK_OUT') {
            checkOut = model;
          }
        }
      }
    }

    // 4. Biên bản thiệt hại xe (VehicleLog)
    Map<String, dynamic>? vl = json['vehicleLog'] as Map<String, dynamic>?;
    if (vl == null) {
      final vls = json['vehicleLogs'] as List?;
      if (vls != null && vls.isNotEmpty && vls.first is Map<String, dynamic>) {
        vl = vls.first as Map<String, dynamic>;
      }
    }

    double dmgCost =
        (json['vehicleDamageFee'] as num?)?.toDouble() ??
        (json['vehicleDamageCost'] as num?)?.toDouble() ??
        (vl?['cost'] as num?)?.toDouble() ??
        0.0;
    final damages = <VehicleDamageItemEntity>[];
    final dmgImgs = <String>[];

    if (vl != null) {
      final items = vl['repairItems'] as List?;
      if (items != null) {
        for (final item in items) {
          if (item is Map<String, dynamic>) {
            damages.add(
              VehicleDamageItemEntity(
                description:
                    item['description'] as String? ?? 'Hư hại phụ tùng',
                cost: (item['cost'] as num?)?.toDouble() ?? 0.0,
              ),
            );
          }
        }
      }

      final rawImgs = vl['imgs'] as List?;
      if (rawImgs != null) {
        for (final img in rawImgs) {
          if (img is String && img.trim().isNotEmpty) {
            dmgImgs.add(img.trim());
          }
        }
      }
    }

    // Nếu có danh sách vehicleDamages trực tiếp từ backend
    final directDamages = json['vehicleDamages'] as List?;
    if (directDamages != null && damages.isEmpty) {
      for (final item in directDamages) {
        if (item is Map<String, dynamic>) {
          damages.add(
            VehicleDamageItemEntity(
              description: item['description'] as String? ?? 'Hư hại phụ tùng',
              cost: (item['cost'] as num?)?.toDouble() ?? 0.0,
            ),
          );
        }
      }
    }

    if (dmgCost == 0.0 && damages.isNotEmpty) {
      dmgCost = damages.fold(0.0, (acc, item) => acc + item.cost);
    }

    // 5. Nhân viên phụ trách
    final staff = json['staff'] as Map<String, dynamic>?;
    final staffId = (staff?['id'] as num?)?.toInt();
    final staffName = staff?['name'] as String?;
    final staffPhone = staff?['phone'] as String?;

    final vehicleId =
        (v?['id'] as num?)?.toInt() ?? (json['vehicleId'] as num?)?.toInt();

    final res = json['reservation'] as Map<String, dynamic>?;
    final resId =
        (res?['id'] as num?)?.toInt() ??
        (json['reservationId'] as num?)?.toInt();
    final resCode =
        (res?['code'] as String?) ?? (json['reservationCode'] as String?);

    return RentalDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      vehicleId: vehicleId,
      staffId: staffId,
      status:
          (json['status'] ?? json['rentalStatus'] ?? json['rental_status'])
              as String? ??
          'ONGOING',
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'] as String)
          : null,
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime'] as String)
          : null,
      rentFee: (json['rentFee'] as num?)?.toDouble() ?? 0.0,
      discountPoint: (json['discountPoint'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      vehicleName: vehicleName,
      vehiclePlateNumber: plateNumber,
      vehicleImage: vImage,
      batteryCapacity: batteryCap,
      currentBattery: curBattery,
      seatCapacity: seats,
      pricePerHour: pPerHour,
      pricePerDay: pPerDay,
      stationName: sName,
      stationAddress: sAddress,
      stationLatitude: sLat,
      stationLongitude: sLng,
      reservationId: resId,
      reservationCode: resCode,
      userEmail: json['userEmail'] as String?,
      contractStatus: json['contractStatus'] as String?,
      contractUrl: json['contractUrl'] as String?,
      rentalDepositAmount: rdAmount,
      rentalDepositStatus: rdStatus,
      reservationDepositAmount: rsdAmount,
      reservationDepositStatus: rsdStatus,
      checkInChecklist: checkIn,
      checkOutChecklist: checkOut,
      vehicleDamages: damages,
      vehicleDamageCost: dmgCost,
      vehicleDamageImages: dmgImgs,
      staffName: staffName,
      staffPhone: staffPhone,
      paymentUrl: json['paymentUrl'] as String?,
      canCheckIn: json['canCheckIn'] as bool? ?? false,
    );
  }

  RentalDetailEntity toEntity() {
    return RentalDetailEntity(
      id: id,
      vehicleId: vehicleId,
      staffId: staffId,
      status: status,
      startTime: startTime,
      endTime: endTime,
      rentFee: rentFee,
      discountPoint: discountPoint,
      createdAt: createdAt,
      vehicleName: vehicleName,
      vehiclePlateNumber: vehiclePlateNumber,
      vehicleImage: vehicleImage,
      batteryCapacity: batteryCapacity,
      currentBattery: currentBattery,
      seatCapacity: seatCapacity,
      pricePerHour: pricePerHour,
      pricePerDay: pricePerDay,
      stationName: stationName,
      stationAddress: stationAddress,
      stationLatitude: stationLatitude,
      stationLongitude: stationLongitude,
      reservationId: reservationId,
      reservationCode: reservationCode,
      userEmail: userEmail,
      contractStatus: contractStatus,
      contractUrl: contractUrl,
      rentalDepositAmount: rentalDepositAmount,
      rentalDepositStatus: rentalDepositStatus,
      reservationDepositAmount: reservationDepositAmount,
      reservationDepositStatus: reservationDepositStatus,
      checkInChecklist: checkInChecklist,
      checkOutChecklist: checkOutChecklist,
      vehicleDamages: vehicleDamages,
      vehicleDamageCost: vehicleDamageCost,
      vehicleDamageImages: vehicleDamageImages,
      staffName: staffName,
      staffPhone: staffPhone,
      paymentUrl: paymentUrl,
      canCheckIn: canCheckIn,
    );
  }
}
