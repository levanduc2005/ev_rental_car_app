import 'package:dio/dio.dart';
import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/network/api_handler.dart';
import 'package:rental_car/features/profile/data/models/kyc_document_model.dart';
import 'package:rental_car/features/profile/data/models/rental_item_model.dart';
import 'package:rental_car/features/profile/data/models/user_profile_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile({
    required String fullName,
    required String phone,
  });
  Future<String> uploadImage(String filePath);
  Future<KycDocumentModel> uploadDocument({
    required String imgUrl,
    required String type,
    required String number,
    required String email,
  });
  Future<List<KycDocumentModel>> getDocuments(String email);
  Future<void> deleteDocument(int docId);
  Future<List<RentalItemModel>> getRentalHistory({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 10,
    String search = '',
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<UserProfileModel> getProfile() {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ParsingException('Không tìm thấy dữ liệu người dùng.');
      }
      return UserProfileModel.fromJson(data);
    });
  }

  @override
  Future<UserProfileModel> updateProfile({
    required String fullName,
    required String phone,
  }) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/users/me/update-profile',
        data: {'fullName': fullName, 'phone': phone},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw const ParsingException('Không tìm thấy dữ liệu cập nhật.');
      }
      return UserProfileModel.fromJson(data);
    });
  }

  @override
  Future<String> uploadImage(String filePath) async {
    // Không gọi /media/upload vì backend nhận imgUrl trực tiếp tại POST /api/documents.
    return filePath;
  }

  @override
  Future<KycDocumentModel> uploadDocument({
    required String imgUrl,
    required String type,
    required String number,
    required String email,
  }) {
    return guardApiCall(() async {
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/documents',
          data: {
            'imgUrl': imgUrl,
            'type': type,
            'number': number,
            'email': email,
          },
        );

        final data = response.data?['data'] as Map<String, dynamic>?;
        if (data == null) {
          throw const ParsingException('Không tìm thấy dữ liệu giấy tờ.');
        }
        return KycDocumentModel.fromJson(data);
      } on ServerException catch (e) {
        // Ánh xạ mã lỗi OCR chi tiết từ backend sang thông điệp tiếng Việt thân thiện
        final mappedMessage = _mapKycErrorMessage(e.message);
        throw ServerException(
          statusCode: e.statusCode,
          message: mappedMessage,
          cause: e.cause,
        );
      }
    });
  }

  @override
  Future<List<KycDocumentModel>> getDocuments(String email) {
    return guardApiCall(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/documents/$email',
      );
      final data = response.data?['data'];
      if (data is List) {
        return data
            .map(
              (item) => KycDocumentModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return const [];
    });
  }

  @override
  Future<void> deleteDocument(int docId) {
    return guardApiCall(() async {
      await _dio.delete<Map<String, dynamic>>('/documents/$docId');
    });
  }

  @override
  Future<List<RentalItemModel>> getRentalHistory({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 10,
    String search = '',
  }) {
    return guardApiCall(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        '/rentals/email',
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
                    RentalItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }
      return const [];
    });
  }

  String _mapKycErrorMessage(String rawMessage) {
    if (rawMessage.contains('DOCUMENT_INVALID')) {
      return 'Ảnh tải lên không phải là CCCD hoặc GPLX hợp lệ.';
    }
    if (rawMessage.contains('DOCUMENT_NUMBER_MISMATCH')) {
      return 'Số GPLX/CCCD người dùng nhập không khớp với số trên ảnh chụp.';
    }
    if (rawMessage.contains('DOCUMENT_NUMBER_INVALID')) {
      return 'Định dạng số giấy tờ không đúng (phải từ 9 - 12 chữ số).';
    }
    if (rawMessage.contains('DOCUMENT_EXPIRED')) {
      return 'Giấy tờ đã quá hạn sử dụng, vui lòng cập nhật bằng mới.';
    }
    if (rawMessage.contains('LICENSE_NOT_VALID_FOR_VEHICLE')) {
      return 'Hạng bằng lái không đủ điều kiện thuê xe điện (chỉ chấp nhận B1, B2, BE, C, D, E).';
    }
    if (rawMessage.contains('DOCUMENT_NUMBER_EXISTS')) {
      return 'Số GPLX/CCCD này đã được đăng ký bởi một tài khoản khác.';
    }
    if (rawMessage.contains('USER_ALREADY_HAS_DOCUMENT_OF_TYPE')) {
      return 'Bạn đã nộp loại giấy tờ này rồi.';
    }
    return rawMessage;
  }
}
