import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/home/data/models/station_model.dart';
import 'package:rental_car/features/home/data/models/vehicle_model.dart';

abstract interface class HomeRemoteDataSource {
  /// Lấy danh sách 16 xe hiển thị trang chủ từ API
  Future<List<VehicleModel>> getHomeVehicles();

  /// Lấy danh sách tên các hãng xe từ API
  Future<List<String>> getVehicleBrands();

  /// Lấy danh sách trạm xe theo tên thành phố ("Hà Nội" hoặc "Hồ Chí Minh")
  Future<List<StationModel>> getStationsByCity(String city);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<VehicleModel>> getHomeVehicles() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/vehicles/home');
      final data = response.data?['data'];
      if (data == null) {
        throw const ParsingException('Không tìm thấy dữ liệu danh sách xe.');
      }

      if (data is! List) {
        throw const ParsingException('Dữ liệu xe không đúng định dạng mảng.');
      }

      return data
          .map((item) => VehicleModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<String>> getVehicleBrands() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/vehicles/brand');
      final data = response.data?['data'];
      if (data == null) {
        return const <String>[];
      }

      if (data is! List) {
        throw const ParsingException(
          'Dữ liệu thương hiệu không đúng định dạng.',
        );
      }

      return data.map((item) => item.toString()).toList();
    });
  }

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
