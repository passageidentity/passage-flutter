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
  Future<AuthResult?> register(String identifier) async {
    final objMap = await methodChannel.invokeMethod<Map<Object?, Object?>>(
        'register', {'identifier': identifier});
    if (objMap == null) {
      return null;
    } else {
      return AuthResult.fromMap(convertToMap(objMap));
    }
  }

  @override
  Future<AuthResult?> login() async {
    final String? jsonString =
        await methodChannel.invokeMethod<String>('login');
    if (jsonString == null) {
      return null;
    } else {
      return AuthResult.fromJson(jsonString);
    }
  }

  @override
  Future<String?> newRegisterOneTimePasscode(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newRegisterOneTimePasscode', {'identifier': identifier});
    return result;
  }

  @override
  Future<String?> newLoginOneTimePasscode(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newLoginOneTimePasscode', {'identifier': identifier});
    return result;
  }

  @override
  Future<String?> activateOneTimePasscode(String otp, String otpId) async {
    final result = await methodChannel.invokeMethod<String>(
        'activateOneTimePasscode', {'otp': otp, 'otpId': otpId});
    return result;
  }

  @override
  Future<String?> newRegisterMagicLink(String identifier) async {
    final result = await methodChannel.invokeMethod<String>(
        'newRegisterMagicLink', {'identifier': identifier});
    return result;
  }

  @override
  Future<String?> newLoginMagicLink(String identifier) async {
    final result = await methodChannel
        .invokeMethod<String>('newLoginMagicLink', {'identifier': identifier});
    return result;
  }

  @override
  Future<String?> activateMagicLink(String magicLink) async {
    final result = await methodChannel
        .invokeMethod<String>('activateMagicLink', {'magicLink': magicLink});
    return result;
  }

  /// Convert from a Swift/Kotlin dictionary to a Dart Map.
  static Map<String, dynamic> convertToMap(Map<Object?, Object?> resultMap) {
    var map = <String, dynamic>{};
    resultMap.forEach((key, value) {
      map[key.toString()] = value;
    });
    return map;
  }
}
