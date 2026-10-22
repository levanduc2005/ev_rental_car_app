import 'package:rental_car/core/error/failure.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/staff/domain/entities/renter_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class GetRenterByEmailUseCase {
  const GetRenterByEmailUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<RenterEntity>> call(String email) {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) {
      return Future.value(
        const Result.err(
          DataFailure(message: 'Vui lòng nhập địa chỉ email hợp lệ.'),
        ),
      );
    }
    return _repository.getRenterByEmail(cleanEmail);
  }
}
