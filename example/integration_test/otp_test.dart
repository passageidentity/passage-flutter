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
      // Make sure all tokens are cleared from device before running each test.
      await passage.signOut();
    });
  });

  test('If new user, user can register and using OTP flow', () async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch;
      final identifier =
          'authentigator+$date@${MailosaurAPIClient.serverId}.mailosaur.net';
      final otpId = await passage.newRegisterOneTimePasscode(identifier);
      await Future.delayed(const Duration(seconds: 3), () {});
      final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
      await passage.oneTimePasscodeActivate(otp, otpId);
    } catch (e) {
      fail(e.toString());
    }
  });

  test('If existing user user, user can login using OTP flow', () async {
    try {
      final otpId =
          await passage.newLoginOneTimePasscode(existingUserIdentifier);
      await Future.delayed(const Duration(seconds: 3), () {});
      final otp = await MailosaurAPIClient().getMostRecentOneTimePasscode();
      await passage.oneTimePasscodeActivate(otp, otpId);
    } catch (e) {
      fail(e.toString());
    }
  });
}
