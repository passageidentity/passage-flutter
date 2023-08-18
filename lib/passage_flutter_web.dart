// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:flutter/foundation.dart' as flutter;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import '/helpers/data_conversion_web.dart';
import '/helpers/error_handling_web.dart';
import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_error.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passkey.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'passage_flutter_platform/passage_js.dart';

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

  // PASSKEY AUTH METHODS

  @override
  Future<AuthResult> register(String identifier) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.PASSKEYS_NOT_SUPPORTED);
    }
    try {
      final resultPromise = passage.register(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      final error = PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.PASSKEY_ERROR);
      if (error.message.contains('error parsing public key for webAuthn')) {
        throw PassageError(
            code: PassageErrorCode.USER_CANCELLED, message: error.message);
      }
      throw error;
    }
  }

  @override
  Future<AuthResult> loginWithIdentifier(String identifier) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.PASSKEYS_NOT_SUPPORTED);
    }
    try {
      final resultPromise = passage.login(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      final error = PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.PASSKEY_ERROR);
      if (error.message.contains('error parsing public key for webAuthn')) {
        throw PassageError(
            code: PassageErrorCode.USER_CANCELLED, message: error.message);
      }
      throw error;
    }
  }

  @override
  Future<bool> deviceSupportsPasskeys() async {
    try {
      final resultPromise = passage.getCredentialAvailable();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return jsObject.platform == true;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // OTP METHODS

  @override
  Future<String> newRegisterOneTimePasscode(String identifier) async {
    try {
      final resultPromise = passage.newRegisterOneTimePasscode(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['otp_id'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.OTP_ERROR);
    }
  }

  @override
  Future<String> newLoginOneTimePasscode(String identifier) async {
    try {
      final resultPromise = passage.newLoginOneTimePasscode(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['otp_id'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.OTP_ERROR);
    }
  }

  @override
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) async {
    try {
      final resultPromise = passage.oneTimePasscodeActivate(otp, otpId);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.OTP_ERROR);
    }
  }

  // MAGIC LINK METHODS

  @override
  Future<String> newRegisterMagicLink(String identifier) async {
    try {
      final resultPromise = passage.newRegisterMagicLink(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['id'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.MAGIC_LINK_ERROR);
    }
  }

  @override
  Future<String> newLoginMagicLink(String identifier) async {
    try {
      final resultPromise = passage.newLoginMagicLink(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['id'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.MAGIC_LINK_ERROR);
    }
  }

  @override
  Future<AuthResult> magicLinkActivate(String magicLink) async {
    try {
      final resultPromise = passage.magicLinkActivate(magicLink);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.MAGIC_LINK_ERROR);
    }
  }

  @override
  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) async {
    try {
      final resultPromise = passage.getMagicLinkStatus(magicLinkId);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.MAGIC_LINK_ERROR);
    }
  }

  // TOKEN METHODS

  @override
  Future<String?> getAuthToken() async {
    try {
      final resultPromise = passage.getCurrentSession().getAuthToken();
      final String? authToken = await js_util.promiseToFuture(resultPromise);
      return authToken;
    } catch (e) {
      var error = PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.TOKEN_ERROR);
      flutter.debugPrint(error.toString());
      return null;
    }
  }

  @override
  Future<bool> isAuthTokenValid(String authToken) async {
    try {
      final parts = authToken.split('.');
      if (parts.length != 3) {
        return false;
      }
      final payload = utf8.decode(base64Url.decode(parts[1]));
      final Map<String, dynamic> data = jsonDecode(payload);
      if (data.containsKey('exp')) {
        final int expirationTime = data['exp'] * 1000;
        final int currentTime = DateTime.now().millisecondsSinceEpoch;
        return expirationTime > currentTime;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> refreshAuthToken() async {
    try {
      final resultPromise = passage.getCurrentSession().refresh();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final authResult = AuthResult.fromJson(jsObject);
      return authResult.authToken;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.TOKEN_ERROR);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final resultPromise = passage.getCurrentSession().signOut();
      await js_util.promiseToFuture(resultPromise);
      return;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // APP METHODS

  @override
  Future<PassageAppInfo?> getAppInfo() async {
    try {
      final resultPromise = passage.appInfo();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return PassageAppInfo.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.APP_INFO_ERROR);
    }
  }

  // USER METHODS

  @override
  Future<PassageUser?> getCurrentUser() async {
    try {
      final resultPromise = passage.getCurrentUser().userInfo();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return PassageUser.fromJson(jsObject);
    } catch (e) {
      var error = PassageError.fromObject(object: e);
      flutter.debugPrint(error.toString());
      return null;
    }
  }

  @override
  Future<Passkey> addPasskey() async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.PASSKEYS_NOT_SUPPORTED);
    }
    try {
      final resultPromise = passage.getCurrentUser().addDevice();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return Passkey.fromJson(jsObject);
    } catch (e) {
      final error = PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.PASSKEY_ERROR);
      if (error.message.contains('failed to parse public key')) {
        throw PassageError(
            code: PassageErrorCode.USER_CANCELLED, message: error.message);
      }
      throw error;
    }
  }

  @override
  Future<void> deletePasskey(String passkeyId) async {
    try {
      final resultPromise = passage.getCurrentUser().deleteDevice(passkeyId);
      await js_util.promiseToFuture(resultPromise);
      return;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.PASSKEY_ERROR);
    }
  }

  @override
  Future<Passkey> editPasskeyName(
      String passkeyId, String newPasskeyName) async {
    try {
      final objFromMap = js_util.jsify({'friendly_name': newPasskeyName});
      final resultPromise =
          passage.getCurrentUser().editDevice(passkeyId, objFromMap);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return Passkey.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.PASSKEY_ERROR);
    }
  }

  @override
  Future<String> changeEmail(String newEmail) async {
    try {
      final resultPromise = passage.getCurrentUser().changeEmail(newEmail);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return jsObject.id;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.CHANGE_EMAIL_ERROR);
    }
  }

  @override
  Future<String> changePhone(String newPhone) async {
    try {
      final resultPromise = passage.getCurrentUser().changePhone(newPhone);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return jsObject.id;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.CHANGE_EMAIL_ERROR);
    }
  }
}
