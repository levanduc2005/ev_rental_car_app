import 'package:dio/dio.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:rental_car/features/checkout/data/models/rental_checklist_model.dart';
import 'package:rental_car/features/checkout/data/models/rental_overview_model.dart';
import 'package:rental_car/features/checkout/data/models/vehicle_log_model.dart';

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  const CheckoutRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<RentalChecklistModel>> getChecklistsByRentalId(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/rental-checklists/rentalId',
        queryParameters: {'rentalId': rentalId},
      );

      final data = response.data?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(RentalChecklistModel.fromJson)
            .toList();
      }
      return const [];
    });
  }

  @override
  Future<RentalChecklistModel> createChecklist({
    required int rentalId,
    required String type,
    required double currentBattery,
    required String img,
    String? staffEmail,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'rentalId': rentalId,
        'type': type,
        'currentBattery': currentBattery.toInt(),
        'img': img,
      };
      if (staffEmail != null && staffEmail.isNotEmpty) {
        body['staffEmail'] = staffEmail;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/rental-checklists',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalChecklistModel.fromJson(data);
      }
      throw Exception('Không nhận được dữ liệu biên bản từ máy chủ');
    });
  }

  @override
  Future<RentalChecklistModel> updateChecklist({
    required int id,
    required int rentalId,
    required String type,
    required double currentBattery,
    required String img,
    required String staffEmail,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'id': id,
        'rentalId': rentalId,
        'type': type,
        'currentBattery': currentBattery.toDouble(),
        'img': img,
        'staffEmail': staffEmail,
      };

      final response = await _dio.put<Map<String, dynamic>>(
        '/rental-checklists/$id',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalChecklistModel.fromJson(data);
      }
      throw Exception('Không nhận được dữ liệu biên bản cập nhật từ máy chủ');
    });
  }

  @override
  Future<VehicleLogModel?> getVehicleLogByRentalId(int rentalId) {
    return guardApiCall(() async {
      try {
        Response<Map<String, dynamic>> response;
        try {
          response = await _dio.get<Map<String, dynamic>>(
            '/rentals/$rentalId/details',
          );
        } on DioException {
          response = await _dio.get<Map<String, dynamic>>(
            '/rentals/me/details/$rentalId',
          );
        }

        final data = response.data?['data'];
        if (data is Map<String, dynamic>) {
          final vl = data['vehicleLog'] as Map<String, dynamic>?;
          if (vl != null) {
            return VehicleLogModel.fromJson(vl);
          }
        }
        return null;
      } catch (e) {
        // Nếu chưa có log thì trả về null
        return null;
      }
    });
  }

  @override
  Future<VehicleLogModel> createOrUpdateVehicleLog({
    required int rentalId,
    required int vehicleId,
    required List<Map<String, dynamic>> repairItems,
    required List<String> imgs,
    int? staffId,
    int? logId,
  }) {
    return guardApiCall(() async {
      final body = <String, dynamic>{
        'rentalId': rentalId,
        'vehicleId': vehicleId,
        'repairItems': repairItems,
        'imgs': imgs,
      };
      if (staffId != null) {
        body['staffId'] = staffId;
      }

      final Response<Map<String, dynamic>> response;
      if (logId != null) {
        response = await _dio.put<Map<String, dynamic>>(
          '/vehicleLogs/$logId',
          data: body,
        );
      } else {
        response = await _dio.post<Map<String, dynamic>>(
          '/vehicleLogs',
          data: body,
        );
      }

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return VehicleLogModel.fromJson(data);
      }
      throw Exception(
        'Không nhận được thông tin biên bản nhật ký xe từ máy chủ',
      );
    });
  }

  @override
  Future<RentalOverviewModel> getRentalOverview(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/rentals/$rentalId/overview',
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return RentalOverviewModel.fromJson(data);
      }
      throw Exception('Không nhận được thông tin quyết toán từ máy chủ');
    });
  }

  @override
  Future<Map<String, dynamic>> processCheckoutPayment(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/$rentalId/check-outpayment',
      );

      return response.data?['data'] as Map<String, dynamic>? ?? const {};
    });
  }

  @override
  Future<PayOSPaymentInfoModel> createRentalCompensationPaymentLink(
    int rentalId, {
    double? amount,
  }) {
    return guardApiCall(() async {
      final body = amount != null && amount > 0
          ? {'amount': amount.toInt()}
          : null;

      final response = await _dio.post<Map<String, dynamic>>(
        '/payment/payos/create-link/rental/$rentalId',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return PayOSPaymentInfoModel.fromJson(data);
      }
      throw Exception(
        'Không nhận được dữ liệu thanh toán PayOS đền bù từ máy chủ',
      );
    });
  }

  @override
  Future<bool> checkRentalCompensationPayment(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/payment/payos/check/rental/$rentalId',
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        final status = data['status']?.toString().toUpperCase();
        return status == 'PAID' || status == 'SUCCESS' || status == 'COMPLETED';
      }
      return false;
    });
  }
}
