import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.APP_ID_OTP);

  setUp(() async {
    if (!kIsWeb) {
      await passage.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
    }
  });

  tearDownAll(() async {
    try {
      await passage.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  });

  group('Otp Tests', () {
    const String EXISTING_USER_EMAIL_OTP =
        IntegrationTestConfig.EXISTING_USER_EMAIL_OTP;

    test('testRegisterOTPValid', () async {
      final date = DateTime.now().millisecondsSinceEpoch;
      final identifier = "authentigator+$date@33333.id";
      try {
        await passage.newRegisterOneTimePasscode(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testRegisterOTPNotValid', () async {
      final identifier = "INVALID_IDENTIFIER";
      try {
        await passage.newRegisterOneTimePasscode(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        fail('Test should throw PassageError');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testActivateRegisterOTPValid', () async {
      final date = DateTime.now().millisecondsSinceEpoch;
      final identifier =
          "authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net";
      try {
        final otpId = (await passage.newRegisterOneTimePasscode(identifier));
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
        await passage.oneTimePasscodeActivate(otp, otpId);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testLoginOTPValid', () async {
      final identifier = EXISTING_USER_EMAIL_OTP;
      try {
        await passage.newLoginOneTimePasscode(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testLoginOTPNotValid', () async {
      final identifier = "INVALID_IDENTIFIER";
      try {
        await passage.newLoginOneTimePasscode(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        fail(
            'Test should throw NewLoginOneTimePasscodeInvalidIdentifierException');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testActivateLoginOTPValid', () async {
      final identifier = EXISTING_USER_EMAIL_OTP;
      try {
        final otpId = (await passage.newLoginOneTimePasscode(identifier));
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
        await passage.oneTimePasscodeActivate(otp, otpId);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });
  });
}
