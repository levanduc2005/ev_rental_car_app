import 'package:dio/dio.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:rental_car/features/vehicles/domain/entities/booking_fee.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_filter.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_schedule.dart';

/// Kết quả phân trang từ data source (chưa map sang entity)
class PaginatedVehicleModels {
  const PaginatedVehicleModels({
    required this.models,
    required this.currentPage,
    required this.totalPages,
  });

  final List<VehicleModel> models;
  final int currentPage;
  final int totalPages;
}

abstract interface class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getVehicles({VehicleFilter? filter});
  Future<VehicleModel> getVehicleDetail(String id);
  Future<List<String>> getVehicleBrands();
  Future<List<String>> getVehicleCategories();

  /// Lấy bảng phí booking từ BE (POST /vehicles/booking)
  Future<BookingFeeBreakdown> getBookingFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
  });

  /// Lấy lịch bận của xe (GET /vehicles/{id}/schedule)
  Future<List<VehicleScheduleSlot>> getVehicleSchedule(int vehicleId);

  /// Lấy danh sách xe có phân trang (POST /vehicles/filter/available)
  Future<PaginatedVehicleModels> getVehiclesPaginated({
    VehicleFilter? filter,
    int page = 1,
    int limit = 20,
  });
}

// ---------------------------------------------------------------------------
// Dữ liệu chi tiết bổ sung cho từng xe (chỉ dùng khi BE offline)
// ---------------------------------------------------------------------------
const _detailExtras =
    <
      int,
      ({
        double distanceKm,
        double depositFee,
        double holdFee,
        String description,
        String imageQuality,
      })
    >{
      1: (
        distanceKm: 1.8,
        depositFee: 3000000.0,
        holdFee: 500000.0,
        description:
            'Mẫu mini điện thông minh, nhỏ gọn linh hoạt trong đô thị với quãng đường di chuyển lên tới 215 km/lần sạc.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
      2: (
        distanceKm: 2.5,
        depositFee: 5000000.0,
        holdFee: 500000.0,
        description:
            'Xe SUV điện hạng A tiện nghi, trang bị đầy đủ tính năng thông minh và an toàn vượt trội.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
      3: (
        distanceKm: 3.8,
        depositFee: 10000000.0,
        holdFee: 500000.0,
        description:
            'SUV điện hạng D mạnh mẽ, công nghệ hỗ trợ lái nâng cao ADAS cấp độ 2, tầm vận hành trên 400km.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
      4: (
        distanceKm: 5.2,
        depositFee: 15000000.0,
        holdFee: 500000.0,
        description:
            'SUV điện full-size hạng E cao cấp, ghế cơ trưởng thương gia, massage, màn hình giải trí đa phương tiện sang trọng.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
      5: (
        distanceKm: 4.8,
        depositFee: 12000000.0,
        holdFee: 500000.0,
        description:
            'Sedan thuần điện hàng đầu thế giới với khả năng tăng tốc 0-100km/h trong 4.4 giây, Autopilot tích hợp sẵn.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
      7: (
        distanceKm: 3.2,
        depositFee: 7000000.0,
        holdFee: 500000.0,
        description:
            'Mẫu SUV điện gia đình trẻ trung trang bị pin Blade an toàn độc quyền, nội thất thiết kế năng động.',
        imageQuality: '?q=80&w=800&auto=format&fit=crop',
      ),
    };

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  const VehicleRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  String _mapBrandToBackend(String brand) {
    final b = brand.trim().toUpperCase();
    if (b.contains('MERCEDES')) return 'MERCEDES_BENZ';
    return b;
  }

  String _mapCategoryToBackend(String cat) {
    final c = cat.trim().toUpperCase();
    if (c.contains('PICKUP') || c.contains('BÁN TẢI')) return 'PICKUP';
    return c;
  }

  String _formatDateTimeForBackend(DateTime dt) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${pad(dt.month)}-${pad(dt.day)}T${pad(dt.hour)}:${pad(dt.minute)}:${pad(dt.second)}';
  }

  // ---------------------------------------------------------------------------
  // Danh sách xe fallback dùng cho list view (tối giản, không có detail fields)
  // ---------------------------------------------------------------------------
  static const List<VehicleModel> _staticFallbackVehicles = [
    VehicleModel(
      id: 1,
      name: 'VinFast VF 3 Plus 2024',
      brand: 'VINFAST',
      stationName: 'Trạm Sạc & Thuê Xe Quận 1, TP. Hồ Chí Minh',
      batteryLevel: 95,
      batteryCapacity: 18.64,
      main: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf',
      consumptionRate: 8.5,
      pricePer4Hours: 300000,
      pricePer8Hours: 420000,
      pricePer12Hours: 480000,
      pricePerDay: 600000,
    ),
    VehicleModel(
      id: 2,
      name: 'VinFast VF 5 Plus',
      brand: 'VINFAST',
      stationName: 'Trạm Sạc & Thuê Xe Quận 1, TP. Hồ Chí Minh',
      seats: 5,
      batteryLevel: 88,
      batteryCapacity: 37.23,
      main: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d',
      consumptionRate: 11.2,
      pricePer4Hours: 450000,
      pricePer8Hours: 630000,
      pricePer12Hours: 720000,
      pricePerDay: 900000,
    ),
    VehicleModel(
      id: 3,
      name: 'VinFast VF 8 Plus',
      brand: 'VINFAST',
      stationName: 'Trạm Sạc & Thuê Xe Quận 1, TP. Hồ Chí Minh',
      seats: 5,
      batteryLevel: 72,
      batteryCapacity: 87.7,
      main: 'https://images.unsplash.com/photo-1617788138017-80ad40651399',
      consumptionRate: 16.5,
      pricePer4Hours: 900000,
      pricePer8Hours: 1260000,
      pricePer12Hours: 1440000,
      pricePerDay: 1800000,
    ),
    VehicleModel(
      id: 4,
      name: 'VinFast VF 9 Plus 6 Chỗ',
      brand: 'VINFAST',
      stationName: 'Trạm Sạc & Thuê Xe Cầu Giấy, Hà Nội',
      seats: 7,
      batteryLevel: 100,
      batteryCapacity: 123.0,
      main: 'https://images.unsplash.com/photo-1563720223185-11003d516935',
      consumptionRate: 20.0,
      pricePer4Hours: 1400000,
      pricePer8Hours: 1960000,
      pricePer12Hours: 2240000,
      pricePerDay: 2800000,
    ),
    VehicleModel(
      id: 5,
      name: 'Tesla Model 3 Long Range',
      brand: 'TESLA',
      stationName: 'Trạm Sạc & Thuê Xe Cầu Giấy, Hà Nội',
      seats: 5,
      batteryLevel: 90,
      batteryCapacity: 82.0,
      main: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89',
      consumptionRate: 14.0,
      pricePer4Hours: 1200000,
      pricePer8Hours: 1680000,
      pricePer12Hours: 1920000,
      pricePerDay: 2400000,
    ),
    VehicleModel(
      id: 7,
      name: 'BYD Atto 3 Extended',
      brand: 'BYD',
      stationName: 'Trạm Sạc & Thuê Xe Hoàn Kiếm, Hà Nội',
      seats: 5,
      batteryLevel: 85,
      batteryCapacity: 60.48,
      main: 'https://images.unsplash.com/photo-1502877338535-766e1452684a',
      consumptionRate: 13.0,
      pricePer4Hours: 600000,
      pricePer8Hours: 840000,
      pricePer12Hours: 960000,
      pricePerDay: 1200000,
    ),
  ];

  bool _hasAvailabilityConditions(VehicleFilter filter) {
    return filter.startTime != null ||
        filter.endTime != null ||
        filter.hourPackage != null ||
        filter.stationId != null ||
        (filter.city != null && filter.city!.trim().isNotEmpty);
  }

  // ---------------------------------------------------------------------------
  // Helper: chuẩn hóa thời gian + xây payload cho /vehicles/filter/available
  // Được tái sử dụng bởi cả getVehicles() và getVehiclesPaginated()
  // ---------------------------------------------------------------------------
  Map<String, dynamic> _buildAvailabilityPayload(
    VehicleFilter filter, {
    int page = 1,
    int limit = 20,
  }) {
    final now = DateTime.now();
    final safeStartHour = now.minute > 0 ? now.hour + 4 : now.hour + 3;
    DateTime startTime =
        filter.startTime ??
        (safeStartHour <= 23
            ? DateTime(now.year, now.month, now.day, safeStartHour)
            : DateTime(now.year, now.month, now.day + 1, 8));

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

    // Truncate về giờ chẵn cho BE
    startTime = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      startTime.hour,
    );
    endTime = DateTime(endTime.year, endTime.month, endTime.day, endTime.hour);

    int? seatCount;
    if (filter.seats != 'Tất cả') {
      seatCount = int.tryParse(filter.seats.replaceAll(RegExp(r'\D'), ''));
    }

    String beCity = 'Hồ Chí Minh';
    if (filter.city != null) {
      final c = filter.city!.trim().toUpperCase();
      if (c.contains('HANOI') || c.contains('HÀ NỘI')) {
        beCity = 'Hà Nội';
      }
    }

    final Map<String, dynamic> payload = {
      'city': beCity,
      'startTime': _formatDateTimeForBackend(startTime),
      'endTime': _formatDateTimeForBackend(endTime),
      'page': page,
      'limit': limit,
      'search': filter.search?.trim() ?? '',
    };

    if (filter.stationId != null) payload['stationId'] = filter.stationId;
    if (filter.brand != 'Tất cả' && filter.brand.trim().isNotEmpty) {
      payload['brands'] = [_mapBrandToBackend(filter.brand)];
    }
    if (filter.carType != 'Tất cả' && filter.carType.trim().isNotEmpty) {
      payload['categories'] = [_mapCategoryToBackend(filter.carType)];
    }
    if (seatCount != null) payload['seats'] = seatCount;
    if (filter.effectiveMinPrice != null) {
      payload['minPrice'] = filter.effectiveMinPrice;
    }
    if (filter.effectiveMaxPrice != null) {
      payload['maxPrice'] = filter.effectiveMaxPrice;
    }

    return payload;
  }

  // ---------------------------------------------------------------------------
  // Helper: lọc brand phía client sau khi nhận response từ BE
  // ---------------------------------------------------------------------------
  List<VehicleModel> _applyBrandFilter(
    List<VehicleModel> models,
    VehicleFilter filter,
  ) {
    if (filter.brand == 'Tất cả' || filter.brand.trim().isEmpty) return models;
    return models
        .where(
          (m) => m.brand.toUpperCase() == filter.brand.trim().toUpperCase(),
        )
        .toList();
  }

  @override
  Future<List<VehicleModel>> getVehicles({VehicleFilter? filter}) {
    return guardApiCall(() async {
      // 1. Nếu có tiêu chí lọc khung giờ / địa điểm cụ thể -> Gọi API POST
      if (filter != null && _hasAvailabilityConditions(filter)) {
        try {
          final payload = _buildAvailabilityPayload(filter);

          final response = await _dio.post<Map<String, dynamic>>(
            '/vehicles/filter/available',
            data: payload,
          );

          final data = response.data?['data'];
          if (data is Map<String, dynamic> && data['content'] is List) {
            final list = data['content'] as List;
            var models = list
                .map(
                  (item) => VehicleModel.fromBackendJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
            models = _applyBrandFilter(models, filter);
            if (models.isNotEmpty) return models;
          }
        } catch (_) {
          // Khi BE gặp lỗi hoặc offline -> tự động fallback
        }
      }

      // 2. Mặc định / Fallback: Lấy danh sách xe và lọc theo điều kiện
      List<VehicleModel> fallbackList = [];
      if (filter != null &&
          filter.brand != 'Tất cả' &&
          filter.brand.trim().isNotEmpty) {
        try {
          final brandRes = await _dio.get<Map<String, dynamic>>(
            '/vehicles/brand/${filter.brand.trim()}',
          );
          final brandData = brandRes.data?['data'];
          if (brandData is List && brandData.isNotEmpty) {
            fallbackList = brandData
                .map(
                  (item) => VehicleModel.fromBackendJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
        } catch (_) {}
      }

      if (fallbackList.isEmpty) {
        try {
          final homeResponse = await _dio.get<Map<String, dynamic>>(
            '/vehicles/home',
          );
          final homeData = homeResponse.data?['data'];
          if (homeData is List && homeData.isNotEmpty) {
            fallbackList = homeData
                .map(
                  (item) => VehicleModel.fromBackendJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
        } catch (_) {}
      }

      if (fallbackList.isEmpty) {
        try {
          final allResponse = await _dio.get<Map<String, dynamic>>('/vehicles');
          final allData = allResponse.data?['data'];
          if (allData is List && allData.isNotEmpty) {
            fallbackList = allData
                .map(
                  (item) => VehicleModel.fromBackendJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
          }
        } catch (_) {}
      }

      if (fallbackList.isEmpty) {
        fallbackList = _staticFallbackVehicles;
      }

      if (filter != null) {
        final targetCity = filter.city ?? filter.location;
        if (targetCity != null && targetCity.trim().isNotEmpty) {
          final isHcm =
              targetCity.toUpperCase().contains('HCM') ||
              targetCity.toUpperCase().contains('HỒ CHÍ MINH') ||
              targetCity.toUpperCase().contains('TP_HCM');
          final expectedCity = isHcm ? 'Hồ Chí Minh' : 'Hà Nội';
          fallbackList = fallbackList.where((v) {
            final vCity = v.station?.city ?? v.stationName ?? '';
            return vCity.toLowerCase().contains(expectedCity.toLowerCase());
          }).toList();
        }

        if (filter.brand != 'Tất cả' && filter.brand.trim().isNotEmpty) {
          fallbackList = fallbackList
              .where(
                (v) =>
                    v.brand.toUpperCase() == filter.brand.trim().toUpperCase(),
              )
              .toList();
        }

        if (filter.seats != 'Tất cả') {
          final sCount = int.tryParse(
            filter.seats.replaceAll(RegExp(r'\D'), ''),
          );
          if (sCount != null) {
            fallbackList = fallbackList
                .where((v) => v.seats == sCount)
                .toList();
          }
        }

        if (filter.carType != 'Tất cả' && filter.carType.trim().isNotEmpty) {
          final cType = filter.carType.trim().toUpperCase();
          fallbackList = fallbackList.where((v) {
            final vCat = (v.category ?? '').toUpperCase();
            return vCat.contains(cType) || cType.contains(vCat);
          }).toList();
        }

        if (filter.search != null && filter.search!.trim().isNotEmpty) {
          final q = filter.search!.trim().toLowerCase();
          fallbackList = fallbackList.where((v) {
            return v.name.toLowerCase().contains(q) ||
                v.brand.toLowerCase().contains(q) ||
                (v.category?.toLowerCase().contains(q) ?? false);
          }).toList();
        }
      }

      return fallbackList;
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

  /// Lấy chi tiết xe từ [_staticFallbackVehicles] và bổ sung các trường
  /// detail-only qua [_detailExtras]. Không lặp lại dữ liệu xe.
  VehicleModel _getFallbackVehicleDetail(String id) {
    final intId = int.tryParse(id) ?? 1;

    final base = _staticFallbackVehicles.firstWhere(
      (v) => v.id == intId,
      orElse: () => _staticFallbackVehicles.first,
    );

    final extras = _detailExtras[base.id] ?? _detailExtras[1]!;
    final imgUrl = '${base.main}${extras.imageQuality}';

    return base.copyWith(
      distanceKm: extras.distanceKm,
      depositFee: extras.depositFee,
      holdFee: extras.holdFee,
      description: extras.description,
      main: imgUrl,
      images: [imgUrl],
    );
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

      try {
        final response = await _dio.get<Map<String, dynamic>>(
          '/vehicles/brand',
        );
        final data = response.data?['data'];
        if (data is List && data.isNotEmpty) {
          return data.map((e) => e.toString()).toList();
        }
      } catch (_) {}

      return const ['VINFAST', 'TESLA', 'BYD', 'HYUNDAI', 'PORSCHE'];
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

  @override
  Future<BookingFeeBreakdown> getBookingFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    return guardApiCall(() async {
      // Đảm bảo giờ chẵn cho BE
      final st = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        startTime.hour,
      );
      final et = DateTime(
        endTime.year,
        endTime.month,
        endTime.day,
        endTime.hour,
      );

      final response = await _dio.post<Map<String, dynamic>>(
        '/vehicles/booking',
        data: {
          'vehicleId': vehicleId,
          'startTime': _formatDateTimeForBackend(st),
          'endTime': _formatDateTimeForBackend(et),
          'rental': false,
        },
      );

      final data = response.data?['data'];
      if (data is List && data.isNotEmpty) {
        final fees = data.map((item) {
          final map = item as Map<String, dynamic>;
          return BookingFee(
            description: map['description'] as String? ?? '',
            feeType: map['feeType'] as String? ?? '',
            value: (map['value'] as num?)?.toDouble() ?? 0.0,
          );
        }).toList();
        return BookingFeeBreakdown.fromFees(fees);
      }

      return const BookingFeeBreakdown(fees: []);
    });
  }

  @override
  Future<List<VehicleScheduleSlot>> getVehicleSchedule(int vehicleId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/vehicles/$vehicleId/schedule',
      );

      final data = response.data?['data'];
      if (data is List && data.isNotEmpty) {
        return data
            .map((item) {
              final map = item as Map<String, dynamic>;
              final start = DateTime.tryParse(
                map['startTime']?.toString() ?? '',
              );
              final end = DateTime.tryParse(map['endTime']?.toString() ?? '');
              if (start != null && end != null) {
                return VehicleScheduleSlot(startTime: start, endTime: end);
              }
              return null;
            })
            .whereType<VehicleScheduleSlot>()
            .toList();
      }
      return [];
    });
  }

  @override
  Future<PaginatedVehicleModels> getVehiclesPaginated({
    VehicleFilter? filter,
    int page = 1,
    int limit = 20,
  }) {
    return guardApiCall(() async {
      if (filter != null && _hasAvailabilityConditions(filter)) {
        try {
          final payload = _buildAvailabilityPayload(
            filter,
            page: page,
            limit: limit,
          );

          final response = await _dio.post<Map<String, dynamic>>(
            '/vehicles/filter/available',
            data: payload,
          );

          final data = response.data?['data'];
          if (data is Map<String, dynamic> && data['content'] is List) {
            final list = data['content'] as List;
            var models = list
                .map(
                  (item) => VehicleModel.fromBackendJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();
            models = _applyBrandFilter(models, filter);
            if (models.isNotEmpty) {
              final totalPg = (data['totalPages'] as num?)?.toInt() ?? 1;
              return PaginatedVehicleModels(
                models: models,
                currentPage: page,
                totalPages: totalPg,
              );
            }
          }
        } catch (_) {
          // Bắt ngoại lệ BE để fallback an toàn, không bao giờ để crash
        }
      }

      // Fallback: Lấy danh sách xe chuẩn theo getVehicles(filter: filter)
      final vehicles = await getVehicles(filter: filter);
      return PaginatedVehicleModels(
        models: vehicles,
        currentPage: 1,
        totalPages: 1,
      );
    });
  }
}
