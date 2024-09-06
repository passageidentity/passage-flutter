import 'package:passage_flutter/passage_hosted.dart';
import 'package:passage_flutter/passage_otp.dart';
import 'package:passage_flutter/passage_magliclink.dart';
import 'package:passage_flutter/passage_passkey.dart';
import 'package:passage_flutter/passage_social.dart';
import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/authenticator_attachment.dart';
import 'passage_flutter_models/passage_app_info.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_models/passkey.dart';
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

  // APP METHODS

  /// Gets information about an app.
  ///
  /// Returns:
  ///  A `Future<PassageAppInfo>` object containing app information, authentication policy, etc.
  ///
  /// Throws:
  ///  `PassageError`
  Future<PassageAppInfo?> getAppInfo() {
    return PassageFlutterPlatform.instance.getAppInfo();
  }

  Future<PassageUser?> identifierExists(String identifier) {
    return PassageFlutterPlatform.instance.identifierExists(identifier);
  }

  // USER METHODS

  /// Returns the user information for the currently authenticated user.
  ///
  /// Returns:
  ///  A `Future<PassageUser?>` representing the current Passage user's info,
  ///  or `null` if the current Passage user's authentication token could not be validated.
  Future<PassageUser?> getCurrentUser() {
    return PassageFlutterPlatform.instance.getCurrentUser();
  }

  /// Attempts to create and register a new passkey for the authenticated user.
  ///
  /// Parameters:
  ///  - `options`: Optional configuration for passkey creation.
  ///
  /// Returns:
  ///  A `Future<Passkey>` representing an object containing all of the data about the new passkey.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - App configuration was not done properly
  ///  - etc.
  Future<Passkey> addPasskey([PasskeyCreationOptions? options]) {
    return PassageFlutterPlatform.instance.addPasskey(options);
  }

  /// Removes a passkey from a user's account.
  /// NOTE: This does NOT remove the passkey from the user's device, but revokes that passkey so it's no longer usable.
  ///
  /// Parameters:
  ///  - `passkeyId`: The ID of the passkey to delete.
  ///
  /// Throws:
  ///  `PassageError`
  Future<void> deletePasskey(String passkeyId) {
    return PassageFlutterPlatform.instance.deletePasskey(passkeyId);
  }

  /// Edits the `friendlyName` of the authenticated user's device passkey.
  ///
  /// Parameters:
  ///  - `passkeyId`: The ID of the passkey to edit.
  ///  - `newPasskeyName`: The new name for the passkey.
  ///
  /// Returns:
  ///  A `Future<Passkey>` object containing all of the data about the updated passkey.
  ///
  /// Throws:
  ///  `PassageError`
  Future<Passkey> editPasskeyName(String passkeyId, String newPasskeyName) {
    return PassageFlutterPlatform.instance
        .editPasskeyName(passkeyId, newPasskeyName);
  }

  /// Initiates an email change for the authenticated user. An email change requires verification,
  /// so an email will be sent to the user which they must verify before the email change takes effect.
  ///
  /// Parameters:
  ///  - `newEmail`: The user's new email.
  ///
  /// Returns:
  ///  A `Future<String>` representing the magic link ID.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> changeEmail(String newEmail) {
    return PassageFlutterPlatform.instance.changeEmail(newEmail);
  }

  /// Initiates a phone number change for the authenticated user. A phone change requires verification,
  /// so an email will be sent to the user which they must verify before the phone change takes effect.
  ///
  /// Parameters:
  ///  - `newPhone`: The user's new phone number.
  ///
  /// Returns:
  ///  A `Future<String>` representing the magic link ID.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> changePhone(String newPhone) {
    return PassageFlutterPlatform.instance.changePhone(newPhone);
  }

}
