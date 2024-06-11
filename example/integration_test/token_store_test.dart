import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_method_channel.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'IntegrationTestConfig.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'package:passage_flutter/passage_flutter_models/passage_user.dart';

import 'mailosaur_api_client.dart';

void main() {
  PassageFlutterPlatform instance = MethodChannelPassageFlutter();

  setUp(() {
    instance.initWithAppId(IntegrationTestConfig.APP_ID_OTP);
    instance.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
  });

  tearDown(() async {
    try {
      await instance.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  });

  Future<void> loginWithOTP() async {
    final otpId = (await instance.newLoginOneTimePasscode(
        IntegrationTestConfig.EXISTING_USER_EMAIL_OTP));
    await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS)); 
    final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
    await instance.oneTimePasscodeActivate(otp, otpId);
  }

  group('TokenStoreTests', () {
    test('testCurrentUser_isNotNull', () async {
      try {
        await loginWithOTP();
        final currentUser = await instance.getCurrentUser();
        expect(currentUser, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserAfterSignOut_isNull', () async {
      try {
        await instance.signOut();
        final signedOutUser = await instance.getCurrentUser();
        expect(signedOutUser, isNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('authToken_isNotNull', () async {
      try {
         await loginWithOTP();
        final authToken = await instance.getAuthToken();
        expect(authToken, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('authTokenAfterSignOut_isNull', () async {
      try {
        await instance.signOut();
        final authToken = await instance.getAuthToken();
        expect(authToken, isNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    // test('authTokenThrowsErrorAfterRevoke', () async {
    //   try {
    //     final user = await instance.getCurrentUser();
    //     await instance.tokenStore.clearAndRevokeTokens();
    //     await user?.listDevicePasskeys();
    //     fail('Test should throw PassageUserUnauthorizedException');
    //   } catch (e) {
    //     //expect(e is PassageUserUnauthorizedException, true);
    //   }
    // });
  });
}


