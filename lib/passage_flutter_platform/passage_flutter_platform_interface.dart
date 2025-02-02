import 'package:passage_flutter/passage_flutter_models/public_user_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../models/magic_link.dart';
import '../passage_flutter_models/meta_data.dart';
import '../passage_flutter_models/passage_user_social_connections.dart';
import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/authenticator_attachment.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passage_social_connection.dart';
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

  Future<void> initialize(String appId) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }
  
  // PASSKEY AUTH METHODS

  Future<AuthResult> registerWithPasskey(
      String identifier, PasskeyCreationOptions? options) {
    throw UnimplementedError('registerWithPasskey() has not been implemented.');
  }

  Future<AuthResult> loginWithPasskey(String? identifier) {
    throw UnimplementedError('loginWithPasskey() as not been implemented.');
  }

  Future<bool> deviceSupportsPasskeys() {
    throw UnimplementedError(
        'deviceSupportsPasskeys() has not been implemented.');
  }

  // OTP METHODS

  Future<String> newRegisterOneTimePasscode(String identifier, String? language) {
    throw UnimplementedError(
        'newRegisterOneTimePasscode() has not been implemented.');
  }

  Future<String> newLoginOneTimePasscode(String identifier, String? language) {
    throw UnimplementedError(
        'newLoginOneTimePasscode() has not been implemented.');
  }

  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) {
    throw UnimplementedError(
        'oneTimePasscodeActivate() has not been implemented.');
  }

  // MAGIC LINK METHODS

  Future<String> newRegisterMagicLink(String identifier, String? language) {
    throw UnimplementedError(
        'newRegisterMagicLink() has not been implemented.');
  }

  Future<String> newLoginMagicLink(String identifier, String? language) {
    throw UnimplementedError('newLoginMagicLink() has not been implemented.');
  }

  Future<AuthResult> magicLinkActivate(String magicLink) {
    throw UnimplementedError('magicLinkActivate() has not been implemented.');
  }

  Future<AuthResult> getMagicLinkStatus(String magicLinkId) {
    throw UnimplementedError('getMagicLinkStatus() has not been implemented.');
  }

  // SOCIAL AUTH METHODS

  Future<void> authorizeWith(SocialConnection connection) {
    throw UnimplementedError('authorizeWith() has not been implemented.');
  }

  Future<AuthResult> finishSocialAuthentication(String code) {
    throw UnimplementedError(
        'finishSocialAuthentication() has not been implemented.');
  }

  Future<AuthResult> authorizeIOSWith(SocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeIOSWith(connection);
  }

  // TOKEN METHODS

  Future<String> getValidAuthToken() {
    throw UnimplementedError('getAuthToken() has not been implemented.');
  }

  Future<bool> isAuthTokenValid(String authToken) {
    throw UnimplementedError('isAuthTokenValid() has not been implemented.');
  }

  Future<AuthResult> refreshAuthToken() {
    throw UnimplementedError('refreshAuthToken() has not been implemented.');
  }

  Future<void> signOut() {
    throw UnimplementedError('signOut() has not been implemented.');
  }

  // APP METHODS

  Future<PassageAppInfo> getAppInfo() {
    throw UnimplementedError('getAppInfo() has not been implemented.');
  }

  Future<PublicUserInfo> identifierExists(String identifier) {
    throw UnimplementedError('identifierExists() has not been implemented.');
  }

  Future<PublicUserInfo> createUser(String identifier, {Metadata? userMetadata}) {
    throw UnimplementedError('createUser() has not been implemented.');
  }

  // USER METHODS

  Future<CurrentUser> getCurrentUser() {
    throw UnimplementedError('getCurrentUser() has not been implemented.');
  }

  Future<Passkey> addPasskey(PasskeyCreationOptions? options) {
    throw UnimplementedError('addPasskey() has not been implemented.');
  }

  Future<void> deletePasskey(String passkeyId) {
    throw UnimplementedError('deletePasskey() has not been implemented.');
  }

  Future<Passkey> editPasskeyName(String passkeyId, String newPasskeyName) {
    throw UnimplementedError('editPasskeyName() has not been implemented.');
  }

  Future<MagicLink> changeEmail(String newEmail, String? language) {
    throw UnimplementedError('changeEmail() has not been implemented.');
  }

  Future<MagicLink> changePhone(String newPhone, String? language) {
    throw UnimplementedError('changePhone() has not been implemented.');
  }

  Future<void> hostedAuthStart() {
    throw UnimplementedError('hostedAuthStart() has not been implemented.');
  }

  Future<AuthResult> hostedAuthIOS() {
    throw UnimplementedError('hostedAuthStart() has not been implemented.');
  }

  Future<AuthResult> hostedAuthFinish(String code, String state) {
    throw UnimplementedError('hostedAuthFinish() has not been implemented.');
  }

  Future<void> hostedLogout() {
    throw UnimplementedError('hostedLogout() has not been implemented.');
  }

  Future<List<Passkey>> passkeys() {
    throw UnimplementedError('passkeys() has not been implemented.');
  }

  Future<UserSocialConnections?> socialConnections() {
    throw UnimplementedError('socialConnections() has not been implemented.');
  }

  Future<void> deleteSocialConnection(SocialConnection socialConnectionType) {
    throw UnimplementedError('deleteSocialConnection() has not been implemented.');
  }

  Future<Metadata?> metaData() {
    throw UnimplementedError('metaData() has not been implemented.');
  }

  Future<CurrentUser> updateMetaData(Metadata metadata) {
    throw UnimplementedError('passkeys() has not been implemented.');
  }

}
