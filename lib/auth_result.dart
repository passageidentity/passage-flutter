import 'dart:convert';

class AuthResult {
  final String authToken;
  final String? refreshToken;
  final String? refreshTokenExpiration;
  final String? redirectUrl;

  AuthResult.fromMap(Map<String, dynamic> map)
      : authToken = map['authToken'],
        refreshToken = map['refreshToken'],
        refreshTokenExpiration = map['refreshTokenExpiration'],
        redirectUrl = map['redirectUrl'];

  factory AuthResult.fromJson(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return AuthResult.fromMap(map);
  }
}
