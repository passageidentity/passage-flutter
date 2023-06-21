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
      throw Exception("test exception");
    } else {
      return AuthResult.fromMap(convertToMap(objMap));
    }
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
