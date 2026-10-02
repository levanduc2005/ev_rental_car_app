/// Lớp thực thể lưu trạng thái bộ lọc xe (Domain)
class VehicleFilter {
  const VehicleFilter({
    this.seats = 'Tất cả',
    this.brand = 'Tất cả',
    this.carType = 'Tất cả',
    this.priceRange = 'Tất cả',
    this.sort = 'Giá thấp đến cao',
    this.startTime,
    this.endTime,
    this.hourPackage,
    this.city,
    this.location,
    this.stationId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.rentalType = 'Tất cả',
    this.fuelType = 'Tất cả',
  });

  final String seats;
  final String brand;
  final String carType;
  final String priceRange;
  final String sort;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? hourPackage;
  final String? city;
  final String? location;
  final int? stationId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;

  // Giữ lại để tương thích ngược nếu còn widget tham chiếu
  final String rentalType;
  final String fuelType;

  /// Giá trị minPrice tính từ bộ lọc mức giá
  double? get effectiveMinPrice {
    if (minPrice != null) return minPrice;
    switch (priceRange) {
      case '500K - 1 Triệu':
        return 500000.0;
      case 'Trên 1 Triệu':
        return 1000000.0;
      default:
        return null;
    }
  }

  /// Giá trị maxPrice tính từ bộ lọc mức giá
  double? get effectiveMaxPrice {
    if (maxPrice != null) return maxPrice;
    switch (priceRange) {
      case 'Dưới 500K':
        return 500000.0;
      case '500K - 1 Triệu':
        return 1000000.0;
      default:
        return null;
    }
  }

  /// Tính tổng số giờ thuê dựa trên gói giờ hoặc khoảng thời gian bắt đầu - kết thúc
  int get durationHours {
    if (hourPackage != null && hourPackage! > 0) {
      return hourPackage!;
    }
    if (startTime != null && endTime != null) {
      final diff = endTime!.difference(startTime!).inHours;
      return diff > 0 ? diff : 4;
    }
    return 24; // Mặc định 24h nếu chưa chọn
  }

  /// Trả về đơn vị hiển thị giá phù hợp: '4 giờ', '8 giờ', '12 giờ', 'ngày',...
  String get durationUnitLabel {
    final hours = durationHours;
    if (hours <= 4) return '4 giờ';
    if (hours <= 8) return '8 giờ';
    if (hours <= 12) return '12 giờ';
    if (hours < 24) return '$hours giờ';
    final days = hours ~/ 24;
    final rem = hours % 24;
    if (days == 1 && rem == 0) return 'ngày';
    if (rem == 0) return '$days ngày';
    return '$days ngày $rem giờ';
  }

  /// Chuỗi hiển thị khoảng thời gian nhận - trả
  String get formattedTimeRange {
    if (startTime == null || endTime == null) {
      return 'Gói $durationUnitLabel';
    }
    String pad(int n) => n.toString().padLeft(2, '0');
    final s = startTime!;
    final e = endTime!;
    final sStr =
        '${pad(s.hour)}:${pad(s.minute)}, ${pad(s.day)}/${pad(s.month)}';
    final eStr =
        '${pad(e.hour)}:${pad(e.minute)}, ${pad(e.day)}/${pad(e.month)}';
    return '$sStr → $eStr';
  }

  VehicleFilter copyWith({
    String? seats,
    String? brand,
    String? carType,
    String? priceRange,
    String? sort,
    DateTime? startTime,
    DateTime? endTime,
    int? hourPackage,
    String? city,
    String? location,
    int? stationId,
    bool clearStation = false,
    String? search,
    bool clearSearch = false,
    double? minPrice,
    double? maxPrice,
    String? rentalType,
    String? fuelType,
  }) {
    return VehicleFilter(
      seats: seats ?? this.seats,
      brand: brand ?? this.brand,
      carType: carType ?? this.carType,
      priceRange: priceRange ?? this.priceRange,
      sort: sort ?? this.sort,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hourPackage: hourPackage ?? this.hourPackage,
      city: city ?? this.city,
      location: location ?? this.location,
      stationId: clearStation ? null : (stationId ?? this.stationId),
      search: clearSearch ? null : (search ?? this.search),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      rentalType: rentalType ?? this.rentalType,
      fuelType: fuelType ?? this.fuelType,
    );
  }
}
