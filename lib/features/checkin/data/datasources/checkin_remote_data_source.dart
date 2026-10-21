import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rental_car/core/config/app_config.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/checkin/data/models/docuseal_contract_model.dart';
import 'package:rental_car/features/checkin/data/models/license_status_model.dart';
import 'package:rental_car/features/checkin/data/models/pickup_checklist_model.dart';
import 'package:rental_car/features/checkin/domain/entities/pickup_checklist_entity.dart';

abstract interface class CheckinRemoteDataSource {
  Future<LicenseStatusModel> getLicenseStatus();

  Future<String> uploadCarImage(String filePath);

  Future<PickupChecklistModel> createPickupChecklist({
    required int rentalId,
    required int odometer,
    required int batteryPercentage,
    required AccessoryChecklistEntity accessories,
    required CarImagesEntity images,
    String? note,
  });

  Future<DocuSealContractModel> generateContract(int rentalId);

  Future<ContractConfirmResultModel> confirmContractSigned(int rentalId);
}

class CheckinRemoteDataSourceImpl implements CheckinRemoteDataSource {
  CheckinRemoteDataSourceImpl({required Dio dio, Dio? cloudinaryDio})
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
  Future<LicenseStatusModel> getLicenseStatus() {
    return guardApiCall(() async {
      try {
        final response = await _dio.get<Map<String, dynamic>>(
          '/users/me/license-status',
        );
        final data = response.data?['data'];
        if (data is Map<String, dynamic>) {
          return LicenseStatusModel.fromJson(data);
        }
      } on DioException catch (e) {
        // Fallback: nếu /users/me/license-status 404 thì kiểm tra qua /users/me
        if (e.response?.statusCode == 404) {
          final profileRes = await _dio.get<Map<String, dynamic>>('/users/me');
          final profileData = profileRes.data?['data'] as Map<String, dynamic>?;
          if (profileData != null) {
            final docs = profileData['documents'] as List<dynamic>? ?? [];
            for (final d in docs) {
              if (d is Map<String, dynamic>) {
                final type = (d['type'] as String?)?.toUpperCase();
                if (type == 'LICENSE') {
                  final status =
                      (d['status'] as String?)?.toUpperCase() ?? 'NONE';
                  return LicenseStatusModel(
                    userId: profileData['id'] as int? ?? 0,
                    licenseStatus: status,
                    licenseNumber: d['number'] as String?,
                    licenseExpiryDate: d['expiryDate'] as String?,
                    rejectReason: d['rejectReason'] as String?,
                  );
                }
              }
            }
            return LicenseStatusModel(
              userId: profileData['id'] as int? ?? 0,
              licenseStatus: 'NOT_SUBMITTED',
            );
          }
        }
        rethrow;
      }
      return const LicenseStatusModel(
        userId: 0,
        licenseStatus: 'NOT_SUBMITTED',
      );
    });
  }

  @override
  Future<String> uploadCarImage(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw const ServerException(
          message: 'Tập tin ảnh không tồn tại trên thiết bị.',
        );
      }

      final fileName = filePath.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'upload_preset': AppConfig.cloudinaryUploadPreset,
        'folder': 'rental_checklists',
      });

      final response = await _effectiveCloudinaryDio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/${AppConfig.cloudinaryCloudName}/image/upload',
        data: formData,
      );

      final secureUrl = response.data?['secure_url'] as String?;
      if (secureUrl == null || secureUrl.isEmpty) {
        throw const ServerException(
          message: 'Không nhận được URL ảnh từ máy chủ Cloudinary.',
        );
      }
      return secureUrl;
    } on DioException catch (e) {
      String errorMsg = e.message ?? 'Tải ảnh lên máy chủ thất bại.';
      final respData = e.response?.data;
      if (respData is Map<String, dynamic>) {
        final errObj = respData['error'];
        if (errObj is Map<String, dynamic>) {
          errorMsg = errObj['message'] as String? ?? errorMsg;
        }
      }
      throw ServerException(message: errorMsg);
    }
  }

  @override
  Future<PickupChecklistModel> createPickupChecklist({
    required int rentalId,
    required int odometer,
    required int batteryPercentage,
    required AccessoryChecklistEntity accessories,
    required CarImagesEntity images,
    String? note,
  }) {
    return guardApiCall(() async {
      final allUrls = images.allUrls;
      final joinedImg = allUrls.join('|');
      final body = <String, dynamic>{
        'rentalId': rentalId,
        'checklistType': 'PICKUP',
        'type': 'CHECK_IN',
        'odometer': odometer,
        'batteryPercentage': batteryPercentage,
        'currentBattery': batteryPercentage,
        'img': joinedImg,
        'accessories': accessories.toJson(),
        'images': images.toJson(),
      };
      if (note != null && note.trim().isNotEmpty) {
        body['note'] = note.trim();
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/rental-checklists',
        data: body,
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return PickupChecklistModel.fromJson(data);
      }
      throw const ParsingException(
        'Không nhận được dữ liệu biên bản nhận xe từ máy chủ.',
      );
    });
  }

  @override
  Future<DocuSealContractModel> generateContract(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<dynamic>('/rentals/$rentalId/contract');

      final respData = response.data;
      dynamic data;
      if (respData is Map<String, dynamic>) {
        data = respData['data'];
      } else {
        data = respData;
      }

      if (data is Map<String, dynamic>) {
        return DocuSealContractModel.fromJson(data);
      }
      if (data is String && data.isNotEmpty) {
        return DocuSealContractModel(
          rentalId: rentalId,
          contractId: rentalId,
          contractCode: 'HD-$rentalId',
          contractStatus: 'PENDING_SIGNATURE',
          signingUrl: data,
        );
      }
      throw const ParsingException(
        'Không nhận được đường dẫn hợp đồng DocuSeal từ máy chủ.',
      );
    });
  }

  @override
  Future<ContractConfirmResultModel> confirmContractSigned(int rentalId) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/$rentalId/contract/confirm-signed',
      );

      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        return ContractConfirmResultModel.fromJson(data);
      }
      // Trả về mặc định nếu API trả về success mà không bọc data
      return ContractConfirmResultModel(
        rentalId: rentalId,
        status: 'ACTIVE',
        contractStatus: 'SIGNED',
        activatedAt: DateTime.now(),
      );
    });
  }
}
