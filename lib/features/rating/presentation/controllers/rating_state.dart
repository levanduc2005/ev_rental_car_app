import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';

class RatingState {
  const RatingState({
    this.ratings = const {},
    this.isLoading = false,
    this.isSubmitting = false,
    this.submittingRentalId,
    this.errorMessage,
  });

  /// Map of rentalId -> RatingEntity
  final Map<int, RatingEntity> ratings;
  final bool isLoading;
  final bool isSubmitting;
  final int? submittingRentalId;
  final String? errorMessage;

  RatingEntity? getRatingForRental(int rentalId) => ratings[rentalId];

  bool isRated(int rentalId) => ratings.containsKey(rentalId);

  RatingState copyWith({
    Map<int, RatingEntity>? ratings,
    bool? isLoading,
    bool? isSubmitting,
    int? submittingRentalId,
    String? errorMessage,
    bool clearSubmittingRentalId = false,
    bool clearErrorMessage = false,
  }) {
    return RatingState(
      ratings: ratings ?? this.ratings,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submittingRentalId: clearSubmittingRentalId
          ? null
          : (submittingRentalId ?? this.submittingRentalId),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
