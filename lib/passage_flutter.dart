import 'package:passage_flutter/passage_hosted.dart';
import 'package:passage_flutter/passage_otp.dart';
import 'package:passage_flutter/passage_magliclink.dart';
import 'package:passage_flutter/passage_passkey.dart';
import 'package:passage_flutter/passage_social.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageFlutter {
  late final PassagePasskey passkey;
  late final PassageSocial social;
  late final PassageOneTimePasscode oneTimePasscode;
  late final PassageMagliclink magliclink;
  late final PassageHosted hosted;
  PassageFlutter([String? appId]) {
    if (appId != null) {
      PassageFlutterPlatform.instance.initWithAppId(appId);
    }
    passkey = PassagePasskey();
    social = PassageSocial();
    oneTimePasscode = PassageOneTimePasscode();
    magliclink = PassageMagliclink();
    hosted = PassageHosted();
  }

  Future<void> overrideBasePath(String path) async {
    return await PassageFlutterPlatform.instance
        .overrideBasePath(path);
  }

  // TOKEN METHODS

  /// Returns the auth token for the currently authenticated user.
  ///
  /// Returns:
  ///  A `Future<String?>` representing the current Passage user's auth token,
  ///  or `null` if no token has been stored.
  Future<String?> getAuthToken() {
    return PassageFlutterPlatform.instance.getAuthToken();
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
  ///  A `Future<String>` representing the new auth token.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> refreshAuthToken() {
    return PassageFlutterPlatform.instance.refreshAuthToken();
  }

  /// Sign out a user by deleting their auth token and refresh token from device, and revoking their refresh token.
  Future<void> signOut() {
    return PassageFlutterPlatform.instance.signOut();
  }

}
