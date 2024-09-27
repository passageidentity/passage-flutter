import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:passage_flutter/models/magic_link.dart';
import 'package:passage_flutter/passage_flutter_models/meta_data.dart';
import 'package:passage_flutter/passage_flutter_models/public_user_info.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error_code.dart';
import '../passage_flutter_models/passage_social_connection.dart';
import '../passage_flutter_models/passage_user_social_connections.dart';
import '/passage_flutter_models/auth_result.dart';
import '/passage_flutter_models/authenticator_attachment.dart';
import '/passage_flutter_models/passage_app_info.dart';
import '/passage_flutter_models/passage_error.dart';
import '/passage_flutter_models/passage_user.dart';
import '/passage_flutter_models/passkey.dart';
import 'passage_flutter_platform_interface.dart';

/// An implementation of [PassageFlutterPlatform] that uses method channels.
class MethodChannelPassageFlutter extends PassageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('passage_flutter');

  @override
  Future<void> initialize(String appId) async {
    await methodChannel.invokeMethod('initialize', {'appId': appId});
  }

  // PASSKEY AUTH METHODS

  @override
  Future<AuthResult> registerWithPasskey(
      String identifier, PasskeyCreationOptions? options) async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'registerWithPasskey',
          {'identifier': identifier, 'options': options?.toJson()});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> loginWithPasskey(String? identifier) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('loginWithPasskey', {'identifier': identifier});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<bool> deviceSupportsPasskeys() async {
    final deviceSupportsPasskeys =
        await methodChannel.invokeMethod<bool>('deviceSupportsPasskeys');
    return deviceSupportsPasskeys == true;
  }

  // OTP METHODS

  @override
  Future<String> newRegisterOneTimePasscode(String identifier) async {
    try {
      final result = await methodChannel.invokeMethod<String>(
          'newRegisterOneTimePasscode', {'identifier': identifier});
      return result!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<String> newLoginOneTimePasscode(String identifier) async {
    try {
      final result = await methodChannel.invokeMethod<String>(
          'newLoginOneTimePasscode', {'identifier': identifier});
      return result!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'oneTimePasscodeActivate', {'otp': otp, 'otpId': otpId});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // MAGIC LINK METHODS

  @override
  Future<String> newRegisterMagicLink(String identifier) async {
    try {
      final result = await methodChannel.invokeMethod<String>(
          'newRegisterMagicLink', {'identifier': identifier});
      return result!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<String> newLoginMagicLink(String identifier) async {
    try {
      final result = await methodChannel.invokeMethod<String>(
          'newLoginMagicLink', {'identifier': identifier});
      return result!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> magicLinkActivate(String magicLink) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('magicLinkActivate', {'magicLink': magicLink});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> getMagicLinkStatus(String magicLinkId) async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'getMagicLinkStatus', {'magicLinkId': magicLinkId});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // SOCIAL AUTH METHODS

  @override
  Future<void> authorizeWith(SocialConnection connection) async {
    if (Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.socialAuthError,
          message: 'Not supported on iOS. Use authorizeIOS instead.');
    }
    try {
      return await methodChannel.invokeMethod<void>(
          'authorizeWith', {'connection': connection.value});
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> finishSocialAuthentication(String code) async {
    if (Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.socialAuthError,
          message: 'Not supported on iOS. Use authorizeIOS instead.');
    }
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('finishSocialAuthentication', {'code': code});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> authorizeIOSWith(SocialConnection connection) async {
    if (!Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.socialAuthError,
          message: 'Only supported on iOS. Use authorizeWith instead.');
    }
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'authorizeWith', {'connection': connection.value});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // TOKEN METHODS

  @override
  Future<String> getAuthToken() async {
    try {
      final authToken =
          await methodChannel.invokeMethod<String>('getAuthToken');
      return authToken!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<bool> isAuthTokenValid(String authToken) async {
    try {
      final isValid = await methodChannel
          .invokeMethod<bool>('isAuthTokenValid', {'authToken': authToken});
      return isValid == true;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> refreshAuthToken() async {
    try {
      final newAuthToken =
          await methodChannel.invokeMethod<String>('refreshAuthToken');
      return AuthResult.fromJson(newAuthToken!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await methodChannel.invokeMethod('signOut');
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // APP METHODS

  @override
  Future<PassageAppInfo> getAppInfo() async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>('getAppInfo');
      return PassageAppInfo.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<PublicUserInfo> identifierExists(String identifier) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('identifierExists', {'identifier': identifier});
      return PublicUserInfo.fromJson(jsonString);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<PublicUserInfo> createUser(String identifier, {Metadata? userMetadata}) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('createUser', {'identifier': identifier, 'userMetadata': userMetadata?.toJson()});
      return PublicUserInfo.fromJson(jsonString);
    } catch (e) {
      print(e.toString());
      throw PassageError.fromObject(object: e);
    }
  }

  // USER METHODS

  @override
  Future<CurrentUser> getCurrentUser() async {
    try {
      final jsonString =
          await methodChannel.invokeMethod<String>('getCurrentUser');
      return CurrentUser.fromJson(jsonString);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<Passkey> addPasskey(PasskeyCreationOptions? options) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('addPasskey', {'options': options?.toJson()});
      return Passkey.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<void> deletePasskey(String passkeyId) async {
    try {
      return await methodChannel
          .invokeMethod('deletePasskey', {'passkeyId': passkeyId});
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<Passkey> editPasskeyName(
      String passkeyId, String newPasskeyName) async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'editDevicePasskeyName',
          {'passkeyId': passkeyId, 'newPasskeyName': newPasskeyName});
      return Passkey.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<MagicLink> changeEmail(String newEmail) async {
    try {
      final magicLinkId = await methodChannel
          .invokeMethod<String>('changeEmail', {'newEmail': newEmail});
      return MagicLink(magicLinkId!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<MagicLink> changePhone(String newPhone) async {
    try {
      final magicLinkId = await methodChannel
          .invokeMethod<String>('changePhone', {'newPhone': newPhone});
      return MagicLink(magicLinkId!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<void> hostedAuthStart() async {
    if (Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.hostedAuthStart,
          message: 'Not supported on iOS. Use hostedAuthIOS instead.');
    }
    try {
      await methodChannel.invokeMethod<String>('hostedAuthStart');
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> hostedAuthIOS() async {
    if (!Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.hostedAuthIOS,
          message: 'Only supported on iOS. Use hostedAuthStart instead.');
    }
    try {
      final authResultWithIdToken =
          await methodChannel.invokeMethod<String>('hostedAuth');
      return AuthResult.fromJson(authResultWithIdToken!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> hostedAuthFinish(String code, String state) async {
    if (Platform.isIOS) {
      throw PassageError(
          code: PassageErrorCode.hostedAuthFinish,
          message: 'Not supported on iOS. Use hostedAuthIOS instead.');
    }
    try {
      final Map<Object?, Object?>? result =
          await methodChannel.invokeMethod<Map<Object?, Object?>>(
        'hostedAuthFinish',
        {'code': code, 'state': state},
      );
      final authResult = AuthResult.fromJson(result!['authResult']);
      return authResult;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<void> hostedLogout() async {
    try {
      return await methodChannel.invokeMethod<void>('hostedLogout');
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<List<Passkey>> passkeys() async {
    try {
      final String? passkeysJson =
          await methodChannel.invokeMethod<String>('passkeys');

      if (passkeysJson == null) {
        return [];
      }

      final List<dynamic> passkeyList =
          jsonDecode(passkeysJson) as List<dynamic>;
      return passkeyList
          .map((passkeyMap) =>
              Passkey.fromMap(passkeyMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<UserSocialConnections?> socialConnections() async {
    try {
      final String? socialConnectionsJson =
          await methodChannel.invokeMethod<String>('socialConnections');
      if (socialConnectionsJson == null) {
        return null;
      }
      return UserSocialConnections.fromJson(socialConnectionsJson);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<void> deleteSocialConnection(
      SocialConnection socialConnectionType) async {
    try {
      await methodChannel.invokeMethod<void>('deleteSocialConnection', {
        'socialConnectionType': socialConnectionType
            .value,
      });
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<Metadata?> metaData() async {
    try {
      final String? metaDataJson =
          await methodChannel.invokeMethod<String>('metaData');
      final Map<String, dynamic> metaDataMap = jsonDecode(metaDataJson!);
      return Metadata.fromMap(metaDataMap);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<CurrentUser> updateMetaData(Metadata metadata) async {
    try {
      Map<String, dynamic> metadataMap = metadata.toMap();
      final String? currentUserJson = await methodChannel.invokeMethod<String>(
        'updateMetaData',
        {
          'userMetadata':
              metadataMap.values.first
        },
      );
      return CurrentUser.fromJson(currentUserJson!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }
}
