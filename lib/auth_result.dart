import 'dart:convert';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

class AuthResult {
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
    Map<String, dynamic> map = jsonDecode(jsonString);
    return AuthResult.fromMap(map);
  }

  factory AuthResult.fromJSObject(jsObject) {
    final Map<String, dynamic> resultMap = Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
    return AuthResult.fromMap(resultMap);
  }
}
