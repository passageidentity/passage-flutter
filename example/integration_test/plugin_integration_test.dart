// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:passage_flutter/passage_flutter.dart';

import 'mailosaur_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final passage = PassageFlutter();

  const existingUserIdentifier =
      'authentigator+1692746578703@${MailosaurAPIClient.serverId}.mailosaur.net';

  setUp(() {
    return Future(() async {
      // Make sure all tokens are cleared from device before running tests.
      await passage.signOut();
    });
  });

  // UNAUTHENTICATED TESTS

  test(
      'If user is not authenticated, passage.getCurrentUser() should return null',
      () async {
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, true);
  });

  // FALLBACK AUTH TESTS

  test('If new user, user can register using OTP flow', () async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final identifier =
        'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
    final otpId = await passage.newRegisterOneTimePasscode(identifier);
    await Future.delayed(const Duration(seconds: 3), () {});
    final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
    await passage.oneTimePasscodeActivate(otp, otpId);
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, false);
  });

  test('If existing user user, user can login using OTP flow', () async {
    final otpId = await passage.newLoginOneTimePasscode(existingUserIdentifier);
    await Future.delayed(const Duration(seconds: 3), () {});
    final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
    await passage.oneTimePasscodeActivate(otp, otpId);
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, false);
  });

  // TODO: Passage app ID is set statically, and single app only allows otp OR Magic link - not both.
  // So we'll need to change that in the native SDKs, Flutter SDK, and THEN we
  // can run both kinds of tests.
  /*
  test('If new user, user can register using Magic Link flow', () async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final identifier =
        'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
    await passage.newRegisterMagicLink(identifier);
    await Future.delayed(const Duration(seconds: 3), () {});
    final magicLink = await MailosaurAPIClient().getMostRecentMagicLink();
    await passage.magicLinkActivate(magicLink);
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, false);
  });

  test('If existing user, user can login using Magic Link flow', () async {;
    await passage.newLoginMagicLink(existingUserIdentifier);
    await Future.delayed(const Duration(seconds: 3), () {});
    final magicLink = await MailosaurAPIClient().getMostRecentMagicLink();
    await passage.magicLinkActivate(magicLink);
    final user = await passage.getCurrentUser();
    final userIsNull = user == null;
    expect(userIsNull, false);
  });
  */

  // SESSION TESTS
}
