import '../helpers/data_conversion.dart';
import 'passage_flutter_model.dart';

class AuthResult implements PassageFlutterModel {
  final String authToken;
  final String? refreshToken;
  final String? refreshTokenExpiration;
  final String? redirectUrl;

  AuthResult.fromMap(Map<String, dynamic> map)
      : authToken = map['authToken'] ?? map['auth_token'],
        refreshToken = map['refreshToken'] ?? map['refresh_token'],
        refreshTokenExpiration =
            map['refreshTokenExpiration'] ?? map['refresh_token_expiration'],
        redirectUrl = map['redirectUrl'] ?? map['redirect_url'];

  factory AuthResult.fromJson(String jsonString) {
    return fromJson(jsonString, AuthResult.fromMap);
  }

  factory AuthResult.fromJSObject(jsObject) {
    return fromJSObject(jsObject, AuthResult.fromMap);
  }
}
