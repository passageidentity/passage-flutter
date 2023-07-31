import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';

class PassageFlutter {
  Future<AuthResult> register(String identifier) {
    return PassageFlutterPlatform.instance.register(identifier);
  }

  Future<AuthResult> login() {
    return PassageFlutterPlatform.instance.login();
  }

  Future<AuthResult> loginWithIdentifier(String identifier) {
    return PassageFlutterPlatform.instance.loginWithIdentifier(identifier);
  }

  Future<String> newRegisterOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance
        .newRegisterOneTimePasscode(identifier);
  }

  Future<String> newLoginOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance.newLoginOneTimePasscode(identifier);
  }

  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) {
    return PassageFlutterPlatform.instance.oneTimePasscodeActivate(otp, otpId);
  }

  Future<String> newRegisterMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newRegisterMagicLink(identifier);
  }

  Future<String> newLoginMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newLoginMagicLink(identifier);
  }

  Future<AuthResult> magicLinkActivate(String magicLink) {
    return PassageFlutterPlatform.instance.magicLinkActivate(magicLink);
  }

  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) {
    return PassageFlutterPlatform.instance.getMagicLinkStatus(magicLinkId);
  }
}
