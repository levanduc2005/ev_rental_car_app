import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_checklist_entity.dart';
import 'package:rental_car/features/staff/domain/repositories/staff_repository.dart';

class GetStaffChecklistsUseCase {
  const GetStaffChecklistsUseCase(this._repository);

  final StaffRepository _repository;

  Future<Result<List<RentalChecklistEntity>>> call({
    String? keyword,
    String? type,
  }) {
    return _repository.getChecklists(keyword: keyword, type: type);
  }
}
