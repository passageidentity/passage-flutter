import 'package:passage_flutter/models/one_time_passcode.dart';
import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageOneTimePasscode { 

  /// Creates and sends a new one-time passcode for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///  - `language`: The language code for the one time passcode.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<OneTimePasscode> register(String identifier, {String? language}) async {
    String oneTimePasscodeId =  await PassageFlutterPlatform.instance
        .newRegisterOneTimePasscode(identifier, language);
    return OneTimePasscode(oneTimePasscodeId);

  }

  /// Creates and sends a new one-time passcode for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///  - `language`: The language code for the one time passcode.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`

  Future<OneTimePasscode> login(String identifier, {String? language}) async {
    String oneTimePasscodeId =  await  PassageFlutterPlatform.instance.newLoginOneTimePasscode(identifier, language);
    return OneTimePasscode(oneTimePasscodeId);
  }

  /// Activates a one-time passcode when a user inputs it. This function handles both login and registration one-time passcodes.
  ///
  /// Parameters:
  ///  - `oneTimePasscode`: The one-time passcode.
  ///  - `id`: The one-time passcode ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> activate(String oneTimePasscode, String id) {
    return PassageFlutterPlatform.instance.oneTimePasscodeActivate(oneTimePasscode, id);
  }

}
