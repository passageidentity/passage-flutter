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
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<AuthResult?> register(String identifier) async {
    final AuthResult? authResult = await methodChannel
        .invokeMethod<AuthResult?>('register', {'identifier': identifier});
    return authResult;
  }
}
