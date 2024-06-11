import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
  PassageFlutter passage = PassageFlutter(IntegrationTestConfig.APP_ID_OTP);

  setUp(() {
    passage.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
  });

  tearDown(() async {
    try {
      await passage.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  });

  Future<void> loginWithOTP() async {
    final otpId = (await passage.newLoginOneTimePasscode(
        IntegrationTestConfig.EXISTING_USER_EMAIL_OTP));
    await Future.delayed(const Duration(milliseconds: IntegrationTestConfig.WAIT_TIME_MILLISECONDS)); // Simulate wait time
    final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
    await passage.oneTimePasscodeActivate(otp, otpId);
  }

  group('ChangeContactTests', () {
    test('testChangeEmail', () async {
      // Make sure we have an authToken.
      //expect(IntegrationTestConfig.AUTH_TOKEN.isNotEmpty, true);
      try {
        await loginWithOTP();
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
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        await passage.changeEmail(identifier);
        fail('Test should throw PassageUserUnauthorizedException');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'User is not authorized.');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testChangePhone', () async {
      // Make sure we have an authToken.
      //expect(IntegrationTestConfig.AUTH_TOKEN.isNotEmpty, true);
      try {
        await loginWithOTP();
        final response = passage.changePhone('+14155552671');
        expect(response, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testChangePhoneInvalid', () async {
      // Make sure we have an authToken.
      // expect(IntegrationTestConfig.AUTH_TOKEN.isNotEmpty, true);
      try {
        await loginWithOTP();
        final response = await passage.changePhone('444');
        expect(response, isNotNull);
        fail('Test should throw PassageUserRequestException');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'new_phone must be a valid E164 phone number');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });

    test('testChangePhoneUnAuthed', () async {
      try {
        await passage.changePhone('+14155552671');
        fail('Test should throw PassageUserUnauthorizedException');
      } catch (e) {
        if (e is PassageError) {
          expect(e.message, 'User is not authorized.');
        } else {
          fail('Test failed due to unexpected exception: $e');
        }
      }
    });
  });
}
