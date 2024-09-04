import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/authenticator_attachment.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassagePasskey {

  /// Attempts to create and register a new user with a passkey.
  ///
  /// The method will try to register a user using the provided identifier which
  /// can be either an email address or a phone number.
  ///
  /// Parameters:
  ///  - `identifier`: Email address or phone for the user.
  ///  - `options`: Optional configuration for passkey creation.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - User already exists
  ///  - App configuration was not done properly
  ///  - etc.
  Future<AuthResult> register(String identifier,
      [PasskeyCreationOptions? options]) {
    return PassageFlutterPlatform.instance
     .registerWithPasskey(identifier, options);
  }

  /// Attempts to login a user with a passkey.
  ///
  /// Parameters:
  ///  - `identifier`: Email address or phone for the user (optional).
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - User does not exist
  ///  - App configuration was not done properly
  ///  - etc.
  Future<AuthResult> login([String? identifier]) {
    return PassageFlutterPlatform.instance.loginWithPasskey(identifier);
  }

  /// Checks if the device supports passkeys.
  ///
  /// This method will check if the current device is capable of supporting
  /// passkey-based authentication.
  ///
  /// Returns:
  ///  A `Future<bool>` that will be `true` if the device supports passkeys,
  ///  otherwise `false`.
  ///
  /// Usage:
  ///  This can be used to determine if passkey registration or login can be 
  ///  performed on the device before attempting to register or login the user 
  ///  with a passkey.
  ///
  /// Throws:
  ///  No specific exceptions are expected, but it's a good idea to handle any 
  ///  potential runtime errors related to platform-specific issues.
  Future<bool> deviceSupportsPasskeys() {
    return PassageFlutterPlatform.instance.deviceSupportsPasskeys();
  }
     
}
