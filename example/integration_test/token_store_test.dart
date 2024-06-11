import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.APP_ID_OTP);

  setUp(() {
    passage.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
  });

  tearDown(() async {
    try {
      await passage.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  });

  Future<void> loginWithOTP() async {
    final otpId = (await passage.newLoginOneTimePasscode(
        IntegrationTestConfig.EXISTING_USER_EMAIL_OTP));
    await Future.delayed(const Duration(
        milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
    final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
    await passage.oneTimePasscodeActivate(otp, otpId);
  }

  group('TokenStoreTests', () {
    test('testCurrentUser_isNotNull', () async {
      try {
        await loginWithOTP();
        final currentUser = await passage.getCurrentUser();
        expect(currentUser, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserAfterSignOut_isNull', () async {
      try {
        await passage.signOut();
        final signedOutUser = await passage.getCurrentUser();
        expect(signedOutUser, isNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('authToken_isNotNull', () async {
      try {
        await loginWithOTP();
        final authToken = await passage.getAuthToken();
        expect(authToken, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('authTokenAfterSignOut_isNull', () async {
      try {
        await passage.signOut();
        final authToken = await passage.getAuthToken();
        expect(authToken, isNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });
    
  });
}
