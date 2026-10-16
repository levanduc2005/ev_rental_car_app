import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:rental_car/core/utils/jwt_decoder.dart';

void main() {
  group('JwtDecoder', () {
    String makeJwt(Map<String, dynamic> payload) {
      final header = base64Url
          .encode(utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})))
          .replaceAll('=', '');
      final pay = base64Url
          .encode(utf8.encode(jsonEncode(payload)))
          .replaceAll('=', '');
      return '$header.$pay.signature';
    }

    test('extracts role directly from payload role claim', () {
      final token = makeJwt({'role': 'ROLE_STAFF', 'sub': 'staff@emotion.vn'});
      expect(JwtDecoder.extractRole(token), 'ROLE_STAFF');
      expect(JwtDecoder.extractEmail(token), 'staff@emotion.vn');
    });

    test('extracts role from scope or roles or authorities list', () {
      final tokenScope = makeJwt({'scope': 'ROLE_ADMIN'});
      expect(JwtDecoder.extractRole(tokenScope), 'ROLE_ADMIN');

      final tokenRoles = makeJwt({
        'roles': ['ROLE_STAFF', 'ROLE_USER'],
      });
      expect(JwtDecoder.extractRole(tokenRoles), 'ROLE_STAFF');

      final tokenAuthorities = makeJwt({
        'authorities': ['ROLE_MANAGER'],
      });
      expect(JwtDecoder.extractRole(tokenAuthorities), 'ROLE_MANAGER');
    });

    test('returns null for invalid or malformed tokens without crashing', () {
      expect(JwtDecoder.extractRole('invalid.token'), isNull);
      expect(JwtDecoder.extractRole(''), isNull);
      expect(JwtDecoder.tryDecodePayload('abc'), isNull);
    });

    test('isExpired detects future and past expirations', () {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final futureToken = makeJwt({'exp': now + 3600});
      final pastToken = makeJwt({'exp': now - 3600});

      expect(JwtDecoder.isExpired(futureToken), isFalse);
      expect(JwtDecoder.isExpired(pastToken), isTrue);
    });
  });
}
