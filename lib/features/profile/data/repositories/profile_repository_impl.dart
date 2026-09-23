import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/core/utils/safe_call.dart';
import 'package:rental_car/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:rental_car/features/profile/data/models/kyc_document_model.dart';
import 'package:rental_car/features/profile/data/models/user_profile_model.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';
import 'package:rental_car/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<UserProfileEntity>> getProfile() {
    return safeCall(() async {
      final model = await _remoteDataSource.getProfile();
      return model.toEntity();
    });
  }

  @override
  Future<Result<UserProfileEntity>> updateProfile({
    required String fullName,
    required String phone,
  }) {
    return safeCall(() async {
      final model = await _remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<KycDocumentEntity>> uploadKycDocument({
    required String imagePath,
    required DocumentType type,
    required String number,
    String? licenseClass,
    DateTime? expiryDate,
    required String email,
  }) {
    return safeCall(() async {
      // 1. Tải ảnh lên để lấy đường dẫn
      final imgUrl = await _remoteDataSource.uploadImage(imagePath);

      // 2. Gửi tạo tài liệu và xác thực OCR tự động từ backend
      final typeString = type == DocumentType.license ? 'LICENSE' : 'CCCD';
      final model = await _remoteDataSource.uploadDocument(
        imgUrl: imgUrl,
        type: typeString,
        number: number,
        email: email,
      );

      final entity = model.toEntity();
      return entity.copyWith(
        licenseClass: licenseClass ?? entity.licenseClass,
        expiryDate: expiryDate ?? entity.expiryDate,
      );
    });
  }

  @override
  Future<Result<List<KycDocumentEntity>>> getKycDocuments(String email) {
    return safeCall(() async {
      final models = await _remoteDataSource.getDocuments(email);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Result<void>> deleteDocument(int docId) {
    return safeCall(() async {
      await _remoteDataSource.deleteDocument(docId);
    });
  }

  @override
  Future<Result<List<RentalItemEntity>>> getRentalHistory({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 10,
    String search = '',
  }) {
    return safeCall(() async {
      final models = await _remoteDataSource.getRentalHistory(
        email: email,
        status: status,
        page: page,
        limit: limit,
        search: search,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }
}
