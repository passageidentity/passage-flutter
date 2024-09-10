import 'package:passage_flutter/models/magic_link.dart';
import 'package:passage_flutter/passage_flutter_models/passage_social_connection.dart';
import 'package:passage_flutter/passage_flutter_models/passkey.dart';
import 'models/meta_data.dart';
import 'passage_flutter_models/authenticator_attachment.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageCurrentUser {

  /// Returns the user information for the currently authenticated user.
  ///
  /// Returns:
  ///  A `Future<CurrentUser>` representing the current Passage user's info,
  ///  or `null` if the current Passage user's authentication token could not be validated.
  Future<CurrentUser> userInfo() {
    return PassageFlutterPlatform.instance.getCurrentUser();
  }

  /// Initiates an email change for the authenticated user. An email change requires verification,
  /// so an email will be sent to the user which they must verify before the email change takes effect.
  ///
  /// Parameters:
  ///  - `newEmail`: The user's new email.
  ///
  /// Returns:
  ///  A `Future<MagicLink>` representing the magic link
  ///
  /// Throws:
  ///  `PassageError`
  Future<MagicLink> changeEmail(String newEmail, String? language) {
    return PassageFlutterPlatform.instance.changeEmail(newEmail);
  }

  /// Initiates a phone number change for the authenticated user. A phone change requires verification,
  /// so an email will be sent to the user which they must verify before the phone change takes effect.
  ///
  /// Parameters:
  ///  - `newPhone`: The user's new phone number.
  ///
  /// Returns:
  ///  A `Future<MagicLink>` representing the magic link
  ///
  /// Throws:
  ///  `PassageError`
  Future<MagicLink> changePhone(String newPhone,String? language) {
    return PassageFlutterPlatform.instance.changePhone(newPhone);
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
  Future<Passkey> editPasskey(String passkeyId, String friendlyName) {
    return PassageFlutterPlatform.instance
        .editPasskeyName(passkeyId, friendlyName);
  }

  Future<List<Passkey>>? passkeys() {
    // TODO: implement passkeys - After updating the code with new Android, JS, and iOS code 
    return null;
  }

  Future<List<SocialConnection>>? socialConnections() {
    // TODO: implement socialConnections - After updating the code with new Android, JS, and iOS code 
    return null;
  }

  Future<void>? deleteSocialConnection(SocialConnection socialConnectionType) {
    // TODO: implement deleteSocialConnection - After updating the code with new Android, JS, and iOS code 
    return null;
  }

  Future<Metadata>? metadata() {
    // TODO: implement metadata - After updating the code with new Android, JS, and iOS code 
    return null;
  }

  Future<CurrentUser>? updateMetadata(Metadata metaData) {
    // TODO: implement updateMetadata - After updating the code with new Android, JS, and iOS code 
    return null;
  }

}