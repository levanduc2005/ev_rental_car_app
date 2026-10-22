import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/profile/data/models/rental_detail_model.dart';
import 'package:rental_car/features/staff/data/models/renter_model.dart';
import 'package:rental_car/features/staff/data/models/staff_station_model.dart';

import 'package:rental_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:rental_car/features/vehicles/domain/entities/vehicle_entity.dart';

abstract interface class StaffRemoteDataSource {
  Future<StaffProfileModel> getStaffProfile();

  Future<RenterModel> getRenterByEmail(String email);

  Future<RentalDetailModel> createRental({
    required DateTime startTime,
    required DateTime endTime,
    required int vehicleId,
    required String email,
    required int staffId,
  });

  Future<List<ReservationModel>> filterReservations({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  });

  Future<List<RentalDetailModel>> filterRentals({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  });

  Future<RentalDetailModel> convertReservationToRental({
    required String reservationCode,
    required int staffId,
  });

  Future<String> generateContract(int rentalId);

  Future<String> getCheckInPaymentUrl({required int rentalId, int point = 0});

  Future<void> updateRentalStatus({
    required int rentalId,
    required String status,
  });

  Future<RentalChecklistModel> submitCheckInChecklist({
    required int rentalId,
    required String staffEmail,
    required int currentBattery,
    required String img,
  });

  Future<bool> cancelRental(int rentalId);

  Future<List<RentalChecklistModel>> getChecklists({
    String? keyword,
    String? type,
  });

  Future<List<VehicleEntity>> getStationVehicles(int stationId);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  const StaffRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<StaffProfileModel> getStaffProfile() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return StaffProfileModel.fromJson(data);
      }
      throw const ParsingException(
        'Không tìm thấy thông tin nhân viên từ máy chủ.',
      );
    });
  }

  @override
  Future<List<ReservationModel>> filterReservations({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'search': search ?? '',
        'status': status,
        'page': page,
        'limit': limit,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/reservations/filter',
        data: body,
      );

      final data = response.data?['data'];
      List<dynamic> items = const <dynamic>[];
      if (data is Map<String, dynamic>) {
        if (data['content'] is List) {
          items = data['content'] as List<dynamic>;
        } else if (data['items'] is List) {
          items = data['items'] as List<dynamic>;
        } else if (data['reservations'] is List) {
          items = data['reservations'] as List<dynamic>;
        }
      } else if (data is List) {
        items = data;
      }

      return items
          .whereType<Map<String, dynamic>>()
          .map(ReservationModel.fromJson)
          .toList();
    });
  }

  @override
  Future<List<RentalDetailModel>> filterRentals({
    String? search,
    List<String>? status,
    int page = 1,
    int limit = 20,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'search': search ?? '',
        'status': status,
        'page': page,
        'limit': limit,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/filter',
        data: body,
      );

      final data = response.data?['data'];
      List<dynamic> items = const <dynamic>[];
      if (data is Map<String, dynamic>) {
        if (data['content'] is List) {
          items = data['content'] as List<dynamic>;
        } else if (data['items'] is List) {
          items = data['items'] as List<dynamic>;
        } else if (data['rentals'] is List) {
          items = data['rentals'] as List<dynamic>;
        }
      } else if (data is List) {
        items = data;
      }

      return items
          .whereType<Map<String, dynamic>>()
          .map(RentalDetailModel.fromJson)
          .toList();
    });
  }

  @override
  Future<RentalDetailModel> convertReservationToRental({
    required String reservationCode,
    required int staffId,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'reservationCode': reservationCode,
        'staffId': staffId,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/reservation',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalDetailModel.fromJson(data);
      }
      throw const ParsingException(
        'Không nhận được dữ liệu đơn thuê sau khi chuyển đổi.',
      );
    });
  }

  @override
  Future<String> generateContract(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<dynamic>('/rentals/$rentalId/contract');

      final respData = response.data;
      if (respData is Map<String, dynamic>) {
        final data = respData['data'];
        if (data is String && data.isNotEmpty) return data;
        if (data is Map<String, dynamic>) {
          final url =
              data['signingUrl'] as String? ?? data['contractUrl'] as String?;
          if (url != null && url.isNotEmpty) return url;
        }
      } else if (respData is String && respData.startsWith('http')) {
        return respData;
      }

      throw const ParsingException(
        'Không nhận được đường dẫn hợp đồng DocuSeal.',
      );
    });
  }

  @override
  Future<String> getCheckInPaymentUrl({required int rentalId, int point = 0}) {
    return guardApiCall(() async {
      final response = await _dio.get<dynamic>(
        '/rentals/check-inpayment',
        queryParameters: {'rentalId': rentalId, 'point': point},
      );

      final respData = response.data;
      if (respData is Map<String, dynamic>) {
        final data = respData['data'];
        if (data is String && data.isNotEmpty) return data;
        if (data is Map<String, dynamic>) {
          final url = data['paymentUrl'] as String? ?? data['url'] as String?;
          if (url != null && url.isNotEmpty) return url;
        }
        final url =
            respData['url'] as String? ?? respData['paymentUrl'] as String?;
        if (url != null && url.isNotEmpty) return url;
      } else if (respData is String && respData.startsWith('http')) {
        return respData;
      }

      throw const ParsingException(
        'Không nhận được đường dẫn thanh toán từ máy chủ.',
      );
    });
  }

  @override
  Future<void> updateRentalStatus({
    required int rentalId,
    required String status,
  }) {
    return guardApiCall(() async {
      await _dio.patch<Map<String, dynamic>>(
        '/rentals/status',
        data: {'id': rentalId, 'status': status},
      );
    });
  }

  @override
  Future<RentalChecklistModel> submitCheckInChecklist({
    required int rentalId,
    required String staffEmail,
    required int currentBattery,
    required String img,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'type': 'CHECK_IN',
        'rentalId': rentalId,
        'staffEmail': staffEmail,
        'currentBattery': currentBattery,
        'img': img,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/rental-checklists',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalChecklistModel.fromJson(data);
      }
      throw const ParsingException(
        'Không nhận được dữ liệu biên bản bàn giao xe từ máy chủ.',
      );
    });
  }

  @override
  Future<List<RentalChecklistModel>> getChecklists({
    String? keyword,
    String? type,
  }) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/rental-checklists/search',
        queryParameters: {
          if (keyword != null && keyword.trim().isNotEmpty)
            'keyword': keyword.trim(),
          if (type != null && type.isNotEmpty && type != 'ALL') 'type': type,
        },
      );

      final data = response.data?['data'];
      List<dynamic> items = const <dynamic>[];
      if (data is List) {
        items = data;
      } else if (data is Map<String, dynamic> && data['content'] is List) {
        items = data['content'] as List<dynamic>;
      }

      return items
          .whereType<Map<String, dynamic>>()
          .map(RentalChecklistModel.fromJson)
          .toList();
    });
  }

  @override
  Future<List<VehicleEntity>> getStationVehicles(int stationId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/vehicles');
      final data = response.data?['data'];
      List<dynamic> items = const <dynamic>[];
      if (data is List) {
        items = data;
      } else if (data is Map<String, dynamic> && data['content'] is List) {
        items = data['content'] as List<dynamic>;
      }

      final all = items.whereType<Map<String, dynamic>>().map((item) {
        try {
          return VehicleModel.fromBackendJson(item).toEntity();
        } catch (_) {
          return VehicleModel.fromJson(item).toEntity();
        }
      }).toList();

      if (stationId > 0) {
        final filtered = all.where((v) => v.station?.id == stationId).toList();
        if (filtered.isNotEmpty) return filtered;
      }
      return all;
    });
  }

  @override
  Future<RenterModel> getRenterByEmail(String email) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users/renter/$email',
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RenterModel.fromJson(data);
      }
      throw const ParsingException('Không tìm thấy thông tin người thuê.');
    });
  }

  @override
  Future<RentalDetailModel> createRental({
    required DateTime startTime,
    required DateTime endTime,
    required int vehicleId,
    required String email,
    required int staffId,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'vehicleId': vehicleId,
        'email': email,
        'staffId': staffId,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalDetailModel.fromJson(data);
      }
      throw const ParsingException(
        'Không thể khởi tạo hợp đồng thuê xe từ máy chủ.',
      );
    });
  }

  @override
  Future<bool> cancelRental(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/manage/$rentalId/cancel',
      );
      final data = response.data?['data'];
      if (data is bool) return data;
      return true;
    });
  }
}
