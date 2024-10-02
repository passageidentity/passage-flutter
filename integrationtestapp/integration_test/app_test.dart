import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'helper/integration_test_config.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.appIdPassage);

  setUp(() async {
    if (!kIsWeb) {
      String basePath = IntegrationTestConfig.apiBaseUrl;
    }
  });


  group('PassageAppTests', () {
    test('testAppInfo', () async {
      try {
        final appInfo = await passage.app.info();
        expect(appInfo.id.toString(), IntegrationTestConfig.appIdPassage);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testUserExists', () async {
      try {
        const identifier = IntegrationTestConfig.existingUserPassage;
        final userInfo = await passage.app.userExists(identifier);
        expect(userInfo, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testUserDoesNotExist', () async {
      try {
        final identifier = 'nonexistent_${DateTime.now().millisecondsSinceEpoch}@example.com';
        final userInfo = await passage.app.userExists(identifier);
        fail('Expected PassageError but got success');
      } catch (e) {
        //success
      }
    });

    test('testUserDoesExist', () async {
      try {
        final newUser = await passage.app.createUser('newuser_${DateTime.now().millisecondsSinceEpoch}@example.com');
        expect(newUser, isNotNull);
        } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });
  });
}
