import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passkey.dart';
import 'passage_flutter_method_channel.dart';

abstract class PassageFlutterPlatform extends PlatformInterface {
  /// Constructs a PassageFlutterPlatform.
  PassageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PassageFlutterPlatform _instance = MethodChannelPassageFlutter();

  /// The default instance of [PassageFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelPassageFlutter].
  static PassageFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PassageFlutterPlatform] when
  /// they register themselves.
  static set instance(PassageFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // PASSKEY AUTH METHODS

  Future<AuthResult> register(String identifier) {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<AuthResult> login() {
    throw UnimplementedError('login() only supported on Android and iOS.');
  }

  Future<AuthResult> loginWithIdentifier(String identifier) {
    throw UnimplementedError('loginWithIdentifier() only supported on web.');
  }

  Future<bool> deviceSupportsPasskeys() {
    throw UnimplementedError(
        'deviceSupportsPasskeys() has not been implemented.');
  }

  // OTP METHODS

  Future<String> newRegisterOneTimePasscode(String identifier) {
    throw UnimplementedError(
        'newRegisterOneTimePasscode() has not been implemented.');
  }

  Future<String> newLoginOneTimePasscode(String identifier) {
    throw UnimplementedError(
        'newLoginOneTimePasscode() has not been implemented.');
  }

  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) {
    throw UnimplementedError(
        'oneTimePasscodeActivate() has not been implemented.');
  }

  // MAGIC LINK METHODS

  Future<String> newRegisterMagicLink(String identifier) {
    throw UnimplementedError(
        'newRegisterMagicLink() has not been implemented.');
  }

  Future<String> newLoginMagicLink(String identifier) {
    throw UnimplementedError('newLoginMagicLink() has not been implemented.');
  }

  Future<AuthResult> magicLinkActivate(String magicLink) {
    throw UnimplementedError('magicLinkActivate() has not been implemented.');
  }

  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) {
    throw UnimplementedError('getMagicLinkStatus() has not been implemented.');
  }

  // TOKEN METHODS

  Future<String?> getAuthToken() {
    throw UnimplementedError('getAuthToken() has not been implemented.');
  }

  Future<bool> isAuthTokenValid(String authToken) {
    throw UnimplementedError('isAuthTokenValid() has not been implemented.');
  }

  Future<String> refreshAuthToken() {
    throw UnimplementedError('refreshAuthToken() has not been implemented.');
  }

  Future<void> signOut() {
    throw UnimplementedError('signOut() has not been implemented.');
  }

  // APP METHODS

  Future<PassageAppInfo?> getAppInfo() {
    throw UnimplementedError('getAppInfo() has not been implemented.');
  }

  // USER METHODS

  Future<PassageUser?> getCurrentUser() {
    throw UnimplementedError('getCurrentUser() has not been implemented.');
  }

  Future<Passkey> addPasskey() {
    throw UnimplementedError('addPasskey() has not been implemented.');
  }

  Future<void> deletePasskey(String passkeyId) {
    throw UnimplementedError('deletePasskey() has not been implemented.');
  }

  Future<Passkey> editPasskeyName(String passkeyId, String newPasskeyName) {
    throw UnimplementedError('editPasskeyName() has not been implemented.');
  }

  Future<String> changeEmail(String newEmail) {
    throw UnimplementedError('changeEmail() has not been implemented.');
  }

  Future<String> changePhone(String newPhone) {
    throw UnimplementedError('changePhone() has not been implemented.');
  }
}
