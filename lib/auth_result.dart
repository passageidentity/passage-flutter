class AuthResult {
  final String? authToken;

  AuthResult({this.authToken});

  AuthResult.fromJson(Map<String, dynamic> json)
      : authToken = json['auth_token'];

  Map<String, dynamic> toJson() {
    return {
      'auth_token': authToken,
    };
  }
}
