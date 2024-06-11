import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_method_channel.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
 PassageFlutterPlatform instance = MethodChannelPassageFlutter();

  group('Integration Tests', () {
    const String EXISTING_USER_EMAIL_OTP = IntegrationTestConfig.EXISTING_USER_EMAIL_OTP;

  setUp(() async {
    instance.initWithAppId(IntegrationTestConfig.APP_ID_OTP);
    await instance.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
  });

    testWidgets('login with otp', (WidgetTester tester) async {
      try {
      final otpId = await instance.newLoginOneTimePasscode(EXISTING_USER_EMAIL_OTP);
      await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
      final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
      await instance.oneTimePasscodeActivate(otp, otpId);
      } catch (e) {
        fail('Expected AuthResult, but got an exception: $e');
      }
    });



  tearDown(() async {
    await instance.signOut();
  });

  testWidgets('testRegisterOTPValid', (WidgetTester tester) async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final identifier = "authentigator+$date@passage.id";
    try {
      await instance.newRegisterOneTimePasscode(identifier);
    } catch (e) {
      fail('Test failed due to unexpected exception: $e');
    }
  });

  testWidgets('testRegisterOTPNotValid', (WidgetTester tester) async {
    final identifier = "INVALID_IDENTIFIER";
    try {
      await instance.newRegisterOneTimePasscode(identifier);
      fail('Test should throw PassageError');
    } catch (e) {
      if (e is PassageError) {
        expect(e.message, 'identifier requires a valid email or a valid e164 phone number');
      } else {
        fail('Test failed due to unexpected exception: $e');
      }
    }
  });

  testWidgets('testActivateRegisterOTPValid', (WidgetTester tester) async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final identifier = "authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net";
    try {
      final otpId = (await instance.newRegisterOneTimePasscode(identifier));
      await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS)); // Simulate wait time
      final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
      await instance.oneTimePasscodeActivate(otp, otpId);
    } catch (e) {
      fail('Test failed due to unexpected exception: $e');
    }
  });

  testWidgets('testLoginOTPValid', (WidgetTester tester) async {
    final identifier = EXISTING_USER_EMAIL_OTP;
    try {
      await instance.newLoginOneTimePasscode(identifier);
    } catch (e) {
      fail('Test failed due to unexpected exception: $e');
    }
  });

  testWidgets('testLoginOTPNotValid', (WidgetTester tester) async {
    final identifier = "INVALID_IDENTIFIER";
    try {
      await instance.newLoginOneTimePasscode(identifier);
      fail('Test should throw NewLoginOneTimePasscodeInvalidIdentifierException');
    } catch (e) {
      if (e is PassageError) {
        expect(e.message, 'identifier requires a valid email or a valid e164 phone number');
      } else {
        fail('Test failed due to unexpected exception: $e');
      }
    }
  });

  testWidgets('testActivateLoginOTPValid', (WidgetTester tester) async {
    final identifier = EXISTING_USER_EMAIL_OTP;
    try {
      final otpId = (await instance.newLoginOneTimePasscode(identifier));
      await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS)); // Simulate wait time
      final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
      await instance.oneTimePasscodeActivate(otp, otpId);
    } catch (e) {
      fail('Test failed due to unexpected exception: $e');
    }
  });

  });
}

