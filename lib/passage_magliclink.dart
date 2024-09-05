import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageMagliclink {

  /// Creates and sends a new magic link for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a magic link ID used to check the status
  ///  of the magic link with `getMagicLinkStatus`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> register(String identifier) {
    return PassageFlutterPlatform.instance.newRegisterMagicLink(identifier);
  }


  /// Creates and sends a new magic link for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a magic link ID used to check the status
  ///  of the magic link with `getMagicLinkStatus`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> login(String identifier) {
    return PassageFlutterPlatform.instance.newLoginMagicLink(identifier);
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
  ///  - `magicLinkId`: The magic link ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult?>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device, or `null` if
  ///  the magic link has not been verified.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult?> status(String magicLinkId) {
    return PassageFlutterPlatform.instance.getMagicLinkStatus(magicLinkId);
  }

}
