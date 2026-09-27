class VehicleBookingSummary {
  const VehicleBookingSummary({
    required this.id,
    required this.name,
    this.plateNumber,
    this.imageUrl,
    this.batteryPercentage,
    this.pricePerHour,
    this.depositFee,
    this.stationId,
    this.stationName,
    this.stationAddress,
    String? location,
    int? seats,
    String? transmission,
    String? fuelType,
    int? batteryCapacity,
    this.price4h = 0,
    this.price8h = 0,
    this.price12h = 0,
    this.price24h = 0,
  })  : _location = location,
        _seats = seats,
        _transmission = transmission,
        _fuelType = fuelType,
        _batteryCapacity = batteryCapacity;

  final int id;
  final String name;
  final String? plateNumber;
  final String? imageUrl;
  final int? batteryPercentage;
  final double? pricePerHour;
  final double? depositFee;
  final int? stationId;
  final String? stationName;
  final String? stationAddress;
  final String? _location;
  final int? _seats;
  final String? _transmission;
  final String? _fuelType;
  final int? _batteryCapacity;
  final int price4h;
  final int price8h;
  final int price12h;
  final int price24h;

  String get location =>
      _location ?? stationAddress ?? stationName ?? 'Trạm xe e-Motion';
  int get seats => _seats ?? 4;
  String get transmission => _transmission ?? 'Số tự động';
  String get fuelType => _fuelType ?? 'Điện';
  int get batteryCapacity => _batteryCapacity ?? 0;

  VehicleBookingSummary copyWith({
    int? id,
    String? name,
    String? plateNumber,
    String? imageUrl,
    int? batteryPercentage,
    double? pricePerHour,
    double? depositFee,
    int? stationId,
    String? stationName,
    String? stationAddress,
    String? location,
    int? seats,
    String? transmission,
    String? fuelType,
    int? batteryCapacity,
    int? price4h,
    int? price8h,
    int? price12h,
    int? price24h,
  }) {
    return VehicleBookingSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      plateNumber: plateNumber ?? this.plateNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      batteryPercentage: batteryPercentage ?? this.batteryPercentage,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      depositFee: depositFee ?? this.depositFee,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      location: location ?? _location,
      seats: seats ?? _seats,
      transmission: transmission ?? _transmission,
      fuelType: fuelType ?? _fuelType,
      batteryCapacity: batteryCapacity ?? _batteryCapacity,
      price4h: price4h ?? this.price4h,
      price8h: price8h ?? this.price8h,
      price12h: price12h ?? this.price12h,
      price24h: price24h ?? this.price24h,
    );
  }
}
