@JS()
library passage;

import 'package:js/js.dart';

@JS('Passage')
class Passage {
  external Passage(String appId);

  external dynamic register(String identifier);
  external dynamic login(String identifier);
  external dynamic newRegisterOneTimePasscode(String identifier);
  external dynamic newLoginOneTimePasscode(String identifier);
  external dynamic oneTimePasscodeActivate(String otp, String otpId);
  external dynamic newRegisterMagicLink(String identifier);
  external dynamic newLoginMagicLink(String identifier);
  external dynamic magicLinkActivate(String magicLink);
  external dynamic getMagicLinkStatus(String magicLinkId);
  external dynamic getCurrentSession();
  external dynamic appInfo();
  external dynamic getCurrentUser();
}
