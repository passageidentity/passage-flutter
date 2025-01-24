// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:passage_flutter/models/magic_link.dart';
import '/helpers/data_conversion_web.dart';
import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/authenticator_attachment.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_error.dart';
import './passage_flutter_models/passage_error_code.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passkey.dart' as model;
import 'passage_flutter_models/meta_data.dart';
import 'passage_flutter_models/passage_social_connection.dart';
import 'passage_flutter_models/passage_user_social_connections.dart';
import 'passage_flutter_models/public_user_info.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'passage_flutter_platform/passage_js.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_js.dart' as js_model;

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
  Future<void> initialize(String appId) async {
    _passageAppId = appId;
  }

  // PASSKEY AUTH METHODS

  @override
  @override
  Future<AuthResult> registerWithPasskey(
      String identifier, PasskeyCreationOptions? options) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.passkeysNotSupported);
    }
    try {
      final jsOptions = js_util.jsify(options?.toJson());
      final resultPromise = passage.passkey.register(identifier, jsOptions);
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
      final resultPromise = passage.passkey.login(identifier ?? '');
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
      final resultPromise = passage.passkey.getCredentialAvailable();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return jsObject.platform == true;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // OTP METHODS

  @override
  Future<String> newRegisterOneTimePasscode(String identifier,  String? language) async {
    try {
      final resultPromise = passage.oneTimePasscode.register(identifier, language);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['otpId'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.otpError);
    }
  }

  @override
  Future<String> newLoginOneTimePasscode(String identifier, String? language) async {
    try {
      final resultPromise = passage.oneTimePasscode.login(identifier, language);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['otpId'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.otpError);
    }
  }

  @override
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) async {
    try {
      final resultPromise = passage.oneTimePasscode.activate(otp, otpId);
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
  Future<String> newRegisterMagicLink(String identifier, String? language) async {
    try {
      final resultPromise = passage.magicLink.register(identifier, language);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final resultMap = jsObjectToMap(jsObject);
      return resultMap['id'];
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.magicLinkError);
    }
  }

  @override
  Future<String> newLoginMagicLink(String identifier, String? language) async {
    try {
      final resultPromise = passage.magicLink.login(identifier, language);
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
      final resultPromise = passage.magicLink.activate(magicLink);
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
      final resultPromise = passage.magicLink.status(magicLinkId);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.magicLinkError);
    }
  }

  // SOCIAL AUTH METHODS

  @override
  Future<void> authorizeWith(SocialConnection connection) async {
    try {
      final resultPromise = passage.social.authorize(connection.value);
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
      final resultPromise = passage.social.finish(code);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return AuthResult.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.socialAuthError);
    }
  }

  // TOKEN METHODS

  @override
  Future<String> getValidAuthToken() async {
    try {
      final resultPromise = passage.session.getAuthToken();
      final String authToken = await js_util.promiseToFuture(resultPromise);
      return authToken;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.tokenError);
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
  Future<AuthResult> refreshAuthToken() async {
    try {
      final resultPromise = passage.session.refresh();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final authResult = AuthResult.fromJson(jsObject);
      return authResult;
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.tokenError);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final resultPromise = passage.session.signOut();
      await js_util.promiseToFuture(resultPromise);
      return;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // APP METHODS

  @override
  Future<PassageAppInfo> getAppInfo() async {
    try {
      final resultPromise = passage.app.info();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return PassageAppInfo.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.appInfoError);
    }
  }

  @override
  Future<PublicUserInfo> identifierExists(String identifier) async {
    try {
      final resultPromise = passage.app.userExists(identifier);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return PublicUserInfo.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.identifierExistsError);
    }
  }

  // USER METHODS

  @override
  Future<CurrentUser> getCurrentUser() async {
    try {
      final resultPromise = passage.currentUser.userInfo();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return CurrentUser.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<model.Passkey> addPasskey(PasskeyCreationOptions? options) async {
    final passkeysSupported = await deviceSupportsPasskeys();
    if (!passkeysSupported) {
      throw PassageError(code: PassageErrorCode.passkeysNotSupported);
    }
    try {
      final jsOptions = js_util.jsify(options?.toJson());
      final resultPromise = passage.currentUser.addPasskey(jsOptions);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return model.Passkey.fromJson(jsObject);
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
      // Create a Passkey object with the given passkeyId
      final passkey = js_model.Passkey(id: passkeyId);

      // Call the deletePasskey method with the Passkey object
      final resultPromise = passage.currentUser.deletePasskey(passkey);
      await js_util.promiseToFuture(resultPromise);
    } catch (e) {
      throw PassageError.fromObject(
        object: e,
        overrideCode: PassageErrorCode.passkeyError,
      );
    }
  }

  @override
  Future<model.Passkey> editPasskeyName(
      String passkeyId, String newPasskeyName) async {
    try {
      final objFromMap = js_util.jsify({'friendly_name': newPasskeyName});
      final resultPromise =
          passage.currentUser.editPasskey(passkeyId, objFromMap);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return model.Passkey.fromJson(jsObject);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.passkeyError);
    }
  }

  @override
  Future<MagicLink> changeEmail(String newEmail) async {
    try {
      final resultPromise = passage.currentUser.changeEmail(newEmail);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return MagicLink(jsObject.id);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.changeEmailError);
    }
  }

  @override
  Future<MagicLink> changePhone(String newPhone) async {
    try {
      final resultPromise = passage.currentUser.changePhone(newPhone);
      final jsObject = await js_util.promiseToFuture(resultPromise);
      return MagicLink(jsObject.id);
    } catch (e) {
      throw PassageError.fromObject(
          object: e, overrideCode: PassageErrorCode.changePhoneError);
    }
  }

  @override
  Future<List<model.Passkey>> passkeys() async {
    try {
      final resultPromise = passage.currentUser.passkeys();
      final jsArray = await js_util.promiseToFuture(resultPromise);
      final List<dynamic> jsList = jsArray as List<dynamic>;
      return jsList
          .map((jsObject) => model.Passkey.fromJson(jsObject))
          .toList();
    } catch (e) {
      throw PassageError.fromObject(
        object: e,
        overrideCode: PassageErrorCode.gettingPasskeysError,
      );
    }
  }

  @override
Future<UserSocialConnections> socialConnections() async {
  try {
    final resultPromise = passage.currentUser.listSocialConnections();
    final jsObject = await js_util.promiseToFuture(resultPromise);
    final dartObject = js_util.dartify(jsObject);
    final Map<String, dynamic> dartMap = _convertToMapStringDynamic(dartObject as Map);
    return UserSocialConnections.fromMap(dartMap);
  } catch (e) {
    throw PassageError.fromObject(
      object: e,
      overrideCode: PassageErrorCode.socialConnectionError,
    );
  }
}

// Helper function to convert LinkedMap<dynamic, dynamic> to Map<String, dynamic>
Map<String, dynamic> _convertToMapStringDynamic(Map<dynamic, dynamic> map) {
  return map.map((key, value) {
    if (value is Map) {
      return MapEntry(key.toString(), _convertToMapStringDynamic(value)); 
    } else if (value is DateTime) {
      return MapEntry(key.toString(), value.toIso8601String());
    } else {
      return MapEntry(key.toString(), value);
    }
  });
}

  @override
  Future<bool> deleteSocialConnection(SocialConnection socialConnectionType) async {
    try {
      final connectionTypeString = socialConnectionType.value;
      final resultPromise =
          passage.currentUser.deleteSocialConnection(connectionTypeString);
      final result = await js_util.promiseToFuture(resultPromise);

      return result as bool;
    } catch (e) {
      throw PassageError.fromObject(
        object: e,
        overrideCode: PassageErrorCode.socialConnectionError,
      );
    }
  }

  @override
  Future<Metadata> metaData() async {
    try {
      final resultPromise = passage.currentUser.metadata();
      final jsObject = await js_util.promiseToFuture(resultPromise);
      final dartObject = js_util.dartify(jsObject);
      return Metadata(userMetadata: dartObject);
    } catch (e) {
      throw PassageError.fromObject(
        object: e,
        overrideCode: PassageErrorCode.metadataError,
      );
    }
  }


@override
Future<CurrentUser> updateMetaData(Metadata metadata) async {
  try {
    final userMetadata = metadata.userMetadata as Map<String, dynamic>;
    final sanitizedMetadata = userMetadata.map((key, value) {
      if (value is bool || value is String || value is num) {
        return MapEntry(key, value);
      } else {
        throw ArgumentError("Invalid value type for key $key: ${value.runtimeType}");
      }
    });
    final jsUserMetadata = js_util.jsify(sanitizedMetadata);
    final resultPromise = passage.currentUser.updateMetadata(jsUserMetadata);
    final jsObject = await js_util.promiseToFuture(resultPromise);
    return CurrentUser.fromJson(jsObject);

  } catch (e) {
    throw PassageError.fromObject(
      object: e,
      overrideCode: PassageErrorCode.metadataError,
    );
  }
}

}
