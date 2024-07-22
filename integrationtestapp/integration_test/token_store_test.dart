import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'helper/integration_test_config.dart';
import 'helper/mailosaur_api_client.dart';
import 'package:flutter/foundation.dart';
import 'helper/platform_helper.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.appIdMagicLink);

  setUp(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
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
      await passage
          .newLoginMagicLink(IntegrationTestConfig.existingUserEmailMagicLink);
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
