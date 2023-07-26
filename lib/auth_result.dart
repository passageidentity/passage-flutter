class AuthResult {
  final String authToken;
  final String? refreshToken;
  final String? refreshTokenExpiration;
  final String? redirectUrl;

  AuthResult.fromMap(Map<String, dynamic> map)
      : authToken = map['auth_token'],
        refreshToken = map['refresh_token'],
        refreshTokenExpiration = map['refresh_token_expiration'],
        redirectUrl = map['redirect_url'];
}
