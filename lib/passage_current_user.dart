import 'package:passage_flutter/models/magic_link.dart';
import 'package:passage_flutter/passage_flutter_models/passage_social_connection.dart';
import 'package:passage_flutter/passage_flutter_models/passkey.dart';
import 'passage_flutter_models/meta_data.dart';
import 'passage_flutter_models/authenticator_attachment.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_models/passage_user_social_connections.dart';
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
  Future<MagicLink> changeEmail(String newEmail, {String? language}) {
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
  Future<MagicLink> changePhone(String newPhone, {String? language}) {
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

  /// Retrieves a list of WebAuthn passkeys associated with the authenticated user.
/// 
/// Returns:
///  A `Future<List<Passkey>>` containing all WebAuthn passkeys for the current user.
/// 
/// Throws:
///  `PassageError` if an error occurs during the retrieval process.
Future<List<Passkey>>? passkeys() {
  return PassageFlutterPlatform.instance.passkeys();
}

/// Retrieves the social connections for the authenticated user.
/// 
/// Returns:
///  A `Future<UserSocialConnections?>` containing the social connections of the user.
/// 
/// Throws:
///  `PassageError` if an error occurs during the retrieval process.
Future<UserSocialConnections?> socialConnections() {
  return PassageFlutterPlatform.instance.socialConnections();
}

/// Deletes a social connection for the authenticated user.
/// 
/// Parameters:
///  - `socialConnectionType`: The type of social connection to delete.
/// 
/// Returns:
///  A `Future<void>` that resolves when the social connection is deleted.
/// 
/// Throws:
///  `PassageError` if an error occurs during the deletion process.
Future<void>? deleteSocialConnection(SocialConnection socialConnectionType) {
  return PassageFlutterPlatform.instance.deleteSocialConnection(socialConnectionType);
}

/// Fetches the metadata associated with the authenticated user.
/// 
/// Returns:
///  A `Future<Metadata>` containing the metadata for the user.
/// 
/// Throws:
///  `PassageError` if an error occurs during the retrieval process.
Future<Metadata?> metadata() {
  return PassageFlutterPlatform.instance.metaData();
}

/// Updates the metadata associated with the authenticated user.
/// 
/// Parameters:
///  - `metaData`: The new metadata to update for the user.
/// 
/// Returns:
///  A `Future<CurrentUser>` containing the updated information of the user.
/// 
/// Throws:
///  `PassageError` if an error occurs during the update process.
Future<CurrentUser>? updateMetadata(Metadata metaData) {
  return PassageFlutterPlatform.instance.updateMetaData(metaData);
}

/// Signs out the current user, clearing local tokens and logging out of the system.
/// 
/// Returns:
///  A `Future<void>` that resolves when the user is successfully signed out.
/// 
/// Throws:
///  `PassageError` if an error occurs during the sign-out process.
Future<void>? logout() {
  return PassageFlutterPlatform.instance.signOut();
}

}
