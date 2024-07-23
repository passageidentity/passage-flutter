import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/authenticator_attachment.dart';
import 'passage_flutter_models/passage_app_info.dart';
import 'passage_flutter_models/passage_social_connection.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_models/passkey.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageFlutter {
  PassageFlutter([String? appId]) {
    if (appId != null) {
      PassageFlutterPlatform.instance.initWithAppId(appId);
    }
  }

  // PASSKEY AUTH METHODS

  /// Attempts to create and register a new user with a passkey.
  ///
  /// The method will try to register a user using the provided identifier which
  /// can be either an email address or a phone number.
  ///
  /// Parameters:
  ///  - `identifier`: Email address or phone for the user.
  ///  - `options`: Optional configuration for passkey creation.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - User already exists
  ///  - App configuration was not done properly
  ///  - etc.
  Future<AuthResult> registerWithPasskey(String identifier,
      [PasskeyCreationOptions? options]) {
    return PassageFlutterPlatform.instance
        .registerWithPasskey(identifier, options);
  }

  /// **DEPRECATED. Use `registerWithPasskey` instead.**
  @Deprecated('Use `registerWithPasskey` instead.')
  Future<AuthResult> register(String identifier) {
    return PassageFlutterPlatform.instance
        .registerWithPasskey(identifier, null);
  }

  /// Attempts to login a user with a passkey.
  ///
  /// Parameters:
  ///  - `identifier`: Email address or phone for the user (optional).
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - User does not exist
  ///  - App configuration was not done properly
  ///  - etc.
  Future<AuthResult> loginWithPasskey([String? identifier]) {
    return PassageFlutterPlatform.instance.loginWithPasskey(identifier);
  }

  /// **DEPRECATED. Use `loginWithPasskey` instead.**
  @Deprecated('Use `loginWithPasskey` instead.')
  Future<AuthResult> login() {
    return PassageFlutterPlatform.instance.loginWithPasskey('');
  }

  /// **DEPRECATED. Use `loginWithPasskey` instead.**
  @Deprecated('Use `loginWithPasskey` instead.')
  Future<AuthResult> loginWithIdentifier(String identifier) {
    return PassageFlutterPlatform.instance.loginWithPasskey(identifier);
  }

  Future<bool> deviceSupportsPasskeys() {
    return PassageFlutterPlatform.instance.deviceSupportsPasskeys();
  }

  // OTP METHODS

  /// Creates and sends a new one-time passcode for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> newRegisterOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance
        .newRegisterOneTimePasscode(identifier);
  }

  /// Creates and sends a new one-time passcode for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a one-time passcode ID used to activate
  ///  the passcode in `oneTimePasscodeActivate`.
  ///
  /// Throws:
  ///  `PassageError`

  Future<String> newLoginOneTimePasscode(String identifier) {
    return PassageFlutterPlatform.instance.newLoginOneTimePasscode(identifier);
  }

  Future<void> overrideBasePath(String path) async {
    return await PassageFlutterPlatform.instance
        .overrideBasePath(path);
  }

  /// Activates a one-time passcode when a user inputs it. This function handles both login and registration one-time passcodes.
  ///
  /// Parameters:
  ///  - `otp`: The one-time passcode.
  ///  - `otpId`: The one-time passcode ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> oneTimePasscodeActivate(String otp, String otpId) {
    return PassageFlutterPlatform.instance.oneTimePasscodeActivate(otp, otpId);
  }

  // MAGIC LINK METHODS

  /// Creates and sends a new magic link for registration.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a magic link ID used to check the status
  ///  of the magic link with `getMagicLinkStatus`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> newRegisterMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newRegisterMagicLink(identifier);
  }

  /// Creates and sends a new magic link for logging in.
  ///
  /// Parameters:
  ///  - `identifier`: The Passage User's identifier.
  ///
  /// Returns:
  ///  A `Future<String>` that returns a magic link ID used to check the status
  ///  of the magic link with `getMagicLinkStatus`.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> newLoginMagicLink(String identifier) {
    return PassageFlutterPlatform.instance.newLoginMagicLink(identifier);
  }

  /// Activates a magic link. This function handles both login and registration magic links.
  ///
  /// Parameters:
  ///  - `magicLink`: The magic link from the URL sent to the user.
  ///
  /// Returns:
  ///  A `Future<AuthResult>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult> magicLinkActivate(String magicLink) {
    return PassageFlutterPlatform.instance.magicLinkActivate(magicLink);
  }

  /// Looks up a magic link by ID and checks if it has been verified. This function is most commonly used to
  /// iteratively check if a user has clicked a magic link to login. Once the link has been verified,
  /// Passage will return authentication information via this function. This enables cross-device login.
  ///
  /// Parameters:
  ///  - `magicLinkId`: The magic link ID.
  ///
  /// Returns:
  ///  A `Future<AuthResult?>` object that includes a redirect URL and saves the
  ///  authorization token and (optional) refresh token securely to the device, or `null` if
  ///  the magic link has not been verified.
  ///
  /// Throws:
  ///  `PassageError`
  Future<AuthResult?> getMagicLinkStatus(String magicLinkId) {
    return PassageFlutterPlatform.instance.getMagicLinkStatus(magicLinkId);
  }

  // SOCIAL AUTH METHODS
  Future<void> authorizeWith(PassageSocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeWith(connection);
  }

  Future<AuthResult> finishSocialAuthentication(String code) {
    return PassageFlutterPlatform.instance.finishSocialAuthentication(code);
  }

  Future<AuthResult> authorizeIOSWith(PassageSocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeIOSWith(connection);
  }

  // TOKEN METHODS

  /// Returns the auth token for the currently authenticated user.
  ///
  /// Returns:
  ///  A `Future<String?>` representing the current Passage user's auth token,
  ///  or `null` if no token has been stored.
  Future<String?> getAuthToken() {
    return PassageFlutterPlatform.instance.getAuthToken();
  }

  /// Checks if the auth token for the currently authenticated user is valid.
  ///
  /// Returns:
  ///  A `Future<bool>` that returns `true` if the user has a valid auth token,
  ///  and `false` otherwise.
  Future<bool> isAuthTokenValid(String authToken) {
    return PassageFlutterPlatform.instance.isAuthTokenValid(authToken);
  }

  /// Refreshes, retrieves, and saves a new authToken for the currently authenticated user using their refresh token.
  ///
  /// Returns:
  ///  A `Future<String>` representing the new auth token.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> refreshAuthToken() {
    return PassageFlutterPlatform.instance.refreshAuthToken();
  }

  /// Sign out a user by deleting their auth token and refresh token from device, and revoking their refresh token.
  Future<void> signOut() {
    return PassageFlutterPlatform.instance.signOut();
  }

  // APP METHODS

  /// Gets information about an app.
  ///
  /// Returns:
  ///  A `Future<PassageAppInfo>` object containing app information, authentication policy, etc.
  ///
  /// Throws:
  ///  `PassageError`
  Future<PassageAppInfo?> getAppInfo() {
    return PassageFlutterPlatform.instance.getAppInfo();
  }

  Future<PassageUser?> identifierExists(String identifier) {
    return PassageFlutterPlatform.instance.identifierExists(identifier);
  }

  // USER METHODS

  /// Returns the user information for the currently authenticated user.
  ///
  /// Returns:
  ///  A `Future<PassageUser?>` representing the current Passage user's info,
  ///  or `null` if the current Passage user's authentication token could not be validated.
  Future<PassageUser?> getCurrentUser() {
    return PassageFlutterPlatform.instance.getCurrentUser();
  }

  /// Attempts to create and register a new passkey for the authenticated user.
  ///
  /// Parameters:
  ///  - `options`: Optional configuration for passkey creation.
  ///
  /// Returns:
  ///  A `Future<Passkey>` representing an object containing all of the data about the new passkey.
  ///
  /// Throws:
  ///  A `PassageError` in cases such as:
  ///  - User cancels the operation
  ///  - App configuration was not done properly
  ///  - etc.
  Future<Passkey> addPasskey([PasskeyCreationOptions? options]) {
    return PassageFlutterPlatform.instance.addPasskey(options);
  }

  /// Removes a passkey from a user's account.
  /// NOTE: This does NOT remove the passkey from the user's device, but revokes that passkey so it's no longer usable.
  ///
  /// Parameters:
  ///  - `passkeyId`: The ID of the passkey to delete.
  ///
  /// Throws:
  ///  `PassageError`
  Future<void> deletePasskey(String passkeyId) {
    return PassageFlutterPlatform.instance.deletePasskey(passkeyId);
  }

  /// Edits the `friendlyName` of the authenticated user's device passkey.
  ///
  /// Parameters:
  ///  - `passkeyId`: The ID of the passkey to edit.
  ///  - `newPasskeyName`: The new name for the passkey.
  ///
  /// Returns:
  ///  A `Future<Passkey>` object containing all of the data about the updated passkey.
  ///
  /// Throws:
  ///  `PassageError`
  Future<Passkey> editPasskeyName(String passkeyId, String newPasskeyName) {
    return PassageFlutterPlatform.instance
        .editPasskeyName(passkeyId, newPasskeyName);
  }

  /// Initiates an email change for the authenticated user. An email change requires verification,
  /// so an email will be sent to the user which they must verify before the email change takes effect.
  ///
  /// Parameters:
  ///  - `newEmail`: The user's new email.
  ///
  /// Returns:
  ///  A `Future<String>` representing the magic link ID.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> changeEmail(String newEmail) {
    return PassageFlutterPlatform.instance.changeEmail(newEmail);
  }

  /// Initiates a phone number change for the authenticated user. A phone change requires verification,
  /// so an email will be sent to the user which they must verify before the phone change takes effect.
  ///
  /// Parameters:
  ///  - `newPhone`: The user's new phone number.
  ///
  /// Returns:
  ///  A `Future<String>` representing the magic link ID.
  ///
  /// Throws:
  ///  `PassageError`
  Future<String> changePhone(String newPhone) {
    return PassageFlutterPlatform.instance.changePhone(newPhone);
  }

  // Hosted Auth Methods
  
  /// Authentication Method for Hosted Apps
  ///
  /// If your Passage app is Hosted, use this method to register and log in your user. This method will open up a Passage login experience
  /// Throws:
  ///  `PassageError`
    
  Future<void> hostedAuthStart() {
    return PassageFlutterPlatform.instance.hostedAuthStart();
  }

  // Hosted Auth Methods
  
  /// Authentication Method for Hosted Apps
  /// ONLY FOR iOS
  /// If your Passage app is Hosted, use this method to register and log in your user. This method will open up a Passage login experience
  /// 
  /// Throws:
  ///  `PassageError`
    
  Future<AuthResult> hostedAuthIOS() {
    return PassageFlutterPlatform.instance.hostedAuthIOS();
  }

  /// Finish Hosted Auth
  ///
  /// Finishes a Hosted login/sign up by exchanging the auth code for Passage tokens.
  /// Parameters:
  /// code: The code returned from app link redirect to your activity.
  /// clientSecret: You hosted app's client secret, found in Passage Console's OIDC Settings.
  /// state: The state returned from app link redirect to your activity.
  /// Throws:
  ///  `PassageError`

  Future<AuthResult> hostedAuthFinish(String code, String state) {
    return PassageFlutterPlatform.instance.hostedAuthFinish(code, state);
  }

  /// Logout Method for Hosted Apps
  ///
  /// If your Passage app is Hosted, use this method to log out your user. This method will briefly open up a web view where it will log out the
  /// Throws:
  ///  `PassageError`

  Future<void> hostedLogout() {
    return PassageFlutterPlatform.instance.hostedLogout();
  }

}
