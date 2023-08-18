@JS()
library passage;

import 'package:js/js.dart';

@JS('Passage')
class Passage {
  external Passage(String appId);

  // PASSKEY AUTH METHODS
  external dynamic register(String identifier);
  external dynamic login(String identifier);
  external dynamic getCredentialAvailable();

  // OTP METHODS
  external dynamic newRegisterOneTimePasscode(String identifier);
  external dynamic newLoginOneTimePasscode(String identifier);
  external dynamic oneTimePasscodeActivate(String otp, String otpId);

  // MAGIC LINK METHODS
  external dynamic newRegisterMagicLink(String identifier);
  external dynamic newLoginMagicLink(String identifier);
  external dynamic magicLinkActivate(String magicLink);
  external dynamic getMagicLinkStatus(String magicLinkId);

  // TOKEN METHODS
  external dynamic getCurrentSession();

  // APP METHODS
  external dynamic appInfo();

  // USER METHODS
  external dynamic getCurrentUser();
}
