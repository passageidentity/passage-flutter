import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_method_channel.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_platform_interface.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
  PassageFlutterPlatform instance = MethodChannelPassageFlutter();

  setUp(() async {
    instance.initWithAppId('Pea2GdtBHN3esylK4ZRlF19U');
    await instance.overrideBasePath("https://auth-uat.passage.dev/v1");
  });

  group('MagicLinkTests', () {
    test('testSendRegisterMagicLink', () async {
      try {
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier =
            'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
        await instance.newRegisterMagicLink(identifier);
      } catch (e) {
        fail(
            'Expected to send a register magic link, but got an exception: $e');
      }
    });

    test('testRegisterExistingUserMagicLink', () async {
      try {
        await instance.newRegisterMagicLink(
            IntegrationTestConfig.EXISTING_USER_EMAIL_MAGIC_LINK);
        fail(
            'Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'user: already exists.');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testRegisterInvalidEmailAddressFormatMagicLink', () async {
      try {
        await instance.newRegisterMagicLink('invalid');
        fail(
            'Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'identifier requires a valid email or a valid e164 phone number');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testSendLoginMagicLink', () async {
      try {
        const identifier = IntegrationTestConfig.EXISTING_USER_EMAIL_MAGIC_LINK;
        await instance.newLoginMagicLink(identifier);
      } catch (e) {
        fail('Expected to send a login magic link, but got an exception: $e');
      }
    });

    test('testInvalidLoginMagicLink', () async {
      try {
        await instance.newLoginMagicLink('Invalid@invalid.com');
        fail(
            'Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'User not found');
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
        await instance.newRegisterMagicLink(identifier);
        await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await instance.magicLinkActivate(magicLinkStr);
      } catch (e) {
        fail(
            'Expected to activate register magic link, but got an exception: $e');
      }
    });

    test('testActivateLoginMagicLink', () async {
      try {
        await instance.newLoginMagicLink(
            IntegrationTestConfig.EXISTING_USER_EMAIL_MAGIC_LINK);
        await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await instance.magicLinkActivate(magicLinkStr);
      } catch (e) {
        fail('Expected to activate login magic link, but got an exception: $e');
      }
    });

    test('testActivateInvalidMagicLink', () async {
      try {
        await instance.newRegisterMagicLink(
            'authentigator+invalid@${MailosaurAPIClient.serverId}.mailosaur.net');
        await instance.magicLinkActivate('Invalid');
        fail('Expected PassageError but got success');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'invalid or expired magic link');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testActivateDeactivatedUserMagicLink', () async {
      try {
        await instance.newLoginMagicLink(
            IntegrationTestConfig.DEACTIVATED_USER_EMAIL_MAGIC_LINK);
        await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
        final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
        if (magicLinkStr.isEmpty) {
          fail('Test failed: Magic link is empty');
        }
        await instance.magicLinkActivate(magicLinkStr);
        fail(
            'Expected PassageError but got success');
      } catch (e) {
         if (e is PassageError) {
          expect(e.message, 'User not active');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });
  });
}
