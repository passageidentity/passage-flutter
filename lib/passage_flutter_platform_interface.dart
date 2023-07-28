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

  Future<AuthResult?> register(String identifier) {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<AuthResult?> login(String identifier) {
    throw UnimplementedError('login() has not been implemented.');
  }

  Future<String?> newRegisterOneTimePasscode(String identifier) {
    throw UnimplementedError(
        'newRegisterOneTimePasscode() has not been implemented.');
  }

  Future<String?> newLoginOneTimePasscode(String identifier) {
    throw UnimplementedError(
        'newLoginOneTimePasscode() has not been implemented.');
  }

  Future<String?> activateOneTimePasscode(String otp, String otpId) {
    throw UnimplementedError(
        'activateOneTimePasscode() has not been implemented.');
  }

  Future<String?> newRegisterMagicLink(String identifier) {
    throw UnimplementedError(
        'newRegisterMagicLink() has not been implemented.');
  }

  Future<String?> newLoginMagicLink(String identifier) {
    throw UnimplementedError('newLoginMagicLink() has not been implemented.');
  }

  Future<String?> activateMagicLink(String magicLink) {
    throw UnimplementedError('activateMagicLink() has not been implemented.');
  }
}
