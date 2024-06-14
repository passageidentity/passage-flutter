import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'integration_test_config.dart';
import 'mailosaur_api_client.dart';
import 'package:flutter/foundation.dart';
import 'platform_helper/platform_helper.dart';

void main() {
  PassageFlutter passage =
      PassageFlutter(IntegrationTestConfig.appIdMagicLink);

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

  Future<void> loginWithMagicLink() async {
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
  }

  group('CurrentUserTests', () {
    test('testCurrentUser', () async {
      try {
        await loginWithMagicLink();
        final response = await passage.getCurrentUser();
        expect(response?.id, IntegrationTestConfig.currentUser.id);
        expect(response?.email, IntegrationTestConfig.currentUser.email);
        expect(response?.status, IntegrationTestConfig.currentUser.status);
        expect(response?.emailVerified,
            IntegrationTestConfig.currentUser.emailVerified);
        expect(response?.phone, IntegrationTestConfig.currentUser.phone);
        expect(response?.phoneVerified,
            IntegrationTestConfig.currentUser.phoneVerified);
        expect(response?.webauthn, IntegrationTestConfig.currentUser.webauthn);
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
