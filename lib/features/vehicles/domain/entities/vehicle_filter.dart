/// Lớp thực thể lưu trạng thái bộ lọc xe (Domain)
class VehicleFilter {
  const VehicleFilter({
    this.rentalType = 'Tất cả',
    this.seats = 'Tất cả',
    this.brand = 'Tất cả',
    this.fuelType = 'Tất cả',
    this.carType = 'Tất cả',
    this.sort = 'Giá thấp đến cao',
  });

  final String rentalType;
  final String seats;
  final String brand;
  final String fuelType;
  final String carType;
  final String sort;

  VehicleFilter copyWith({
    String? rentalType,
    String? seats,
    String? brand,
    String? fuelType,
    String? carType,
    String? sort,
  }) {
    return VehicleFilter(
      rentalType: rentalType ?? this.rentalType,
      seats: seats ?? this.seats,
      brand: brand ?? this.brand,
      fuelType: fuelType ?? this.fuelType,
      carType: carType ?? this.carType,
      sort: sort ?? this.sort,
    );
  }
}
