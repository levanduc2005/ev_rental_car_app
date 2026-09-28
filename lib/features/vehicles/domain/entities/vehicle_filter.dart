/// Lớp thực thể lưu trạng thái bộ lọc xe (Domain)
class VehicleFilter {
  const VehicleFilter({
    this.rentalType = 'Tất cả',
    this.seats = 'Tất cả',
    this.brand = 'Tất cả',
    this.fuelType = 'Tất cả',
    this.carType = 'Tất cả',
    this.sort = 'Giá thấp đến cao',
    this.startTime,
    this.endTime,
    this.hourPackage,
    this.city,
    this.location,
    this.stationId,
  });

  final String rentalType;
  final String seats;
  final String brand;
  final String fuelType;
  final String carType;
  final String sort;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? hourPackage;
  final String? city;
  final String? location;
  final int? stationId;

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
    return '$sStr đến $eStr ($durationUnitLabel)';
  }

  VehicleFilter copyWith({
    String? rentalType,
    String? seats,
    String? brand,
    String? fuelType,
    String? carType,
    String? sort,
    DateTime? startTime,
    DateTime? endTime,
    int? hourPackage,
    String? city,
    String? location,
    int? stationId,
  }) {
    return VehicleFilter(
      rentalType: rentalType ?? this.rentalType,
      seats: seats ?? this.seats,
      brand: brand ?? this.brand,
      fuelType: fuelType ?? this.fuelType,
      carType: carType ?? this.carType,
      sort: sort ?? this.sort,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      hourPackage: hourPackage ?? this.hourPackage,
      city: city ?? this.city,
      location: location ?? this.location,
      stationId: stationId ?? this.stationId,
    );
  }
}
