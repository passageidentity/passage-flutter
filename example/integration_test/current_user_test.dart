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

  group('CurrentUserTests', () {
    test('testCurrentUser', () async {
      // Make sure we have an authToken.
      //expect(IntegrationTestConfig.AUTH_TOKEN.isNotEmpty, true);
      try {
        await loginWithOTP();
        final response = await instance.getCurrentUser();
        expect(response?.id, IntegrationTestConfig.CURRENT_USER.id);
        expect(response?.email, IntegrationTestConfig.CURRENT_USER.email);
        expect(response?.status, IntegrationTestConfig.CURRENT_USER.status);
        expect(response?.emailVerified, IntegrationTestConfig.CURRENT_USER.emailVerified);
        expect(response?.phone, IntegrationTestConfig.CURRENT_USER.phone);
        expect(response?.phoneVerified, IntegrationTestConfig.CURRENT_USER.phoneVerified);
        expect(response?.webauthn, IntegrationTestConfig.CURRENT_USER.webauthn);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserNotAuthorized', () async {
      try {
        final response = await instance.getCurrentUser();
        if (response == null) {
          expect(true, true);
        } else {
          fail('Test failed: response must be null');
        }
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });
  });
}

class Passage {
  static void setAuthToken(String token) {
    // Implement this method to set the auth token
  }
}

extension on PassageUser {
  Future<PassageUser?> getCurrentUser() async {
    // Implement this method to get the current user
    return this;
  }
}
