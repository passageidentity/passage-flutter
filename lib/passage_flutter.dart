import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';
import 'package:passage_flutter/app_info.dart';
import 'package:passage_flutter/user_info.dart';

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

  Future<String?> getAuthToken() {
    return PassageFlutterPlatform.instance.getAuthToken();
  }

  Future<bool> isAuthTokenValid(String authToken) {
    return PassageFlutterPlatform.instance.isAuthTokenValid(authToken);
  }

  Future<String> refreshAuthToken() {
    return PassageFlutterPlatform.instance.refreshAuthToken();
  }

  Future<PassageAppInfo?> getAppInfo() {
    return PassageFlutterPlatform.instance.getAppInfo();
  }

  Future<PassageUser?> getCurrentUser() {
    return PassageFlutterPlatform.instance.getCurrentUser();
  }

  Future<void> signOut() {
    return PassageFlutterPlatform.instance.signOut();
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
