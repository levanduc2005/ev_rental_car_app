import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/active_rental_entity.dart';

abstract interface class ActiveRentalRepository {
  /// Lấy chi tiết đơn thuê xe theo ID (GET /api/rentals/me/details/{id})
  Future<Result<ActiveRentalEntity>> getActiveRentalDetail(int rentalId);

  /// Lấy đơn thuê xe đang hoạt động (IN_PROGRESS) của người dùng hiện tại
  Future<Result<ActiveRentalEntity?>> getCurrentActiveRental({
    required String email,
  });
}
