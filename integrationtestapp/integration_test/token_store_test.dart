import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';
import 'package:flutter/foundation.dart';
import 'platform_helper/platform_helper.dart';

void main() {
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.APP_ID_MAGIC_LINK);

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

  group('TokenStoreTests', () {
    test('testCurrentUser_isNotNull', () async {
      try {
        await loginWithMagicLink();
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
        await loginWithMagicLink();
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
