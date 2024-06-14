import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';
import 'package:flutter/foundation.dart';
import 'platform_helper/platform_helper.dart';

void main() {
  PassageFlutter passage =
      PassageFlutter(IntegrationTestConfig.APP_ID_MAGIC_LINK);

  setUp(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.API_BASE_URL;
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
      print('Error during sign out: $e');
    }
  });

  Future<void> loginWithMagicLink() async {
    try {
      await passage.newLoginMagicLink(
          IntegrationTestConfig.EXISTING_USER_EMAIL_MAGIC_LINK);
      await Future.delayed(const Duration(
          milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS));
      final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
      if (magicLinkStr.isEmpty) {
        fail('Test failed: Magic link is empty');
      }
      await passage.magicLinkActivate(magicLinkStr);
    } catch (e) {
      fail('Expected to activate login magic link, but got an exception: $e');
    }
  }

  group('CurrentUserTests', () {
    test('testCurrentUser', () async {
      try {
        await loginWithMagicLink();
        final response = await passage.getCurrentUser();
        expect(response?.id, IntegrationTestConfig.CURRENT_USER.id);
        expect(response?.email, IntegrationTestConfig.CURRENT_USER.email);
        expect(response?.status, IntegrationTestConfig.CURRENT_USER.status);
        expect(response?.emailVerified,
            IntegrationTestConfig.CURRENT_USER.emailVerified);
        expect(response?.phone, IntegrationTestConfig.CURRENT_USER.phone);
        expect(response?.phoneVerified,
            IntegrationTestConfig.CURRENT_USER.phoneVerified);
        expect(response?.webauthn, IntegrationTestConfig.CURRENT_USER.webauthn);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserNotAuthorized', () async {
      try {
        final response = await passage.getCurrentUser();
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
