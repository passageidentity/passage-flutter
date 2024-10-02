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
          .magliclink.login(IntegrationTestConfig.existingUserEmailMagicLink);
      await Future.delayed(const Duration(
          milliseconds: IntegrationTestConfig.waitTimeMilliseconds));
      final magicLinkStr = await MailosaurAPIClient.getMostRecentMagicLink();
      if (magicLinkStr.isEmpty) {
        fail('Test failed: Magic link is empty');
      }
      await passage.magliclink.activate(magicLinkStr);
    } catch (e) {
      fail('Expected to activate login magic link, but got an exception: $e');
    }
  }

  group('ChangeContactTests', () {
    test('testChangeEmail', () async {
      try {
        await loginWithMagicLink();
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        final response = await passage.currentUser.changeEmail(identifier);
        expect(response, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testChangeEmailUnAuthed', () async {
      try {
        await passage.currentUser.logout();
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        await passage.currentUser.changeEmail(identifier);
        fail('Test should throw PassageError');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS;
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testChangePhoneInvalid', () async {
      try {
        await loginWithMagicLink();
        final response = await passage.currentUser.changePhone('444');
        expect(response, isNotNull);
        fail('Test should throw PassageError');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS;
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testChangePhoneUnAuthed', () async {
      try {
        await passage.currentUser.changePhone('+14155552671');
        fail('Test should throw PassageError');
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
