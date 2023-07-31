import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'passage_flutter_method_channel.dart';
import 'auth_result.dart';

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

  Future<AuthResult> register(String identifier) {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<AuthResult> login() {
    throw UnimplementedError('login() only supported on Android and iOS.');
  }

  Future<AuthResult> loginWithIdentifier(String identifier) {
    throw UnimplementedError('loginWithIdentifier() only supported on web.');
  }

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

  Future<String> getMagicLinkStatus(String magicLinkId) {
    throw UnimplementedError('getMagicLinkStatus() has not been implemented.');
  }
}
