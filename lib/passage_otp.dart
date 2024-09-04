
import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageOneTimePasscode { 

  /// Creates and sends a new one-time passcode for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> register(String identifier) {
    return PassageFlutterPlatform.instance
        .newRegisterOneTimePasscode(identifier);
  }

  /// Creates and sends a new one-time passcode for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`

  Future<String> login(String identifier) {
    return PassageFlutterPlatform.instance.newLoginOneTimePasscode(identifier);
  }

  /// Activates a one-time passcode when a user inputs it. This function handles both login and registration one-time passcodes.
  ///
  /// Parameters:
  ///  - `otp`: The one-time passcode.
  ///  - `otpId`: The one-time passcode ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> activate(String otp, String otpId) {
    return PassageFlutterPlatform.instance.oneTimePasscodeActivate(otp, otpId);
  }

}
