import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';

@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) = _AuthTokens;
}
