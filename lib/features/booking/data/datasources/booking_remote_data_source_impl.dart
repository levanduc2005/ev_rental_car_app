import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:rental_car/features/booking/data/models/booking_fee_model.dart';
import 'package:rental_car/features/booking/data/models/create_reservation_request_model.dart';
import 'package:rental_car/features/booking/data/models/payos_payment_info_model.dart';
import 'package:rental_car/features/booking/data/models/reservation_model.dart';
import 'package:rental_car/features/booking/data/models/vehicle_booking_summary_model.dart';

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  const BookingRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<BookingFeeModel> calculateBookingFees({
    required int vehicleId,
    required DateTime startTime,
    required DateTime endTime,
    bool rental = false,
  }) {
    return guardApiCall(() async {
      final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
      final response = await _dio.post<Map<String, dynamic>>(
        '/vehicles/booking',
        data: {
          'vehicleId': vehicleId,
          'VehicleId': vehicleId,
          'startTime': formatter.format(startTime),
          'endTime': formatter.format(endTime),
          'rental': rental,
        },
      );

      final data = response.data?['data'];
      if (data is List) {
        return BookingFeeModel.fromList(data);
      }
      return const BookingFeeModel(
        bookingFee: 0,
        depositFee: 0,
        holdCarFee: 0,
        totalAmount: 0,
      );
    });
  }

  @override
  Future<ReservationModel> createReservation(
    CreateReservationRequestModel request,
  ) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/reservations',
        data: request.toJson(),
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return ReservationModel.fromJson(data);
      }
      throw const ParsingException('Không thể phân tích dữ liệu đặt xe.');
    });
  }

  @override
  Future<List<ReservationModel>> getMyReservations({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 20,
    String search = '',
  }) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/reservations/email',
        data: {
          'email': email,
          'status': status ?? [],
          'page': page,
          'limit': limit,
          'search': search,
        },
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        final content = data['content'];
        if (content is List) {
          return content
              .map(
                (item) =>
                    ReservationModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return const [];
    });
  }

  @override
  Future<ReservationModel> getReservationDetail(int reservationId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/reservations/me/$reservationId',
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return ReservationModel.fromJson(data);
      }
      throw const ParsingException(
        'Không tìm thấy thông tin chi tiết đơn đặt xe.',
      );
    });
  }

  @override
  Future<bool> cancelReservation(String code, {String? reason}) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/reservations/$code/cancel',
        data: reason != null ? {'reason': reason} : null,
      );
      final data = response.data?['data'];
      if (data is bool) {
        return data;
      }
      return true;
    });
  }

  @override
  Future<VehicleBookingSummaryModel> getVehicleDetail(int vehicleId) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/vehicles/id/$vehicleId',
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return VehicleBookingSummaryModel.fromJson(data);
      }
      throw const ParsingException('Không tìm thấy thông tin xe.');
    });
  }

  @override
  Future<bool> confirmPayOSPayment(String reservationCode) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/payment/payos/confirm/$reservationCode',
      );
      final status = response.data?['status'];
      return status == 200 || status == 201;
    });
  }

  @override
  Future<PayOSPaymentInfoModel> createPayOSPaymentLink(int reservationId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/payment/payos/create-link/$reservationId',
      );
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return PayOSPaymentInfoModel.fromJson(data);
      }
      throw const ParsingException(
        'Không thể lấy thông tin thanh toán PayOS từ hệ thống.',
      );
    });
  }
}
