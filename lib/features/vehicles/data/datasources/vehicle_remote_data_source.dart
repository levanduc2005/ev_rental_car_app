import 'package:dio/dio.dart';
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
        filter.carType != 'Tất cả' ||
        filter.startTime != null ||
        filter.endTime != null ||
        filter.hourPackage != null ||
        filter.city != null ||
        filter.stationId != null;
  }

  @override
  Future<List<VehicleModel>> getVehicles({VehicleFilter? filter}) {
    return guardApiCall(() async {
      // 1. Nếu có tiêu chí lọc cụ thể -> Gọi API POST /vehicles/filter/available
      if (filter != null && _hasFilterConditions(filter)) {
        final now = DateTime.now();
        // BE: startTime phải sau hiện tại ít nhất 3 giờ và endTime >= startTime + 4 giờ
        DateTime startTime =
            filter.startTime ?? now.add(const Duration(hours: 4));
        if (startTime.isBefore(now.add(const Duration(hours: 3)))) {
          startTime = now.add(const Duration(hours: 4));
        }

        DateTime endTime;
        if (filter.endTime != null &&
            filter.endTime!.isAfter(
              startTime.add(const Duration(hours: 3, minutes: 50)),
            )) {
          endTime = filter.endTime!;
        } else if (filter.hourPackage != null && filter.hourPackage! > 0) {
          endTime = startTime.add(Duration(hours: filter.hourPackage!));
        } else {
          endTime = startTime.add(const Duration(hours: 4));
        }

        // Đảm bảo phút là 00 theo chuẩn giờ chẵn (isExactHour) của BE
        startTime = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
          startTime.hour,
        );
        endTime = DateTime(
          endTime.year,
          endTime.month,
          endTime.day,
          endTime.hour,
        );

        int? seatCount;
        if (filter.seats != 'Tất cả') {
          seatCount = int.tryParse(filter.seats.replaceAll(RegExp(r'\D'), ''));
        }

        String beCity = 'HANOI';
        if (filter.city != null) {
          final c = filter.city!.toUpperCase();
          if (c.contains('HCM') ||
              c.contains('HỒ CHÍ MINH') ||
              c.contains('TP_HCM')) {
            beCity = 'TP_HCM';
          } else {
            beCity = 'HANOI';
          }
        }

        final Map<String, dynamic> payload = {
          'city': beCity,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'page': 1, // BE PageRequest.of(page - 1) => 1 - 1 = 0
          'limit': 20,
        };

        if (filter.stationId != null) {
          payload['stationId'] = filter.stationId;
        }
        if (filter.brand != 'Tất cả') {
          payload['brands'] = [_mapBrandToBackend(filter.brand)];
        }
        if (filter.carType != 'Tất cả') {
          payload['categories'] = [_mapCategoryToBackend(filter.carType)];
        }
        if (seatCount != null) {
          payload['seats'] = seatCount;
        }

        try {
          final response = await _dio.post<Map<String, dynamic>>(
            '/vehicles/filter/available',
            data: payload,
          );

          final data = response.data?['data'];
          if (data is Map<String, dynamic> && data['content'] is List) {
            final list = data['content'] as List;
            if (list.isNotEmpty) {
              return list
                  .map(
                    (item) => VehicleModel.fromBackendJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
          }
        } catch (_) {
          // Nếu BE gặp lỗi hoặc offline, fallback sang /vehicles/home
        }
      }

      // 2. Mặc định: Lấy danh sách xe trang chủ GET /vehicles/home
      try {
        final homeResponse = await _dio.get<Map<String, dynamic>>(
          '/vehicles/home',
        );
        final homeData = homeResponse.data?['data'];
        if (homeData is List && homeData.isNotEmpty) {
          return homeData
              .map(
                (item) =>
                    VehicleModel.fromBackendJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      } catch (_) {
        // Nếu /vehicles/home không có dữ liệu, thử gọi GET /vehicles
      }

      final allResponse = await _dio.get<Map<String, dynamic>>('/vehicles');
      final allData = allResponse.data?['data'];
      if (allData is List) {
        return allData
            .map(
              (item) =>
                  VehicleModel.fromBackendJson(item as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    });
  }

  @override
  Future<VehicleModel> getVehicleDetail(String id) {
    return guardApiCall(() async {
      try {
        final response = await _dio.get<Map<String, dynamic>>(
          '/vehicles/id/$id',
        );
        final data = response.data?['data'] as Map<String, dynamic>?;

        if (data != null) {
          return VehicleModel.fromBackendJson(data);
        }
      } catch (_) {
        // Fallback sang dữ liệu xe dự phòng khi BE offline hoặc không có id
      }

      return _getFallbackVehicleDetail(id);
    });
  }

  VehicleModel _getFallbackVehicleDetail(String id) {
    final intId = int.tryParse(id) ?? 1;
    switch (intId) {
      case 2:
        return const VehicleModel(
          id: 2,
          name: 'VinFast VF 8',
          brand: 'VINFAST',
          stationName: 'Quận Nam Từ Liêm, Hà Nội',
          distanceKm: 4.2,
          seats: 5,
          batteryLevel: 95,
          batteryCapacity: 87.7,
          main:
              'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800&auto=format&fit=crop',
          consumptionRate: 18.0,
          description:
              'VinFast VF 8 trang bị ADAS cao cấp, sạc siêu tốc, nội thất da sang trọng và camera 360 toàn cảnh.',
          images: [
            'https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1000&auto=format&fit=crop',
          ],
          depositFee: 5000000.0,
          holdFee: 500000.0,
          pricePer4Hours: 720000,
          pricePer8Hours: 1050000,
          pricePer12Hours: 1250000,
          pricePerDay: 1450000,
        );
      case 3:
        return const VehicleModel(
          id: 3,
          name: 'AUDI A4 2018',
          brand: 'AUDI',
          stationName: 'Quận Tây Hồ, Hà Nội',
          distanceKm: 6.8,
          seats: 5,
          main:
              'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=800&auto=format&fit=crop',
          consumptionRate: 7.2,
          description:
              'Audi A4 thể thao, động cơ TFSI mạnh mẽ, âm thanh Bang & Olufsen đỉnh cao, trải nghiệm đẳng cấp.',
          images: [
            'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?q=80&w=800&auto=format&fit=crop',
          ],
          depositFee: 10000000.0,
          holdFee: 500000.0,
          pricePer4Hours: 1375000,
          pricePer8Hours: 1560000,
          pricePer12Hours: 1680000,
          pricePerDay: 1770000,
        );
      case 4:
        return const VehicleModel(
          id: 4,
          name: 'BMW 320i Sport',
          brand: 'BMW',
          stationName: 'Quận Hoàn Kiếm, Hà Nội',
          distanceKm: 8.5,
          seats: 5,
          main:
              'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
          consumptionRate: 6.8,
          description:
              'BMW 320i Sport phong cách lái phấn khích, cảm giác lái chính xác, thiết kế thể thao sang trọng.',
          images: [
            'https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=800&auto=format&fit=crop',
          ],
          depositFee: 15000000.0,
          holdFee: 500000.0,
          pricePer4Hours: 1650000,
          pricePer8Hours: 1850000,
          pricePer12Hours: 1980000,
          pricePerDay: 2100000,
        );
      default:
        return VehicleModel(
          id: intId,
          name: 'KIA K3 2024',
          brand: 'KIA',
          stationName: 'Quận Cầu Giấy, Hà Nội',
          distanceKm: 3.5,
          seats: 5,
          main:
              'https://images.unsplash.com/photo-1590362891991-f776e747a588?q=80&w=800&auto=format&fit=crop',
          consumptionRate: 6.5,
          description:
              'KIA K3 bản mới với nhiều công nghệ hiện đại, nội thất rộng rãi tiện nghi, camera lùi và cảm biến an toàn.',
          images: const [
            'https://images.unsplash.com/photo-1590362891991-f776e747a588?q=80&w=800&auto=format&fit=crop',
          ],
          depositFee: 3000000.0,
          holdFee: 500000.0,
          pricePer4Hours: 575000,
          pricePer8Hours: 850000,
          pricePer12Hours: 1000000,
          pricePerDay: 1145000,
        );
    }
  }

  @override
  Future<List<String>> getVehicleBrands() {
    return guardApiCall(() async {
      try {
        final res = await _dio.get<Map<String, dynamic>>('/brands');
        final data = res.data?['data'];
        if (data is List && data.isNotEmpty) {
          return data
              .map((e) {
                if (e is Map<String, dynamic>) {
                  return (e['name'] ?? e['code'] ?? '').toString();
                }
                return e.toString();
              })
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } catch (_) {
        // Fallback sang /vehicles/brand nếu /brands chưa sẵn sàng
      }

      final response = await _dio.get<Map<String, dynamic>>('/vehicles/brand');
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
      final response = await _dio.get<Map<String, dynamic>>(
        '/vehicles/category',
      );
      final data = response.data?['data'];
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    });
  }
}
