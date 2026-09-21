import 'dart:convert';

import 'package:rental_car/core/error/exceptions.dart';
import 'package:rental_car/core/storage/key_value_store.dart';
import 'package:rental_car/core/storage/secure_store.dart';
import 'package:rental_car/features/auth/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  /// Lưu access token và refresh token vào bộ nhớ mã hóa
  Future<void> saveTokens({required String accessToken, String? refreshToken});

  /// Lấy access token hiện tại
  Future<String?> getAccessToken();

  /// Lấy refresh token hiện tại
  Future<String?> getRefreshToken();

  /// Xoá tất cả tokens khi đăng xuất
  Future<void> clearTokens();

  /// Lưu cache thông tin người dùng
  Future<void> saveUser(UserModel user);

  /// Đọc thông tin người dùng từ cache
  Future<UserModel?> getUser();

  /// Xóa cache thông tin người dùng
  Future<void> clearUser();

  /// Đánh dấu đã bỏ qua bước hoàn tất hồ sơ
  Future<void> setProfileSetupSkipped(String email);

  /// Kiểm tra xem đã từng bỏ qua bước hoàn tất hồ sơ chưa
  Future<bool> isProfileSetupSkipped(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStore _secureStore;
  final KeyValueStore _keyValueStore;

  const AuthLocalDataSourceImpl({
    required SecureStore secureStore,
    required KeyValueStore keyValueStore,
  }) : _secureStore = secureStore,
       _keyValueStore = keyValueStore;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _userKey = 'auth_cached_user';
  static String _skippedProfileKey(String email) =>
      'auth_skipped_profile_$email';

  @override
  Future<void> clearTokens() async {
    try {
      await _secureStore.delete(_accessTokenKey);
      await _secureStore.delete(_refreshTokenKey);
    } catch (e) {
      throw CacheException('Không thể xóa token bảo mật.', e);
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _keyValueStore.remove(_userKey);
    } catch (e) {
      throw CacheException('Không thể xóa thông tin người dùng.', e);
    }
  }

  @override
  Future<String?> getAccessToken() => _secureStore.read(_accessTokenKey);

  @override
  Future<String?> getRefreshToken() => _secureStore.read(_refreshTokenKey);

  @override
  Future<UserModel?> getUser() async {
    try {
      final rawJson = await _keyValueStore.getString(_userKey);
      if (rawJson == null) return null;
      final map = jsonDecode(rawJson) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } on Exception catch (e) {
      throw CacheException('Không thể đọc thông tin người dùng', e);
    }
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      await _secureStore.write(_accessTokenKey, accessToken);
      if (refreshToken != null) {
        await _secureStore.write(_refreshTokenKey, refreshToken);
      }
    } catch (e) {
      throw CacheException('Không thể lưu trữ token bảo mật.', e);
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await _keyValueStore.setString(_userKey, jsonString);
    } on Exception catch (e) {
      throw CacheException('Không thể lưu thông tin người dùng.', e);
    }
  }

  @override
  Future<void> setProfileSetupSkipped(String email) async {
    try {
      await _keyValueStore.setBool(_skippedProfileKey(email), value: true);
    } catch (e) {
      throw CacheException('Không thể lưu trạng thái bỏ qua hồ sơ.', e);
    }
  }

  @override
  Future<bool> isProfileSetupSkipped(String email) async {
    try {
      final value = await _keyValueStore.getBool(_skippedProfileKey(email));
      return value ?? false;
    } catch (e) {
      throw CacheException('Không thể đọc trạng thái bỏ qua hồ sơ.', e);
    }
  }
}
