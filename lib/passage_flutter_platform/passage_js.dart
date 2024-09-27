@JS()
library passage;

import 'package:js/js.dart';
import '../passage_flutter_models/authenticator_attachment.dart';
import '../passage_flutter_models/meta_data.dart';

/// Main Passage class corresponding to the updated PassageJS interface.
@JS('Passage')
class Passage {
  external factory Passage(String appId, [PassageConfig? config]);

  external PassageApp get app;
  external PassagePasskey get passkey;
  external PassageMagicLink get magicLink;
  external PassageOneTimePasscode get oneTimePasscode;
  external PassageSocial get social;
  external PassageCurrentUser get currentUser;
  external PassageSession get session;
}

/// Configuration options for initializing Passage.
@JS()
@anonymous
class PassageConfig {
  external factory PassageConfig({
    String? apiUrl,
    String? redirectUrl,
    String? refreshTokenUrl,
  });

  external String? get apiUrl;
  external String? get redirectUrl;
  external String? get refreshTokenUrl;
}

/// PassageApp class for app-related methods.
@JS()
class PassageApp {
  external dynamic info(); // Returns Promise<PassageAppInfo>
  external dynamic userExists(String identifier); // Returns Promise<PublicUserInfo>
  external dynamic createUser(String identifier, [Metadata? userMetadata]); // Returns Promise<PublicUserInfo>
}

/// PassagePasskey class for passkey authentication methods.
@JS()
class PassagePasskey {
  external dynamic register(String identifier, [PasskeyCreationOptions? options]); // Returns Promise<AuthResult>
  external dynamic login([String? identifier, PasskeyLoginOptions? options]); // Returns Promise<AuthResult>
  external dynamic getCredentialAvailable(); // Returns Promise<IGetCredentialFeatures>
  external dynamic createCredentialAvailable(); // Returns Promise<ICreateCredentialFeatures>
  external bool checkPasskeyOrigin(); // Returns boolean
  external bool hasLocalPasskey(String userId); // Returns boolean
}

/// PassageMagicLink class for magic link authentication methods.
@JS()
class PassageMagicLink {
  external dynamic register(String identifier, [String? language]); // Returns Promise<MagicLink>
  external dynamic login(String identifier, [String? language]); // Returns Promise<MagicLink>
  external dynamic activate(String magicLink); // Returns Promise<AuthResult>
  external dynamic status(String id); // Returns Promise<AuthResult>
}

/// PassageOneTimePasscode class for OTP authentication methods.
@JS()
class PassageOneTimePasscode {
  external dynamic register(String identifier, [String? language]); // Returns Promise<OneTimePasscode>
  external dynamic login(String identifier, [String? language]); // Returns Promise<OneTimePasscode>
  external dynamic activate(String oneTimePasscode, String id); // Returns Promise<AuthResult>
}

/// PassageSocial class for social authentication methods.
@JS()
class PassageSocial {
  external dynamic authorize(String connection); // Returns Promise<void>
  external dynamic finish(String code); // Returns Promise<AuthResult>
}

/// PassageCurrentUser class for current user methods.
@JS()
class PassageCurrentUser {
  external dynamic userInfo(); // Returns Promise<CurrentUser | undefined>
  external dynamic changeEmail(String newEmail, [String? language]); // Returns Promise<MagicLink>
  external dynamic changePhone(String newPhone, [String? language]); // Returns Promise<MagicLink>
  external dynamic editPasskey(String passkeyId, String friendlyName); // Returns Promise<Passkey>
  external dynamic addPasskey([PasskeyCreationOptions? options]); // Returns Promise<Passkey>
  external dynamic deletePasskey(Passkey passkey); // Returns Promise<bool>
  external dynamic passkeys(); // Returns Promise<List<Passkey>>
  external dynamic listSocialConnections(); // Returns Promise<UserSocialConnections>
  external dynamic deleteSocialConnection(String socialConnectionType); // Returns Promise<bool>
  external dynamic metadata(); // Returns Promise<Metadata>
  external dynamic updateMetadata(dynamic metadata); // Returns Promise<CurrentUser>
}

/// PassageSession class for session management methods.
@JS()
class PassageSession {
  external dynamic getAuthToken(); // Returns Promise<String>
  external dynamic refresh(); // Returns Promise<AuthResult>
  external dynamic signOut(); // Returns Promise<void>
}

@JS()
@anonymous
class Passkey {
  external String get id;
  external set id(String value);

  external factory Passkey({String id});
}

/// Options for passkey login.
@JS()
@anonymous
class PasskeyLoginOptions {
  external factory PasskeyLoginOptions({
    bool? isConditionalMediation,
    dynamic abortSignal, // Represents AbortSignal
  });

  external bool? get isConditionalMediation;
  external dynamic get abortSignal;
}