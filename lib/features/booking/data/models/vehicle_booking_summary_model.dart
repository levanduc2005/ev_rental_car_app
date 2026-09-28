import 'package:rental_car/features/booking/domain/entities/vehicle_booking_summary.dart';

class VehicleBookingSummaryModel {
  const VehicleBookingSummaryModel({
    required this.id,
    required this.name,
    this.plateNumber,
    this.imageUrl,
    this.batteryPercentage,
    this.pricePerHour,
    this.depositFee,
    this.holdFee,
    this.stationId,
    this.stationName,
    this.stationAddress,
    this.location,
    this.seats = 4,
    this.transmission = 'Số tự động',
    this.fuelType = 'Điện',
    this.batteryCapacity = 0,
    this.price4h = 0,
    this.price8h = 0,
    this.price12h = 0,
    this.price24h = 0,
  });

  final int id;
  final String name;
  final String? plateNumber;
  final String? imageUrl;
  final int? batteryPercentage;
  final double? pricePerHour;
  final double? depositFee;
  final double? holdFee;
  final int? stationId;
  final String? stationName;
  final String? stationAddress;
  final String? location;
  final int seats;
  final String transmission;
  final String fuelType;
  final int batteryCapacity;
  final int price4h;
  final int price8h;
  final int price12h;
  final int price24h;

  factory VehicleBookingSummaryModel.fromJson(Map<String, dynamic> json) {
    String? firstImage;
    final images = json['images'];
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      if (first is Map<String, dynamic>) {
        firstImage = first['url'] as String?;
      } else if (first is String) {
        firstImage = first;
      }
    }

    final station = json['station'];
    int? stationId;
    String? stationName;
    String? stationAddress;
    if (station is Map<String, dynamic>) {
      stationId = station['id'] as int?;
      stationName = station['name'] as String?;
      stationAddress = station['address'] as String?;
    } else if (json['stationId'] != null) {
      stationId = json['stationId'] as int?;
      stationName = json['stationName'] as String?;
    }

    final priceDto = json['vehiclePriceDto'] as Map<String, dynamic>?;
    final p4h =
        (priceDto?['rentalRate_4Hours'] as num?)?.toInt() ??
        (json['pricePer4Hours'] as num?)?.toInt() ??
        0;
    final p8h =
        (priceDto?['rentalRate_8Hours'] as num?)?.toInt() ??
        (json['pricePer8Hours'] as num?)?.toInt() ??
        0;
    final p12h =
        (priceDto?['rentalRate_12Hours'] as num?)?.toInt() ??
        (json['pricePer12Hours'] as num?)?.toInt() ??
        0;
    final p24h =
        (priceDto?['rentalRate_24Hours'] as num?)?.toInt() ??
        (json['pricePer24Hours'] as num?)?.toInt() ??
        (json['pricePerDay'] as num?)?.toInt() ??
        0;

    final calculatedHourly = p4h > 0
        ? (p4h / 4)
        : ((json['pricePerHour'] as num?)?.toDouble() ?? 0.0);

    return VehicleBookingSummaryModel(
      id: json['id'] as int? ?? 0,
      name:
          json['name'] as String? ??
          (json['brand'] != null
              ? '${json['brand']} ${json['model'] ?? ''}'.trim()
              : 'Xe điện'),
      plateNumber:
          json['plateNumber'] as String? ?? json['licensePlate'] as String?,
      imageUrl: firstImage ?? json['imageUrl'] as String?,
      batteryPercentage:
          (json['batteryLevel'] as num?)?.toInt() ??
          (json['batteryPercentage'] as num?)?.toInt() ??
          100,
      pricePerHour: calculatedHourly,
      depositFee: (json['depositFee'] as num?)?.toDouble(),
      holdFee:
          (json['holdFee'] as num?)?.toDouble() ??
          (json['holdFeeValue'] as num?)?.toDouble(),
      stationId: stationId,
      stationName: stationName,
      stationAddress: stationAddress,
      location: stationAddress ?? stationName ?? 'Trạm xe e-Motion',
      seats: (json['seats'] as num?)?.toInt() ?? 4,
      transmission: json['transmission'] as String? ?? 'Số tự động',
      fuelType: json['fuelType'] as String? ?? 'Điện',
      batteryCapacity: (json['batteryCapacity'] as num?)?.toInt() ?? 0,
      price4h: p4h,
      price8h: p8h,
      price12h: p12h,
      price24h: p24h,
    );
  }

  VehicleBookingSummary toEntity() {
    return VehicleBookingSummary(
      id: id,
      name: name,
      plateNumber: plateNumber,
      imageUrl: imageUrl,
      batteryPercentage: batteryPercentage,
      pricePerHour: pricePerHour,
      depositFee: depositFee,
      holdFee: holdFee,
      stationId: stationId,
      stationName: stationName,
      stationAddress: stationAddress,
      location: location,
      seats: seats,
      transmission: transmission,
      fuelType: fuelType,
      batteryCapacity: batteryCapacity,
      price4h: price4h,
      price8h: price8h,
      price12h: price12h,
      price24h: price24h,
    );
  }
}
