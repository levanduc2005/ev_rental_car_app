import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/checkout/domain/entities/rental_overview_entity.dart';
import 'package:rental_car/features/checkout/domain/repositories/checkout_repository.dart';

class GetRentalOverviewUseCase {
  const GetRentalOverviewUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Result<RentalOverviewEntity>> call(int rentalId) {
    return _repository.getRentalOverview(rentalId);
  }
}
