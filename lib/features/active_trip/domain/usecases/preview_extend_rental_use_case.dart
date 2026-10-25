import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/active_trip/domain/entities/extend_rental_preview_entity.dart';
import 'package:rental_car/features/active_trip/domain/repositories/active_rental_repository.dart';

class PreviewExtendRentalUseCase {
  const PreviewExtendRentalUseCase(this._repository);

  final ActiveRentalRepository _repository;

  Future<Result<ExtendRentalPreviewEntity>> call({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return _repository.previewExtendRental(
      rentalId: rentalId,
      newReturnTime: newReturnTime,
    );
  }
}
