import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

/// Kết quả phân trang danh sách xe từ API /vehicles/filter/available
class PaginatedVehicles {
  const PaginatedVehicles({
    required this.vehicles,
    required this.currentPage,
    required this.totalPages,
  });

  final List<VehicleEntity> vehicles;
  final int currentPage;
  final int totalPages;

  /// Có thêm trang tiếp theo không?
  bool get hasNextPage => currentPage < totalPages;
}
