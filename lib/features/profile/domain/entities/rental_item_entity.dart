class RentalItemEntity {
  const RentalItemEntity({
    required this.id,
    required this.vehicleName,
    this.vehicleImage,
    this.stationName,
    required this.status,
    this.createdAt,
    this.paymentUrl,
  });

  final int id;
  final String vehicleName;
  final String? vehicleImage;
  final String? stationName;
  final String status;
  final DateTime? createdAt;
  final String? paymentUrl;
}
