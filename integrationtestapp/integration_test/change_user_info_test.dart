import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';
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

  tearDownAll(() async {
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

  group('ChangeContactTests', () {
    test('testChangeEmail', () async {
      try {
        await loginWithMagicLink();
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        final response = await passage.changeEmail(identifier);
        expect(response, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testChangeEmailUnAuthed', () async {
      try {
        await passage.signOut();
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        await passage.changeEmail(identifier);
        fail('Test should throw PassageError');
      } catch (e) {
        if (e is PassageError) {
          // SUCCESS;
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testChangePhone', () async {
      try {
        await loginWithMagicLink();
        final response = passage.changePhone('+14155552671');
        expect(response, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testChangePhoneInvalid', () async {
      try {
        await loginWithMagicLink();
        final response = await passage.changePhone('444');
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
        await passage.changePhone('+14155552671');
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
