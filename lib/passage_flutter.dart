import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/passage_app_info.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_models/passkey.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageFlutter {
  // PASSKEY AUTH METHODS

  Future<AuthResult> register(String identifier) {
    return PassageFlutterPlatform.instance.register(identifier);
  }

  Future<AuthResult> login() {
    return PassageFlutterPlatform.instance.login();
  }

  Future<AuthResult> loginWithIdentifier(String identifier) {
    return PassageFlutterPlatform.instance.loginWithIdentifier(identifier);
  }

  Future<bool> deviceSupportsPasskeys() {
    return PassageFlutterPlatform.instance.deviceSupportsPasskeys();
  }

  // OTP METHODS

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

  // MAGIC LINK METHODS

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

  // TOKEN METHODS

  Future<String?> getAuthToken() {
    return PassageFlutterPlatform.instance.getAuthToken();
  }

  Future<bool> isAuthTokenValid(String authToken) {
    return PassageFlutterPlatform.instance.isAuthTokenValid(authToken);
  }

  Future<String> refreshAuthToken() {
    return PassageFlutterPlatform.instance.refreshAuthToken();
  }

  Future<void> signOut() {
    return PassageFlutterPlatform.instance.signOut();
  }

  // APP METHODS

  Future<PassageAppInfo?> getAppInfo() {
    return PassageFlutterPlatform.instance.getAppInfo();
  }

  // USER METHODS

  Future<PassageUser?> getCurrentUser() {
    return PassageFlutterPlatform.instance.getCurrentUser();
  }

  Future<Passkey> addPasskey() {
    return PassageFlutterPlatform.instance.addPasskey();
  }

  Future<void> deletePasskey(String passkeyId) {
    return PassageFlutterPlatform.instance.deletePasskey(passkeyId);
  }

  Future<Passkey> editPasskeyName(String passkeyId, String newPasskeyName) {
    return PassageFlutterPlatform.instance
        .editPasskeyName(passkeyId, newPasskeyName);
  }

  Future<String> changeEmail(String newEmail) {
    return PassageFlutterPlatform.instance.changeEmail(newEmail);
  }

  Future<String> changePhone(String newPhone) {
    return PassageFlutterPlatform.instance.changePhone(newPhone);
  }
}
