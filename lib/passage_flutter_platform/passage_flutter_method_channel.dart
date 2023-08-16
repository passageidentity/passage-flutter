import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '/passage_flutter_models/auth_result.dart';
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

  // PASSKEY AUTH METHODS

  @override
  Future<AuthResult> register(String identifier) async {
    try {
      final jsonString = await methodChannel
          .invokeMethod<String>('register', {'identifier': identifier});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<AuthResult> login() async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>('login');
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
  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>(
          'getMagicLinkStatus', {'magicLinkId': magicLinkId});
      return AuthResult.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // TOKEN METHODS

  @override
  Future<String?> getAuthToken() async {
    try {
      final authToken =
          await methodChannel.invokeMethod<String?>('getAuthToken');
      return authToken;
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
  Future<String> refreshAuthToken() async {
    try {
      final newAuthToken =
          await methodChannel.invokeMethod<String>('refreshAuthToken');
      return newAuthToken!;
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
  Future<PassageAppInfo?> getAppInfo() async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>('getAppInfo');
      return PassageAppInfo.fromJson(jsonString!);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  // USER METHODS

  @override
  Future<PassageUser?> getCurrentUser() async {
    try {
      final jsonString =
          await methodChannel.invokeMethod<String>('getCurrentUser');
      return jsonString == null ? null : PassageUser.fromJson(jsonString);
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<Passkey> addPasskey() async {
    try {
      final jsonString = await methodChannel.invokeMethod<String>('addPasskey');
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
  Future<String> changeEmail(String newEmail) async {
    try {
      final magicLinkId =
          await methodChannel.invokeMethod<String>('changeEmail');
      return magicLinkId!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }

  @override
  Future<String> changePhone(String newPhone) async {
    try {
      final magicLinkId =
          await methodChannel.invokeMethod<String>('changePhone');
      return magicLinkId!;
    } catch (e) {
      throw PassageError.fromObject(object: e);
    }
  }
}
