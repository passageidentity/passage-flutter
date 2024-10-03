## 1.0.0

* Merge pull request #78 from passageidentity/PSG-4888

## 0.8.2

* Merge pull request #61 from passageidentity/PSG-4590

## 0.8.1

* Merge pull request #56 from passageidentity/PSG-4533

## 0.8.0

* Merge pull request #52 from passageidentity/PSG-4176

## 0.7.3

* Merge pull request #45 from passageidentity/PSG-3992

## 0.7.1

Fixed issue with Android code obfuscation.

## 0.7.0

### What's new

* Added new and improved `registerWithPasskey` and `loginWithPasskey` methods.
* Deprecated `login` and `register` methods.

### Example code
```dart
final identifier = 'name@email.com'

// Register a new user with a passkey and optionally provide `PasskeyCreationOptions`.
// These example options will allow a user to register using a physical security key.
final options = PasskeyCreationOptions(
  authenticatorAttachment: AuthenticatorAttachment.crossPlatform);
await _passage.registerWithPasskey(identifier, options);

// Log in using a passkey and optionally pass a user identifier.
await _passage.loginWithPasskey(identifier);
```

## 0.6.1

Update Passage Android dependency.

## 0.6.0

### What's new

Users can now log in to a Passage app using Social Login.
Upon successful login using passage.authorizeWith, Passage Flutter will save the user's tokens to device.

### Example code
```dart
const connection = PassageSocialConnection.github

// Web and Android
// Step 1: Send user to Social Login page
passage.authorizeWith(connection);
// Step 2: When Social Login page redirects to your app, extract the auth code to finish login
final uri = Uri.parse(YOUR_REDIRECT_URI);
final code = uri.queryParameters['code'];
final authResult = await passage.finishSocialAuthentication(code);

// iOS
// iOS handles the process in a single step.
final authResult = await passage.authorizeIOSWith(connection);
```


## 0.5.0

This release release deprecates `PassageAppInfo.authFallbackMethod` in favor of `PassageAppInfo.authMethods` and fixes an issue with token validation for web apps.

## 0.4.0

This release adds `identifierExists` method.

Developers can use this method to check if a user with a given identifier (ie email or phone number) exists. Additionally, developers can check the user's status, whether they have registered a passkey, etc.

Example usage:
```dart
final userInfo = await _passage.identifierExists('name@email.com');
if (userInfo == null) {
  // User does not exist, show an error message.
} else if (userInfo?.webauthn == true) {
  // User exists and has a passkey. Try logging in with a passkey.
} else {
  // Try another auth method like a one-time passcode, if applicable
}
```

This release also includes a new error code: `PassageErrorCode.otpActivationExceededAttempts`, thrown when a user attempts to activate a one-time passcode too many times.


## 0.3.0

This release adds passkey support for devices running Android 14.

## 0.2.0

This release includes changes to make app configuration easier.

When you create an instance of the Passage class, you can set your Passage app id like this:

```
final passage = PassageFlutter("ABCDEF123456");
```

If you decide to pass your app id in this way, you no longer need the following configuration steps:
* the entire `Passage.plist` file for your iOS app
* the `passage_app_id property` in your `strings.xml` file in your Android app
* the `window.passageAppId` set in your index.html file for your web app


## 0.1.0

* Initial Flutter SDK release.
