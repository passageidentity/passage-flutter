// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html' as html show window;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'passage_flutter_platform_interface.dart';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:js/js.dart';

import 'passage_js.dart';
import 'auth_result.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

/// A web implementation of the PassageFlutterPlatform of the PassageFlutter plugin.
class PassageFlutterWeb extends PassageFlutterPlatform {
  /// Constructs a PassageFlutterWeb
  PassageFlutterWeb();

  final passage = Passage(getPassageAppId());

  static String getPassageAppId() {
    return js.context['passageAppId'];
  }

  static void registerWith(Registrar registrar) {
    PassageFlutterPlatform.instance = PassageFlutterWeb();
  }

  @override
  Future<AuthResult> register(String identifier) async {
    final resultPromise = passage.register(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final resultMap = convertToMap(jsObject);
    final authResult = AuthResult.fromMap(resultMap);
    return authResult;
  }

  /// Convert from a JS Object to a Dart Map.
  static Map<String, dynamic> convertToMap(jsObject) {
    return Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
  }
}
