import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_car/core/providers/core_providers.dart';
import 'package:rental_car/features/rating/data/datasources/rating_remote_data_source.dart';
import 'package:rental_car/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:rental_car/features/rating/domain/repositories/rating_repository.dart';
import 'package:rental_car/features/rating/domain/usecases/get_all_ratings_usecase.dart';
import 'package:rental_car/features/rating/domain/usecases/submit_rating_usecase.dart';
import 'package:rental_car/features/rating/presentation/providers/rating_controller.dart';

// --- Data Layer Providers ---
final ratingRemoteDataSourceProvider = Provider<RatingRemoteDataSource>((ref) {
  return RatingRemoteDataSourceImpl(dio: ref.watch(dioProvider));
});

final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepositoryImpl(
    remoteDataSource: ref.watch(ratingRemoteDataSourceProvider),
  );
});

// --- Domain Layer UseCase Providers ---
final submitRatingUseCaseProvider = Provider<SubmitRatingUseCase>((ref) {
  return SubmitRatingUseCase(ref.watch(ratingRepositoryProvider));
});

final getAllRatingsUseCaseProvider = Provider<GetAllRatingsUseCase>((ref) {
  return GetAllRatingsUseCase(ref.watch(ratingRepositoryProvider));
});

// --- Presentation Layer Controller Provider ---
final ratingControllerProvider =
    NotifierProvider<RatingController, RatingState>(RatingController.new);
