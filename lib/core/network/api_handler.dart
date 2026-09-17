import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';

/// Hàm bọc tập trung cho toàn bộ các cuộc gọi API trong toàn bộ dự án
Future<T> guardApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(
        'Không thể kết nối tới máy chủ. Vui lòng kiểm tra mạng.',
        e,
      );
    }

    final response = e.response;
    if (response != null) {
      String message = 'Đã có lỗi xảy ra từ máy chủ.';
      if (response.data is Map<String, dynamic>) {
        message =
            (response.data as Map<String, dynamic>)['message'] as String? ??
            message;
      }
      throw ServerException(
        statusCode: response.statusCode,
        message: message,
        cause: e,
      );
    }

    throw ServerException(
      message: e.message ?? 'Lỗi không xác định.',
      cause: e,
    );
  } catch (e) {
    if (e is ServerException ||
        e is NetworkException ||
        e is ParsingException) {
      rethrow;
    }
    throw ServerException(message: e.toString(), cause: e);
  }
}
