import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'helper/integration_test_config.dart';
import 'helper/mailosaur_api_client.dart';
import 'helper/platform_helper.dart';

void main() {
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.appIdOtp);

  setUp(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
      if (PlatformHelper.isAndroid) {
        basePath += '/v1';
      }
      await passage.overrideBasePath(basePath);
    }
  });

  tearDown(() async {
    try {
      await passage.signOut();
    } catch (e) {
      // an error happened during sign out
    }
  });

  group('Otp Tests', () {
    const String existingUserEmailOtp =
        IntegrationTestConfig.existingUserEmailOtp;

    test('testRegisterOTPValid', () async {
      final date = DateTime.now().millisecondsSinceEpoch;
      final identifier = "authentigator+$date@33333.id";
      try {
        await passage.newRegisterOneTimePasscode(identifier);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testLoginOTPValid', () async {
      const identifier = existingUserEmailOtp;
      try {
        await passage.newLoginOneTimePasscode(identifier);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testRegisterOTPNotValid', () async {
      const identifier = "INVALID_IDENTIFIER";
      try {
        await passage.newRegisterOneTimePasscode(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        fail('Test should throw PassageError');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });
// Skip this test on the web
    if (!kIsWeb) {
      test('testActivateRegisterOTPValid', () async {
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier =
            "authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net";
        try {
          final otpId = (await passage.newRegisterOneTimePasscode(identifier));
          await Future.delayed(const Duration(
              milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
          final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
          await passage.oneTimePasscodeActivate(otp, otpId);
        } catch (e) {
          fail('Test failed due to unexpected exception: $e');
        }
      });
    }

    test('testLoginOTPNotValid', () async {
      const identifier = "INVALID_IDENTIFIER";
      try {
        await passage.newLoginOneTimePasscode(identifier);
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

// Skip this test on the web
    if (!kIsWeb) {
      test('testActivateLoginOTPValid', () async {
        const identifier = existingUserEmailOtp;
        try {
          final otpId = (await passage.newLoginOneTimePasscode(identifier));
          await Future.delayed(const Duration(
              milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
          final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
          await passage.oneTimePasscodeActivate(otp, otpId);
        } catch (e) {
          fail('Test failed due to unexpected exception: $e');
        }
      });
    }
  });
}
