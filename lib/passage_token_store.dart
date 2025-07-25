import 'package:passage_flutter/passage_flutter_models/auth_result.dart';

import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageTokenStore {

  /// Returns the auth token for the currently authenticated user.
  /// If the stored auth token is invalid, this method will use the refresh token to get and save a new auth token.
  ///
  /// Returns:
  ///  A `Future<String>` representing the user's auth token,
  /// Throws:
  ///  `PassageError`
  Future<String> getValidAuthToken() {
    return PassageFlutterPlatform.instance.getValidAuthToken();
  }

  /// Checks if the auth token for the currently authenticated user is valid.
  ///
  /// Returns:
  ///  A `Future<bool>` that returns `true` if the user has a valid auth token,
  ///  and `false` otherwise.
  Future<bool> isAuthTokenValid(String authToken) {
    return PassageFlutterPlatform.instance.isAuthTokenValid(authToken);
  }

  /// Refreshes, retrieves, and saves a new authToken for the currently authenticated user using their refresh token.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` representing the new auth token.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> refreshAuthToken() {
    return PassageFlutterPlatform.instance.refreshAuthToken();
  }

}