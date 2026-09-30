import 'package:dio/dio.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/vehicles/data/models/station_model.dart';

abstract interface class HomeRemoteDataSource {
  /// Lấy danh sách trạm xe theo tên thành phố ("Hà Nội" hoặc "Hồ Chí Minh")
  Future<List<StationModel>> getStationsByCity(String city);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<StationModel>> getStationsByCity(String city) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/stations/city',
        queryParameters: {'city': city},
      );
      final data = response.data?['data'];
      if (data == null || data is! List) {
        return const <StationModel>[];
      }

      return data
          .map((item) => StationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }
}
