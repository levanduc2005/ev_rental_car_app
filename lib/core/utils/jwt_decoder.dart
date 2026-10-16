import 'dart:convert';

/// Tiện ích giải mã JSON Web Token (JWT) an toàn trên thiết bị di động
/// Lưu ý: Mobile CHỈ giải mã phần Payload (Base64Url) để đọc thông tin (role, exp, email),
/// tuyệt đối KHÔNG cần và KHÔNG ĐƯỢC lưu trữ JWT_SECRET trên Mobile.
abstract final class JwtDecoder {
  /// Giải mã phần Payload của JWT ra `Map<String, dynamic>`
  static Map<String, dynamic>? tryDecodePayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedString = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decodedString);
      if (json is Map<String, dynamic>) {
        return json;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Trích xuất role từ token (hỗ trợ các claim chuẩn của Spring Security: role, roles, scope, authorities)
  static String? extractRole(String token) {
    final payload = tryDecodePayload(token);
    if (payload == null) return null;

    if (payload['role'] is String) return payload['role'] as String;
    if (payload['roleName'] is String) return payload['roleName'] as String;
    if (payload['scope'] is String) return payload['scope'] as String;

    if (payload['roles'] is List && (payload['roles'] as List).isNotEmpty) {
      return (payload['roles'] as List).first.toString();
    }
    if (payload['authorities'] is List &&
        (payload['authorities'] as List).isNotEmpty) {
      return (payload['authorities'] as List).first.toString();
    }

    return null;
  }

  /// Trích xuất email hoặc subject từ token
  static String? extractEmail(String token) {
    final payload = tryDecodePayload(token);
    if (payload == null) return null;

    return (payload['sub'] as String?) ?? (payload['email'] as String?);
  }

  /// Kiểm tra xem token đã hết hạn theo thời gian (exp) hay chưa
  static bool isExpired(String token) {
    final payload = tryDecodePayload(token);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp is num) {
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        exp.toInt() * 1000,
      );
      return DateTime.now().isAfter(expiryDate);
    }
    return false;
  }
}
