import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/booking/domain/repositories/booking_repository.dart';
import 'package:rental_car/features/booking/domain/entities/bank_app_item.dart';

/// UseCase lấy danh sách toàn bộ ngân hàng được hỗ trợ từ API VietQR
class GetSupportedBanksUseCase {
  const GetSupportedBanksUseCase(this._repository);

  final BookingRepository _repository;

  Future<Result<List<BankAppItem>>> call() {
    return _repository.getSupportedBanks();
  }
}
