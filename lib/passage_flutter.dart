import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';

class PassageFlutter {
  Future<AuthResult?> register(String identifier) {
    return PassageFlutterPlatform.instance.register(identifier);
  }

  Future<AuthResult?> login(String identifier) {
    return PassageFlutterPlatform.instance.login(identifier);
  }

  Future<String?> newRegisterOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance
        .newRegisterOneTimePasscode(identifier);
  }

  Future<String?> newLoginOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance.newLoginOneTimePasscode(identifier);
  }

  Future<String?> activateOneTimePasscode(String otp, String otpId) {
    return PassageFlutterPlatform.instance.activateOneTimePasscode(otp, otpId);
  }

  Future<String?> newRegisterMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newRegisterMagicLink(identifier);
  }

  Future<String?> newLoginMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newLoginMagicLink(identifier);
  }

  Future<String?> activateMagicLink(String magicLink) {
    return PassageFlutterPlatform.instance.activateMagicLink(magicLink);
  }
}
