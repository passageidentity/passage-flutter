import 'package:flutter_test/flutter_test.dart';
import 'package:passage_flutter/passage_flutter_models/passage_error.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_method_channel.dart';
import 'package:passage_flutter/passage_flutter_platform/passage_flutter_platform_interface.dart';

import 'IntegrationTestConfig.dart';
import 'mailosaur_api_client.dart';

void main() {
  PassageFlutterPlatform instance = MethodChannelPassageFlutter();

  setUp(() {
    instance.initWithAppId(IntegrationTestConfig.APP_ID_OTP);
    instance.overrideBasePath(IntegrationTestConfig.API_BASE_URL);
  });

  tearDown(() async {
    try {
      await instance.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  });

  Future<void> loginWithOTP() async {
    final otpId = (await instance.newLoginOneTimePasscode(
        IntegrationTestConfig.EXISTING_USER_EMAIL_OTP));
    await Future.delayed(Duration(milliseconds: 8000)); // Simulate wait time
    final otp = await MailosaurAPIClient.getMostRecentOneTimePasscode();
    await instance.oneTimePasscodeActivate(otp, otpId);
  }

  group('ChangeContactTests', () {
    test('testChangeEmail', () async {
      // Make sure we have an authToken.
      //expect(IntegrationTestConfig.AUTH_TOKEN.isNotEmpty, true);
      try {
        await loginWithOTP();
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        final response = await instance.changeEmail(identifier);
        expect(response, isNotNull);
      } catch (e) {
        fail('Test failed due to unexpected exception: $e');
      }
    });

    test('testChangeEmailUnAuthed', () async {
      try {
        final date = DateTime.now().millisecondsSinceEpoch;
        final identifier = 'authentigator+$date@passage.id';
        await instance.changeEmail(identifier);
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
        final response = instance.changePhone('+14155552671');
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
        final response = await instance.changePhone('444');
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
        await instance.changePhone('+14155552671');
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
