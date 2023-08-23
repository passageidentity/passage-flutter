import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:passage_flutter/passage_flutter.dart';

import 'mailosaur_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final passage = PassageFlutter();

  const existingUserIdentifier =
      'authentigator+1692746578703@${MailosaurAPIClient.serverId}.mailosaur.net';

  setUpAll(() {
    return Future(() async {
      // Authenticate user using OTP to test authenticated user flows below.
      // This will run once before any of the tests start, NOT before each test.
      final otpId =
          await passage.newLoginOneTimePasscode(existingUserIdentifier);
      await Future.delayed(const Duration(seconds: 3), () {});
      final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
      await passage.oneTimePasscodeActivate(otp, otpId);
    });
  });

  tearDownAll(() {
    return Future(() async {
      // Make sure tokens are cleared out.
      await passage.signOut();
    });
  });

  // UNAUTHENTICATED TESTS

  test('If user is authenticated, passage.getCurrentUser() returns user info',
      () async {
    try {
      final user = await passage.getCurrentUser();
      final userIsNull = user == null;
      expect(userIsNull, false);
    } catch (e) {
      fail(e.toString());
    }
  });

  test(
      'If user is authenticated, user can access auth token using passage.getAuthToken',
      () async {
    try {
      final otpId =
          await passage.newLoginOneTimePasscode(existingUserIdentifier);
      await Future.delayed(const Duration(seconds: 3), () {});
      final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
      await passage.oneTimePasscodeActivate(otp, otpId);
      final authToken = await passage.getAuthToken();
      final tokenIsNull = authToken == null;
      expect(tokenIsNull, false);
    } catch (e) {
      fail(e.toString());
    }
  });

  test('If user is authenticated, user can refresh auth token', () async {
    try {
      final oldAuthToken = await passage.getAuthToken();
      await Future.delayed(const Duration(seconds: 1), () {});
      final newAuthToken = await passage.refreshAuthToken();
      final tokensMatch = oldAuthToken == newAuthToken;
      expect(tokensMatch, false);
    } catch (e) {
      fail(e.toString());
    }
  });

  test('If user is not authenticated, user can no longer access auth token',
      () async {
    await passage.signOut();
    final token = await passage.getAuthToken();
    expect(token, null);
  });

  test('If user is not authenticated, passage.getCurrentUser() returns null',
      () async {
    await passage.signOut();
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, true);
  });
}
