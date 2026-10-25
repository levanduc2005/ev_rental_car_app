import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/core/utils/app_logger.dart';
import 'package:rental_car/features/active_trip/data/models/active_rental_model.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_preview_model.dart';
import 'package:rental_car/features/active_trip/data/models/extend_rental_result_model.dart';
import 'package:rental_car/features/active_trip/data/models/vehicle_schedule_model.dart';

abstract interface class ActiveRentalRemoteDataSource {
  /// Lấy chi tiết đơn thuê theo ID (GET /rentals/me/details/{id})
  Future<ActiveRentalModel> getRentalDetail(int rentalId);

  /// Lấy đơn thuê đang có trạng thái IN_PROGRESS của user (POST /rentals/email)
  Future<ActiveRentalModel?> getCurrentActiveRental({required String email});

  /// Lấy danh sách lịch bận của xe (GET /vehicles/{vehicleId}/schedule)
  Future<List<VehicleScheduleModel>> getVehicleSchedule(int vehicleId);

  /// Xem trước phí gia hạn từ BE (POST /rentals/{rentalId}/preview-extend)
  Future<ExtendRentalPreviewModel> previewExtendRental({
    required int rentalId,
    required DateTime newReturnTime,
  });

  /// Gia hạn thời gian trả xe (POST /rentals/{rentalId}/extend)
  Future<ExtendRentalResultModel> extendRental({
    required int rentalId,
    required DateTime newReturnTime,
  });

  /// Kiểm tra và xác nhận thanh toán gia hạn chuyến đi (POST /payment/payos/check/rental/{rentalId})
  Future<bool> checkExtendPayment(int rentalId);
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

  @override
  Future<List<VehicleScheduleModel>> getVehicleSchedule(int vehicleId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/vehicles/$vehicleId/schedule',
      );
      final data = response.data?['data'];
      if (data is List) {
        return data
            .map(
              (e) => VehicleScheduleModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return const [];
    });
  }

  @override
  Future<ExtendRentalPreviewModel> previewExtendRental({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return guardApiCall(() async {
      String pad(int n) => n.toString().padLeft(2, '0');
      final formatted =
          '${newReturnTime.year}-${pad(newReturnTime.month)}-${pad(newReturnTime.day)}T'
          '${pad(newReturnTime.hour)}:${pad(newReturnTime.minute)}:${pad(newReturnTime.second)}';

      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/rentals/$rentalId/preview-extend',
          data: formatted,
          options: Options(contentType: 'application/json'),
        );
        final data = response.data?['data'];
        if (data is Map<String, dynamic>) {
          return ExtendRentalPreviewModel.fromJson(data);
        }
        throw const ParsingException('Không lấy được dữ liệu ước tính giá.');
      } on DioException catch (e) {
        AppLogger.instance.e(
          'previewExtendRental failed [${e.response?.statusCode}]: ${e.response?.data}',
        );
        rethrow;
      }
    });
  }

  @override
  Future<ExtendRentalResultModel> extendRental({
    required int rentalId,
    required DateTime newReturnTime,
  }) {
    return guardApiCall(() async {
      String pad(int n) => n.toString().padLeft(2, '0');
      final formatted =
          '${newReturnTime.year}-${pad(newReturnTime.month)}-${pad(newReturnTime.day)}T'
          '${pad(newReturnTime.hour)}:${pad(newReturnTime.minute)}:${pad(newReturnTime.second)}';

      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/$rentalId/extend',
        data: formatted,
        options: Options(contentType: 'application/json'),
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return ExtendRentalResultModel.fromJson(data);
      }
      return const ExtendRentalResultModel(url: '');
    });
  }

  @override
  Future<bool> checkExtendPayment(int rentalId) {
    return guardApiCall(() async {
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/payment/payos/check/rental/$rentalId',
        );
        final data = response.data?['data'] as Map<String, dynamic>?;
        if (data != null) {
          final status = data['status']?.toString().toUpperCase();
          if (status == 'SUCCESS' || status == 'PAID') {
            return true;
          }
        }
      } catch (e) {
        AppLogger.instance.w('checkExtendPayment check: $e');
      }
      return false;
    });
  }
}
