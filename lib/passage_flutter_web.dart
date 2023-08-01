// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'passage_flutter_platform_interface.dart';
import 'package:passage_flutter/app_info.dart';
import 'package:passage_flutter/user_info.dart';
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

  // TODO: Map JS errors to PassageFlutter errors

  @override
  Future<AuthResult> register(String identifier) async {
    final resultPromise = passage.register(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return AuthResult.fromJSObject(jsObject);
  }

  @override
  Future<AuthResult> loginWithIdentifier(String identifier) async {
    final resultPromise = passage.login(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    print(jsObject);
    return AuthResult.fromJSObject(jsObject);
  }

  @override
  Future<String> newRegisterOneTimePasscode(String identifier) async {
    final resultPromise = passage.newRegisterOneTimePasscode(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final resultMap = convertToMap(jsObject);
    return resultMap['otp_id'];
  }

  @override
  Future<String> newLoginOneTimePasscode(String identifier) async {
    final resultPromise = passage.newLoginOneTimePasscode(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final resultMap = convertToMap(jsObject);
    return resultMap['otp_id'];
  }

  @override
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) async {
    final resultPromise = passage.oneTimePasscodeActivate(otp, otpId);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return AuthResult.fromJSObject(jsObject);
  }

  @override
  Future<String> newRegisterMagicLink(String identifier) async {
    final resultPromise = passage.newRegisterMagicLink(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final resultMap = convertToMap(jsObject);
    return resultMap['id'];
  }

  @override
  Future<String> newLoginMagicLink(String identifier) async {
    final resultPromise = passage.newLoginMagicLink(identifier);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final resultMap = convertToMap(jsObject);
    return resultMap['id'];
  }

  @override
  Future<AuthResult> magicLinkActivate(String magicLink) async {
    final resultPromise = passage.magicLinkActivate(magicLink);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return AuthResult.fromJSObject(jsObject);
  }

  @override
  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) async {
    final resultPromise = passage.getMagicLinkStatus(magicLinkId);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return AuthResult.fromJSObject(jsObject);
  }

  @override
  Future<String?> getAuthToken() async {
    final resultPromise = passage.getCurrentSession().getAuthToken();
    final String authToken = await js_util.promiseToFuture(resultPromise);
    return authToken;
  }

  @override
  Future<bool> isAuthTokenValid(String authToken) async {
    // TODO: custom implementation, not available in PassageJS
    throw UnimplementedError('isAuthTokenValid() has not been implemented.');
  }

  @override
  Future<String> refreshAuthToken() async {
    // TODO: Getting 'Login required' error
    final resultPromise = passage.getCurrentSession().refresh();
    final String authToken = await js_util.promiseToFuture(resultPromise);
    print(authToken);
    return authToken;
  }

  @override
  Future<PassageAppInfo?> getAppInfo() async {
    final resultPromise = passage.appInfo();
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return PassageAppInfo.fromJSObject(jsObject);
  }

  @override
  Future<PassageUser?> getCurrentUser() async {
    final resultPromise = passage.getCurrentUser().userInfo();
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return PassageUser.fromJSObject(jsObject);
  }

  @override
  Future<void> signOut() async {
    final resultPromise = passage.getCurrentSession().signOut();
    await js_util.promiseToFuture(resultPromise);
    return;
  }

  @override
  Future<Passkey> addPasskey() async {
    final resultPromise = passage.getCurrentUser().userInfo();
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return Passkey.fromJSObject(jsObject);
  }

  @override
  Future<void> deletePasskey(String passkeyId) async {
    final resultPromise = passage.getCurrentUser().deleteDevice(passkeyId);
    await js_util.promiseToFuture(resultPromise);
    return;
  }

  @override
  Future<Passkey> editPasskeyName(
      String passkeyId, String newPasskeyName) async {
    final objFromMap = js_util.jsify({'friendly_name': newPasskeyName});
    final resultPromise =
        passage.getCurrentUser().editDevice(passkeyId, objFromMap);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return Passkey.fromJSObject(jsObject);
  }

  @override
  Future<String> changeEmail(String newEmail) async {
    final resultPromise = passage.getCurrentUser().changeEmail(newEmail);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return jsObject.id;
  }

  @override
  Future<String> changePhone(String newPhone) async {
    final resultPromise = passage.getCurrentUser().changePhone(newPhone);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return jsObject.id;
  }

  /// Convert from a JS Object to a Dart Map.
  static Map<String, dynamic> convertToMap(jsObject) {
    return Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
  }
}
