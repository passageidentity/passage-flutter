import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/models/one_time_passcode.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'helper/integration_test_config.dart';
import 'helper/mailosaur_api_client.dart';
import 'helper/platform_helper.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.appIdOtp);

  setUp(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
      await passage.overrideBasePath(basePath);
    }
  });

  tearDown(() async {
    try {
      await passage.currentUser.logout();
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
        await passage.oneTimePasscode.register(identifier);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testLoginOTPValid', () async {
      const identifier = existingUserEmailOtp;
      try {
        await passage.oneTimePasscode.login(identifier);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testRegisterOTPNotValid', () async {
      const identifier = "INVALID_IDENTIFIER";
      try {
        await passage.oneTimePasscode.register(identifier);
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
          final oneTimePasscode = (await passage.oneTimePasscode.register(identifier));
          await Future.delayed(const Duration(
              milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
          final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
          await passage.oneTimePasscode.activate(otp, oneTimePasscode.id);
        } catch (e) {
          fail('Test failed due to unexpected exception: $e');
        }
      });
    }

    test('testLoginOTPNotValid', () async {
      const identifier = "INVALID_IDENTIFIER";
      try {
        await passage.oneTimePasscode.login(identifier);
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
          final oneTimePasscode = (await passage.oneTimePasscode.login(identifier));
          await Future.delayed(const Duration(
              milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
          final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
          await passage.oneTimePasscode.activate(otp, oneTimePasscode.id);
        } catch (e) {
          fail('Test failed due to unexpected exception: $e');
        }
      });
    }
  });
}
