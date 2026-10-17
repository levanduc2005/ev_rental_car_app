import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/rating/data/models/rating_model.dart';

abstract interface class RatingRemoteDataSource {
  Future<RatingModel> submitRating({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  });

  Future<List<RatingModel>> getAllRatings();

  Future<RatingModel> getRatingById(int id);
}

class RatingRemoteDataSourceImpl implements RatingRemoteDataSource {
  const RatingRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<RatingModel> submitRating({
    required int rentalId,
    required int score,
    required String comment,
    int? userId,
  }) {
    return guardApiCall(() async {
      final payload = <String, dynamic>{
        'rentalId': rentalId,
        'score': score,
        'comment': comment,
        'userId': ?userId,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/ratings',
        data: payload,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RatingModel.fromJson(data);
      }
      throw const ParsingException('Dữ liệu đánh giá trả về không hợp lệ.');
    });
  }

  @override
  Future<List<RatingModel>> getAllRatings() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/ratings');
      final data = response.data?['data'];
      if (data is List) {
        return data
            .map((item) => RatingModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return const [];
    });
  }

  @override
  Future<RatingModel> getRatingById(int id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/ratings/$id');
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RatingModel.fromJson(data);
      }
      throw const ParsingException('Không tìm thấy đánh giá.');
    });
  }
}
