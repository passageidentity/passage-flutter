import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'integration_test_config.dart';
import 'mailosaur_api_client.dart';
import 'platform_helper/platform_helper.dart';

void main() {
  PassageFlutter passage =
      PassageFlutter(IntegrationTestConfig.appIdMagicLink);

  setUpAll(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
      if (PlatformHelper.isAndroid) {
        basePath += '/v1';
      }
      await passage.overrideBasePath(basePath);
    }
  });

  tearDownAll(() async {
    try {
      await passage.signOut();
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
        await passage.newRegisterMagicLink(identifier);
      } catch (e) {
        fail(
            'Expected to send a register magic link, but got an exception: $e');
      }
    });

    test('testRegisterExistingUserMagicLink', () async {
      try {
        await passage.newRegisterMagicLink(
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
        await passage.newRegisterMagicLink('invalid');
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
        await passage.newLoginMagicLink(identifier);
      } catch (e) {
        fail('Expected to send a login magic link, but got an exception: $e');
      }
    });

    test('testInvalidLoginMagicLink', () async {
      try {
        await passage.newLoginMagicLink('Invalid@invalid.com');
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
        await passage.newRegisterMagicLink(identifier);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magicLinkActivate(magicLinkStr);
      } catch (e) {
        fail(
            'Expected to activate register magic link, but got an exception: $e');
      }
    });

    test('testActivateLoginMagicLink', () async {
      try {
        await passage.newLoginMagicLink(
            IntegrationTestConfig.existingUserEmailMagicLink);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magicLinkActivate(magicLinkStr);
      } catch (e) {
        fail('Expected to activate login magic link, but got an exception: $e');
      }
    });

    test('testActivateInvalidMagicLink', () async {
      try {
        await passage.newRegisterMagicLink(
            'authentigator+invalid@${MailosaurAPIClient.serverId}.mailosaur.net');
        await passage.magicLinkActivate('Invalid');
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
        await passage.newLoginMagicLink(
            IntegrationTestConfig.deactivatedUserEmailMagicLink);
        await Future.delayed(const Duration(
            milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await passage.magicLinkActivate(magicLinkStr);
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
