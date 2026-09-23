import 'package:rental_car/core/utils/result.dart';
import 'package:rental_car/features/profile/domain/entities/kyc_document_entity.dart';
import 'package:rental_car/features/profile/domain/entities/rental_item_entity.dart';
import 'package:rental_car/features/profile/domain/entities/user_profile_entity.dart';

abstract interface class ProfileRepository {
  /// Lấy thông tin cá nhân của người dùng hiện tại
  Future<Result<UserProfileEntity>> getProfile();

  /// Cập nhật thông tin cá nhân (họ tên, số điện thoại)
  Future<Result<UserProfileEntity>> updateProfile({
    required String fullName,
    required String phone,
  });

  /// Tải lên và xác thực giấy tờ KYC (GPLX hoặc CCCD)
  Future<Result<KycDocumentEntity>> uploadKycDocument({
    required String imagePath,
    required DocumentType type,
    required String number,
    String? licenseClass,
    DateTime? expiryDate,
    required String email,
  });

  /// Lấy danh sách giấy tờ KYC của người dùng
  Future<Result<List<KycDocumentEntity>>> getKycDocuments(String email);

  /// Xóa / Gỡ giấy tờ KYC
  Future<Result<void>> deleteDocument(int docId);

  /// Lấy lịch sử thuê xe của người dùng
  Future<Result<List<RentalItemEntity>>> getRentalHistory({
    required String email,
    List<String>? status,
    int page = 1,
    int limit = 10,
    String search = '',
  });
}
