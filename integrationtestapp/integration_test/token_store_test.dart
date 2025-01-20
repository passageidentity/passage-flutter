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
    }
  });

  tearDown(() async {
    try {
      await passage.currentUser.logout();
    } catch (e) {
      // an error happened during sign out
    }
  });

  Future<void> loginWithMagicLink() async {
    try {
      await passage
          .magiclink.login(IntegrationTestConfig.existingUserEmailMagicLink);
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
  }

  group('TokenStoreTests', () {
    test('testCurrentUser_isNotNull', () async {
      try {
        await loginWithMagicLink();
        final currentUser = await passage.currentUser.userInfo();
        expect(currentUser, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserAfterSignOut_isNull', () async {
      try {
        await passage.currentUser.logout();
        final signedOutUser = await passage.currentUser.userInfo();
        fail('Expected PassageError but got success');
      } catch (e) {
        //success 
      }
    });

    test('authToken_isNotNull', () async {
      try {
        await loginWithMagicLink();
        final authToken = await passage.tokenStore.getValidAuthToken();
        expect(authToken, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('authTokenAfterSignOut_isNull', () async {
      try {
        await passage.currentUser.logout();
        final authToken = await passage.tokenStore.getValidAuthToken();
        fail('Expected PassageError but got success');
      } catch (e) {
        //success
      }
    });
  test('isAuthTokenValid_returnsTrueForValidToken', () async {
    await loginWithMagicLink();
    final validToken = await passage.tokenStore.getValidAuthToken();
    final isValid = await passage.tokenStore.isAuthTokenValid(validToken);
    expect(isValid, isTrue);
  });

  test('isAuthTokenValid_returnsFalseForInvalidToken', () async {
    const invalidToken = 'invalidToken';
    final isValid = await passage.tokenStore.isAuthTokenValid(invalidToken);
    expect(isValid, isFalse);
  });

  test('refreshAuthToken_returnsNewAuthToken', () async {
    await loginWithMagicLink();
    final authResult = await passage.tokenStore.refreshAuthToken();
    expect(authResult, isNotNull);
    expect(authResult.authToken, isNotNull);
    expect(authResult.refreshToken, isNotNull);
  });

  test('refreshAuthToken_throwsPassageError', () async {
    try {
      final authResult = await passage.tokenStore.refreshAuthToken();
      fail('Expected PassageError but got success');
    } catch (e) {
      // success
    }
  });

  });
}
