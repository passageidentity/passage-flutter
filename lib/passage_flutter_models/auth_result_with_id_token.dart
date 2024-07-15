import 'auth_result.dart';

class AuthResultWithIdToken {
  final AuthResult authResult;
  final String idToken;

  AuthResultWithIdToken(this.authResult, this.idToken);
}
