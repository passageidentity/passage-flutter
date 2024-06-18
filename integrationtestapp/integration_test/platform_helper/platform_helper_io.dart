import 'dart:io' as io;

class PlatformHelper {
  static bool get isAndroid => io.Platform.isAndroid;
  static bool get isIOS => io.Platform.isIOS;
}
