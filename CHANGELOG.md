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
