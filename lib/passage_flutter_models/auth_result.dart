import 'passage_flutter_model.dart';
import '/helpers/data_conversion.dart'
    if (dart.library.js) '/helpers/data_conversion_web.dart';

class AuthResult implements PassageFlutterModel {
  final String authToken;
  final String? refreshToken;
  final int? refreshTokenExpiration;
  final String? redirectUrl;

  AuthResult.fromMap(Map<String, dynamic> map)
      : authToken = map['authToken'] ?? map['auth_token'],
        refreshToken = map['refreshToken'] ?? map['refresh_token'],
        refreshTokenExpiration =
            map['refreshTokenExpiration'] ?? map['refresh_token_expiration'],
        redirectUrl = map['redirectUrl'] ?? map['redirect_url'];

  factory AuthResult.fromJson(json) {
    return fromJson(json, AuthResult.fromMap);
  }
}
