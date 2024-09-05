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
import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/authenticator_attachment.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_error.dart';
import './passage_flutter_models/passage_error_code.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passkey.dart';
import 'passage_flutter_models/passage_social_connection.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'passage_flutter_platform/passage_js.dart';

/// A web implementation of the PassageFlutterPlatform of the PassageFlutter plugin.
class PassageFlutterWeb extends PassageFlutterPlatform {
  /// Constructs a PassageFlutterWeb
  PassageFlutterWeb();

  late final passage = _getPassageApp();

  String? _passageAppId;

  Passage _getPassageApp() {
    final appId = _passageAppId ?? js.context['passageAppId'];
    return Passage(appId);
  }

  static void registerWith(Registrar registrar) {
    PassageFlutterPlatform.instance = PassageFlutterWeb();
  }

  @override
  Future<void> initWithAppId(String appId) async {
    _passageAppId = appId;
  }

  // PASSKEY AUTH METHODS

  @override
  Future<AuthResult> registerWithPasskey(
      String identifier, PasskeyCreationOptions? options) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.passkeysNotSupported);
    }
    try {
      final jsOptions = js_util.jsify(options?.toJson());
      final resultPromise = passage.register(identifier, jsOptions);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.passkeyError);
    }
  }

  @override
  Future<AuthResult> loginWithPasskey(String? identifier) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.passkeysNotSupported);
    }
    try {
      final resultPromise = passage.login(identifier ?? '');
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.passkeyError);
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
          object: e, overrideCode: PassageErrorCode.otpError);
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
          object: e, overrideCode: PassageErrorCode.otpError);
    }
  }

  @override
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) async {
    try {
      final resultPromise = passage.oneTimePasscodeActivate(otp, otpId);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      final overrideCode = e.toString().contains('exceeded number of attempts')
          ? PassageErrorCode.otpActivationExceededAttempts
          : PassageErrorCode.otpError;
      throw PassageError.fromObject(object: e, overrideCode: overrideCode);
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
          object: e, overrideCode: PassageErrorCode.magicLinkError);
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
          object: e, overrideCode: PassageErrorCode.magicLinkError);
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
          object: e, overrideCode: PassageErrorCode.magicLinkError);
    }
  }

  @override
  Future<AuthResult> getMagicLinkStatus(String magicLinkId) async {
    try {
      final resultPromise = passage.getMagicLinkStatus(magicLinkId);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.magicLinkError);
    }
  }

  // SOCIAL AUTH METHODS

  @override
  Future<void> authorizeWith(PassageSocialConnection connection) async {
    try {
      final resultPromise = passage.authorizeWith(connection.value);
      await js_util.promiseToFuture(resultPromise);
      return;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.socialAuthError);
    }
  }

  @override
  Future<AuthResult> finishSocialAuthentication(String code) async {
    try {
      final resultPromise = passage.finishSocialAuthentication(code);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.socialAuthError);
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
          object: e, overrideCode: PassageErrorCode.tokenError);
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
      String encodedPayload = parts[1];
      int requiredPadding = 4 - encodedPayload.length % 4;
      if (requiredPadding < 4) {
        encodedPayload += '=' * requiredPadding;
      }
      final payload = utf8.decode(base64Url.decode(encodedPayload));
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
          object: e, overrideCode: PassageErrorCode.tokenError);
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
      return jsObject == null ? null : PassageAppInfo.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.appInfoError);
    }
  }

  @override
  Future<PassageUser?> identifierExists(String identifier) async {
    try {
      final resultPromise = passage.identifierExists(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return jsObject != null ? PassageUser.fromJson(jsObject) : null;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.identifierExistsError);
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
  Future<Passkey> addPasskey(PasskeyCreationOptions? options) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.passkeysNotSupported);
    }
    try {
      final jsOptions = js_util.jsify(options?.toJson());
      final resultPromise = passage.getCurrentUser().addDevice(jsOptions);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return Passkey.fromJson(jsObject);
    } catch (e) {
      final error = PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.passkeyError);
      if (error.message.contains('failed to parse public key')) {
        throw PassageError(
            code: PassageErrorCode.userCancelled, message: error.message);
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
          object: e, overrideCode: PassageErrorCode.passkeyError);
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
          object: e, overrideCode: PassageErrorCode.passkeyError);
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
          object: e, overrideCode: PassageErrorCode.changeEmailError);
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
          object: e, overrideCode: PassageErrorCode.changeEmailError);
    }
  }
}
