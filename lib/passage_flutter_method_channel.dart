import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';

/// An implementation of [PassageFlutterPlatform] that uses method channels.
class MethodChannelPassageFlutter extends PassageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('passage_flutter');

  @override
  Future<AuthResult> register(String identifier) async {
    final jsonString = await methodChannel
        .invokeMethod<String>('register', {'identifier': identifier});
    return AuthResult.fromJson(jsonString!);
  }

  @override
  Future<AuthResult> login() async {
    final jsonString = await methodChannel.invokeMethod<String>('login');
    return AuthResult.fromJson(jsonString!);
  }

  @override
  Future<String> newRegisterOneTimePasscode(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newRegisterOneTimePasscode', {'identifier': identifier});
    return result!;
  }

  @override
  Future<String> newLoginOneTimePasscode(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newLoginOneTimePasscode', {'identifier': identifier});
    return result!;
  }

  @override
  Future<String> oneTimePasscodeActivate(String otp, String otpId) async {
    final result = await methodChannel.invokeMethod<String>(
        'activateOneTimePasscode', {'otp': otp, 'otpId': otpId});
    return result!;
  }

  @override
  Future<String> newRegisterMagicLink(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newRegisterMagicLink', {'identifier': identifier});
    return result!;
  }

  @override
  Future<String> newLoginMagicLink(String identifier) async {
    final result = await methodChannel
        .invokeMethod<String>('newLoginMagicLink', {'identifier': identifier});
    return result!;
  }

  @override
  Future<String> magicLinkActivate(String magicLink) async {
    final result = await methodChannel
        .invokeMethod<String>('activateMagicLink', {'magicLink': magicLink});
    return result!;
  }
}
