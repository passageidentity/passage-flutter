@JS()
library passage;

import 'package:js/js.dart';

@JS('Passage')
class Passage {
  external factory Passage(String appId);

  // PASSKEY AUTH METHODS
  external dynamic register(String identifier, dynamic options);
  external dynamic login(String identifier);
  external IGetCredentialFeatures getCredentialAvailable();

  // OTP METHODS
  external dynamic newRegisterOneTimePasscode(String identifier);
  external dynamic newLoginOneTimePasscode(String identifier);
  external dynamic oneTimePasscodeActivate(String otp, String otpId);

  // MAGIC LINK METHODS
  external dynamic newRegisterMagicLink(String identifier);
  external dynamic newLoginMagicLink(String identifier);
  external dynamic magicLinkActivate(String magicLink);
  external dynamic getMagicLinkStatus(String magicLinkId);

  // SOCIAL AUTH METHODS
  external dynamic authorizeWith(String connection);
  external dynamic finishSocialAuthentication(String code);

  // TOKEN METHODS
  external Session getCurrentSession();

  // APP METHODS
  external dynamic appInfo();
  external dynamic identifierExists(String identifier);

  // USER METHODS
  external User getCurrentUser();
}

@JS()
class User {
  external dynamic userInfo();
  external dynamic addDevice(dynamic options);
  external dynamic deleteDevice(String passkeyId);
  external dynamic editDevice(String passkeyId, dynamic obj);
  external dynamic changeEmail(String newEmail);
  external dynamic changePhone(String newPhone);
}

@JS()
class Session {
  external dynamic getAuthToken();
  external dynamic refresh();
  external dynamic signOut();
}

@JS()
class IGetCredentialFeatures {
  external bool platform;
}
