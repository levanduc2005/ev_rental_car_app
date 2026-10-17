import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rental_car/core/config/app_config.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/emergency/data/models/sos_report_model.dart';

abstract interface class EmergencyRemoteDataSource {
  Future<String> uploadIncidentImage(String filePath);

  Future<SosReportModel> submitReport({
    required String title,
    required String description,
    required String type,
    String? userEmail,
  });

  Future<List<SosReportModel>> getEmergencyReports();
}

class EmergencyRemoteDataSourceImpl implements EmergencyRemoteDataSource {
  const EmergencyRemoteDataSourceImpl({required Dio dio, Dio? cloudinaryDio})
    : _dio = dio,
      _cloudinaryDio = cloudinaryDio;

  final Dio _dio;
  final Dio? _cloudinaryDio;

  Dio get _effectiveCloudinaryDio =>
      _cloudinaryDio ??
      Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

  @override
  Future<String> uploadIncidentImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw const ServerException(
          message: 'File ảnh chụp hiện trường không tồn tại trên thiết bị.',
        );
      }

      final fileName = filePath.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'upload_preset': AppConfig.cloudinaryUploadPreset,
        'folder': 'emergency_reports',
      });

      final response = await _effectiveCloudinaryDio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/${AppConfig.cloudinaryCloudName}/image/upload',
        data: formData,
      );

      final secureUrl = response.data?['secure_url'] as String?;
      if (secureUrl == null || secureUrl.isEmpty) {
        throw const ServerException(
          message:
              'Tải ảnh hiện trường lên máy chủ thất bại: Không nhận được URL ảnh.',
        );
      }

      return secureUrl;
    } on DioException catch (e) {
      String errorMsg = e.message ?? 'Lỗi không xác định.';
      final respData = e.response?.data;
      if (respData is Map<String, dynamic>) {
        final errObj = respData['error'];
        if (errObj is Map<String, dynamic>) {
          errorMsg = errObj['message'] as String? ?? errorMsg;
        }
      }
      throw ServerException(
        message: 'Tải ảnh hiện trường lên Cloudinary thất bại: $errorMsg',
        cause: e,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        message: 'Lỗi tải ảnh hiện trường lên Cloudinary: $e',
        cause: e,
      );
    }
  }

  @override
  Future<SosReportModel> submitReport({
    required String title,
    required String description,
    required String type,
    String? userEmail,
  }) {
    return guardApiCall(() async {
      final payload = <String, dynamic>{
        'title': title,
        'description': description,
        'type': type,
        'userEmail': ?userEmail,
      };

      final response = await _dio.post<Map<String, dynamic>>(
        '/reports',
        data: payload,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return SosReportModel.fromJson(data);
      }
      throw const ParsingException(
        'Dữ liệu báo cáo sự cố trả về không hợp lệ.',
      );
    });
  }

  @override
  Future<List<SosReportModel>> getEmergencyReports() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/reports');
      final data = response.data?['data'];
      if (data is List) {
        return data
            .map(
              (item) => SosReportModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return const [];
    });
  }
}
