import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/rating/domain/entities/rating_entity.dart';
import 'package:rental_car/features/rating/domain/usecases/get_all_ratings_usecase.dart';
import 'package:rental_car/features/rating/domain/usecases/submit_rating_usecase.dart';
import 'package:rental_car/features/rating/presentation/providers/rating_providers.dart';

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

class RatingController extends Notifier<RatingState> {
  SubmitRatingUseCase get _submitRatingUseCase =>
      ref.read(submitRatingUseCaseProvider);
  GetAllRatingsUseCase get _getAllRatingsUseCase =>
      ref.read(getAllRatingsUseCaseProvider);

  @override
  RatingState build() {
    Future.microtask(() => loadRatings());
    return const RatingState();
  }

  Future<void> loadRatings() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    final result = await _getAllRatingsUseCase();
    result.when(
      ok: (ratingsList) {
        final map = <int, RatingEntity>{};
        for (final r in ratingsList) {
          map[r.rentalId] = r;
        }
        state = state.copyWith(ratings: map, isLoading: false);
      },
      err: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<Result<RatingEntity>> submitRating({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      submittingRentalId: rentalId,
      clearErrorMessage: true,
    );

    final result = await _submitRatingUseCase(
      rentalId: rentalId,
      score: score,
      comment: comment,
      userId: userId,
    );

    result.when(
      ok: (rating) {
        final updatedMap = Map<int, RatingEntity>.from(state.ratings);
        updatedMap[rentalId] = rating;
        state = state.copyWith(
          ratings: updatedMap,
          isSubmitting: false,
          clearSubmittingRentalId: true,
        );
      },
      err: (failure) {
        state = state.copyWith(
          isSubmitting: false,
          clearSubmittingRentalId: true,
          errorMessage: failure.message,
        );
      },
    );

    return result;
  }
}
