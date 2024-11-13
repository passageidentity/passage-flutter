import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'helper/integration_test_config.dart';
import 'helper/mailosaur_api_client.dart';
import 'helper/platform_helper.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.appIdMagicLink);

  setUpAll(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
    }
  });

  tearDown(() async {
    try {
      await passage.currentUser.logout();
    } catch (e) {
      // an error happened during sign out
    }
  });

  group('MagicLinkTests', () {
    test('testSendRegisterMagicLink', () async {
      try {
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier =
            'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
        await passage.magiclink.register(identifier);
      } catch (e) {
        fail(
            'Expected to send a register magic link, but got an exception: $e');
      }
    });

    test('testRegisterExistingUserMagicLink', () async {
      try {
        await passage.magiclink.register(
            IntegrationTestConfig.existingUserEmailMagicLink);
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testRegisterInvalidEmailAddressFormatMagicLink', () async {
      try {
        await passage.magiclink.register('invalid');
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testSendLoginMagicLink', () async {
      try {
        const identifier = IntegrationTestConfig.existingUserEmailMagicLink;
        await passage.magiclink.login(identifier);
      } catch (e) {
        fail('Expected to send a login magic link, but got an exception: $e');
      }
    });

    test('testInvalidLoginMagicLink', () async {
      try {
        await passage.magiclink.login('Invalid@invalid.com');
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testActivateRegisterMagicLink', () async {
      try {
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier =
            'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
        await passage.magiclink.register(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magiclink.activate(magicLinkStr);
      } catch (e) {
        fail(
            'Expected to activate register magic link, but got an exception: $e');
      }
    });

    test('testActivateLoginMagicLink', () async {
      try {
        await passage.magiclink.login(
            IntegrationTestConfig.existingUserEmailMagicLink);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magiclink.activate(magicLinkStr);
      } catch (e) {
        fail('Expected to activate login magic link, but got an exception: $e');
      }
    });

    test('testActivateInvalidMagicLink', () async {
      try {
        await passage.magiclink.register(
            'authentigator+invalid@${MailosaurAPIClient.serverId}.mailosaur.net');
        await passage.magiclink.activate('Invalid');
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testActivateDeactivatedUserMagicLink', () async {
      try {
        await passage.magiclink.login(
            IntegrationTestConfig.deactivatedUserEmailMagicLink);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magiclink.activate(magicLinkStr);
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });
  });
}
