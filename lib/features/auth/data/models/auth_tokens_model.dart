import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rental_car/features/auth/domain/entities/auth_tokens.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

@freezed
abstract class AuthTokensModel with _$AuthTokensModel {
  const factory AuthTokensModel({
    @JsonKey(name: 'token') required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);
}

extension AuthTokensModelX on AuthTokensModel {
  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
