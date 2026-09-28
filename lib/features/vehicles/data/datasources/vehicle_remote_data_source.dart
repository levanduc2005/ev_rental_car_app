import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';

abstract interface class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles({VehicleFilter? filter});
  Future<VehicleModel> getVehicleDetail(String id);
  Future<List<String>> getVehicleBrands();
  Future<List<String>> getVehicleCategories();
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  const VehicleRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  String _mapBrandToBackend(String brand) {
    final b = brand.trim().toUpperCase();
    if (b.contains('MERCEDES')) return 'MERCEDES_BENZ';
    return b;
  }

  String _mapCategoryToBackend(String cat) {
    return cat.trim().toUpperCase();
  }

  bool _hasFilterConditions(VehicleFilter filter) {
    return filter.brand != 'Tất cả' ||
        filter.seats != 'Tất cả' ||
        filter.carType != 'Tất cả';
  }

  @override
  Future<List<VehicleModel>> getVehicles({VehicleFilter? filter}) {
    return guardApiCall(() async {
      // 1. Nếu có tiêu chí lọc cụ thể -> Gọi API POST /vehicles/filter/available
      if (filter != null && _hasFilterConditions(filter)) {
        final now = DateTime.now();
        final startTime = now.add(const Duration(hours: 1));
        final endTime = now.add(const Duration(days: 2));

        int? seatCount;
        if (filter.seats != 'Tất cả') {
          seatCount = int.tryParse(filter.seats.replaceAll(RegExp(r'\D'), ''));
        }

        final Map<String, dynamic> payload = {
          'city': 'TP_HCM',
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'page': 0,
          'limit': 20,
        };

        if (filter.brand != 'Tất cả') {
          payload['brands'] = [_mapBrandToBackend(filter.brand)];
        }
        if (filter.carType != 'Tất cả') {
          payload['categories'] = [_mapCategoryToBackend(filter.carType)];
        }
        if (seatCount != null) {
          payload['seats'] = seatCount;
        }

        final response = await _dio.post<Map<String, dynamic>>(
          '/vehicles/filter/available',
          data: payload,
        );

        final data = response.data?['data'];
        if (data is Map<String, dynamic> && data['content'] is List) {
          final list = data['content'] as List;
          return list
              .map((item) =>
                  VehicleModel.fromBackendJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      // 2. Mặc định: Lấy danh sách xe trang chủ GET /vehicles/home
      try {
        final homeResponse =
            await _dio.get<Map<String, dynamic>>('/vehicles/home');
        final homeData = homeResponse.data?['data'];
        if (homeData is List && homeData.isNotEmpty) {
          return homeData
              .map((item) =>
                  VehicleModel.fromBackendJson(item as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {
        // Nếu /vehicles/home không có dữ liệu, thử gọi GET /vehicles
      }

      final allResponse = await _dio.get<Map<String, dynamic>>('/vehicles');
      final allData = allResponse.data?['data'];
      if (allData is List) {
        return allData
            .map((item) =>
                VehicleModel.fromBackendJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    });
  }

  @override
  Future<VehicleModel> getVehicleDetail(String id) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/vehicles/id/$id');
      final data = response.data?['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw const ServerException(
          message: 'Không tìm thấy dữ liệu chi tiết xe từ hệ thống.',
        );
      }

      return VehicleModel.fromBackendJson(data);
    });
  }

  @override
  Future<List<String>> getVehicleBrands() {
    return guardApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/vehicles/brand');
      final data = response.data?['data'];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    });
  }

  @override
  Future<List<String>> getVehicleCategories() {
    return guardApiCall(() async {
      final response =
          await _dio.get<Map<String, dynamic>>('/vehicles/category');
      final data = response.data?['data'];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    });
  }
}
