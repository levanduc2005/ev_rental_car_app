import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/active_trip/data/models/active_rental_model.dart';

abstract interface class ActiveRentalRemoteDataSource {
  /// Lấy chi tiết đơn thuê theo ID (GET /rentals/me/details/{id})
  Future<ActiveRentalModel> getRentalDetail(int rentalId);

  /// Lấy đơn thuê đang có trạng thái IN_PROGRESS của user (POST /rentals/email)
  Future<ActiveRentalModel?> getCurrentActiveRental({required String email});
}

class ActiveRentalRemoteDataSourceImpl implements ActiveRentalRemoteDataSource {
  const ActiveRentalRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ActiveRentalModel> getRentalDetail(int rentalId) {
    return guardApiCall(() async {
      Response<Map<String, dynamic>> response;
      try {
        response = await _dio.get<Map<String, dynamic>>(
          '/rentals/me/details/$rentalId',
        );
      } on DioException {
        try {
          response = await _dio.get<Map<String, dynamic>>(
            '/rentals/$rentalId/details',
          );
        } on DioException {
          response = await _dio.get<Map<String, dynamic>>('/rentals/$rentalId');
        }
      }
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ParsingException('Không tìm thấy thông tin chuyến đi.');
      }
      return ActiveRentalModel.fromBackendJson(data);
    });
  }

  @override
  Future<ActiveRentalModel?> getCurrentActiveRental({required String email}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/email',
        data: {
          'email': email,
          'status': ['ONGOING', 'IN_PROGRESS'],
          'page': 1,
          'limit': 1,
          'search': '',
        },
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        final content = data['content'];
        if (content is List && content.isNotEmpty) {
          final first = content.first as Map<String, dynamic>;
          final id = (first['id'] as num?)?.toInt();
          if (id != null) {
            // Lấy toàn bộ thông tin chi tiết đầy đủ của đơn thuê
            return getRentalDetail(id);
          }
          return ActiveRentalModel.fromBackendJson(first);
        }
      }
      return null;
    });
  }
}
