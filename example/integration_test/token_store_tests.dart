
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_js.dart';
import 'mailosaur_api_client.dart'; 
// Adjust according to your Passage class location/ Adjust the import according to your package structure
import 'dart:js_util' as js_util; 


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('TokenStoreTests', () {


    Passage getPassageApp() {
    const appId = "Ezbk6fSdx9pNQ7v7UbVEnzeC";
    return Passage(appId);
  }

  late final passage = getPassageApp();

    setUp(() async {
        var a = js_util.promiseToFuture(passage.appInfo());
        var b = await a;
        print('OTP ID: ${passage.toString()}');
      print('OTP ID: starting');
      final otpIdFuture = js_util.promiseToFuture(passage.newLoginOneTimePasscode("authentigator+1716916054778@ncor7c1m.mailosaur.net"));
        final otpId = await otpIdFuture;
      print('OTP ID: $otpId'); // Log the OTP ID
      await Future.delayed(Duration(milliseconds: 8000));
      final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
      await passage.oneTimePasscodeActivate("otp", "otpId");
    });


    testWidgets('testCurrentUser_isNotNull', (WidgetTester tester) async {
      try {
        final currentUser = await passage.getCurrentUser();
        expect(currentUser, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: ${e.toString()}');
      }
    });

    // testWidgets('testCurrentUserAfterSignOut_isNull', (WidgetTester tester) async {
    //   try {
    //     await passage.signOutCurrentUser();
    //     final signedOutUser = await passage.getCurrentUser();
    //     expect(signedOutUser, isNull);
    //   } catch (e) {
    //     fail('Test failed due to unexpected exception: ${e.toString()}');
    //   }
    // });

    // testWidgets('authToken_isNotNull', (WidgetTester tester) async {
    //   try {
    //     final authToken = await passage.tokenStore.authToken;
    //     expect(authToken, isNotNull);
    //   } catch (e) {
    //     fail('Test failed due to unexpected exception: ${e.toString()}');
    //   }
    // });

    // testWidgets('authTokenAfterSignOut_isNull', (WidgetTester tester) async {
    //   try {
    //     await passage.signOutCurrentUser();
    //     final authToken = await passage.tokenStore.authToken;
    //     expect(authToken, isNull);
    //   } catch (e) {
    //     fail('Test failed due to unexpected exception: ${e.toString()}');
    //   }
    // });

    // testWidgets('authTokenThrowsErrorAfterRevoke', (WidgetTester tester) async {
    //   try {
    //     final user = await passage.getCurrentUser();
    //     await passage.tokenStore.clearAndRevokeTokens();
    //     await user?.listDevicePasskeys();
    //     fail('Test should throw PassageUserUnauthorizedException');
    //   } catch (e) {
    //     expect(e, isA<PassageUserUnauthorizedException>());
    //   }
    // });


  });

}
