import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/meta_data.dart';
import 'package:passage_flutter/passage_flutter_models/passage_social_connection.dart';
import 'package:passage_flutter/passage_flutter_models/passage_user_social_connections.dart';
import 'package:passage_flutter/passage_flutter_models/passkey.dart';
import 'helper/integration_test_config.dart';
import 'helper/mailosaur_api_client.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> loginWithMagicLink() async {
    try {
      await passage
          .magliclink
          .login(IntegrationTestConfig.existingUserEmailMagicLink);
      await Future.delayed(
          const Duration(milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
      final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
      if (magicLinkStr.isEmpty) {
        fail('Test failed: Magic link is empty');
      }
      await passage.magliclink.activate(magicLinkStr);
    } catch (e) {
      fail('Expected to activate login magic link, but got an exception: $e');
    }
  }

  group('CurrentUserTests', () {
    test('testCurrentUser', () async {
      try {
        await loginWithMagicLink();
        final response = await passage.currentUser.userInfo();
        expect(response?.id, IntegrationTestConfig.currentUser.id);
        expect(response?.email, IntegrationTestConfig.currentUser.email);
        expect(response?.status, IntegrationTestConfig.currentUser.status);
        expect(
            response?.emailVerified, IntegrationTestConfig.currentUser.emailVerified);
        expect(response?.phone, IntegrationTestConfig.currentUser.phone);
        expect(
            response?.phoneVerified, IntegrationTestConfig.currentUser.phoneVerified);
        expect(response?.webauthn, IntegrationTestConfig.currentUser.webauthn);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testCurrentUserNotAuthorized', () async {
      try {
        final response = await passage.currentUser.userInfo();
        fail('Test failed: must throw an error');
      } catch (e) {
        //success
      }
    });

    test('testPasskeys', () async {
      try {
        await loginWithMagicLink();
        final passkeys = await passage.currentUser.passkeys();
        expect(passkeys, isNotNull);
        expect(passkeys, isA<List<Passkey>>());
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testSocialConnections', () async {
      try {
        await loginWithMagicLink();
        final socialConnections = await passage.currentUser.socialConnections();
        expect(socialConnections, isNotNull);
        expect(socialConnections, isA<UserSocialConnections>());
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testDeleteSocialConnection', () async {
      try {
        await loginWithMagicLink();

        final socialConnectionType = SocialConnection.github;
        await passage.currentUser.deleteSocialConnection(socialConnectionType);
        final socialConnections = await passage.currentUser.socialConnections();
        expect(socialConnections, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testMetadata', () async {
      try {
        await loginWithMagicLink();
        final metadata = await passage.currentUser.metadata();
        expect(metadata, isNotNull);
        expect(metadata, isA<Metadata>());
      } catch (e) {
        print(e.toString());
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testUpdateMetadata', () async {
      try {
        await loginWithMagicLink();

        Metadata newMetadata = Metadata(userMetadata: {'testkey': 'testValue'});
        await passage.currentUser.updateMetadata(newMetadata);
        final updatedMetadata = await passage.currentUser.metadata();
        expect(updatedMetadata, isNotNull);
      } catch (e) {
        print(e.toString());
        fail('Test failed due to unexpected exception: $e');
      }
    });
  });
}
