import 'package:passage_flutter/models/magic_link.dart';
import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageMagiclink {

  /// Creates and sends a new magic link for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///  - `language`: The language code for the magic link.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a magic link ID used to check the status
  ///  of the magic link with `getMagicLinkStatus`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<MagicLink> register(String identifier, {String? language}) async {
    String magicLinkId = await PassageFlutterPlatform.instance.newRegisterMagicLink(identifier);
    return MagicLink(magicLinkId);
  }


  /// Creates and sends a new magic link for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///  - `language`: The language code for the magic link.
  ///
  /// Returns:
  ///  A `Future<MagicLink>` containing the magic link ID, which can be used to track the
  ///  magic link's status using the `getMagicLinkStatus` method.
  ///
  /// Throws:
  ///  `PassageError`
  Future<MagicLink> login(String identifier, {String? language}) async {
    String magicLinkId = await PassageFlutterPlatform.instance.newLoginMagicLink(identifier);
    return MagicLink(magicLinkId);
  }

  /// Activates a magic link. This function handles both login and registration magic links.
  ///
  /// Parameters:
  ///  - `magicLink`: The magic link from the URL sent to the user.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> activate(String magicLink) {
    return PassageFlutterPlatform.instance.magicLinkActivate(magicLink);
  }

  /// Looks up a magic link by ID and checks if it has been verified. This function is most commonly used to
  /// iteratively check if a user has clicked a magic link to login. Once the link has been verified,
  /// Passage will return authentication information via this function. This enables cross-device login.
  ///
  /// Parameters:
  ///  - `id`: The magic link ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult?>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device, or `null` if
  ///  the magic link has not been verified.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> status(String id) {
    return PassageFlutterPlatform.instance.getMagicLinkStatus(id);
  }

}
