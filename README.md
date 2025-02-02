![passage-flutter](https://storage.googleapis.com/passage-docs/github-md-assets/passage-flutter.png)

[![Pub](https://img.shields.io/pub/v/passage_flutter.svg)](https://pub.dartlang.org/packages/passage_flutter) ![GitHub License](https://img.shields.io/github/license/passageidentity/passage-flutter) [![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=fff)](#) [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?logo=dart&logoColor=white)](#) ![Static Badge](https://img.shields.io/badge/Built_by_1Password-grey?logo=1password)

## About

[Passage by 1Password](https://1password.com/product/passage) unlocks the passwordless future with a simpler, more secure passkey authentication experience. Passage handles the complexities of the [WebAuthn API](https://blog.1password.com/what-is-webauthn/), and allows you to implement passkeys with ease.

Use [Passkey Flex](https://docs.passage.id/flex) to add passkeys to an existing authentication experience.

Use [Passkey Complete](https://docs.passage.id/complete) as a standalone passwordless auth solution.

Use [Passkey Ready](https://docs.passage.id/passkey-ready) to determine if your users are ready for passkeys.

### In passage-flutter

Use passage-flutter to implement Passkey Complete in your Flutter application to authenticate requests and manage users.

| Product                                                                                                                                  | Compatible                                                                                                                                                                                                                |
| ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ![Passkey Flex](https://storage.googleapis.com/passage-docs/github-md-assets/passage-passkey-flex-icon.png) Passkey **Flex**             | ✖️ For Passkey Flex, check out the [Passkey Flex for Android](https://github.com/passageidentity/passage-android/tree/main/passageflex) and [Passkey Flex for iOS](https://github.com/passageidentity/passage-flex-ios)   |
| ![Passkey Complete](https://storage.googleapis.com/passage-docs/github-md-assets/passage-passkey-complete-icon.png) Passkey **Complete** | ✅                                                                                                                                                                                                                        |
| ![Passkey Ready](https://storage.googleapis.com/passage-docs/github-md-assets/passage-passkey-ready-icon.png) Passkey **Ready**          | ✖️ For Passkey Ready, check out [Authentikit for Android](https://github.com/passageidentity/passage-android/tree/main/authentikit) and [Authentikit for iOS](https://github.com/passageidentity/passage-authentikit-ios) |

<br />

## Getting Started

### Check Prerequisites

<p>
 You'll need a free Passage account and a Passkey Complete app set up in <a href="https://console.passage.id/">Passage Console</a> to get started. <br />
 <sub><a href="https://docs.passage.id/home#passage-console">Learn more about Passage Console →</a></sub>
</p>

### Install

```shell
flutter pub add passage_flutter
```

### Import

```dart
import 'package:passage_flutter/passage_flutter.dart';
```

### Initialize

```dart
final passage = PassageFlutter('YOUR_PASSAGE_APP_ID');
```

### Go Passwordless

Find all core functions, user management details, and more implementation guidance on our [Passkey Complete Flutter Documentation](https://docs.passage.id/complete/flutter/add-passage) page.

## Support & Feedback

We are here to help! Find additional docs, the best ways to get in touch with our team, and more within our [support resources](https://github.com/passageidentity/.github/blob/main/SUPPORT.md).

<br />

---

<p align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://storage.googleapis.com/passage-docs/github-md-assets/passage-by-1password-dark.png">
      <source media="(prefers-color-scheme: light)" srcset="https://storage.googleapis.com/passage-docs/github-md-assets/passage-by-1password-light.png">
      <img alt="Passage by 1Password Logo" src="https://storage.googleapis.com/passage-docs/github-md-assets/passage-by-1password-light.png">
    </picture>
</p>

<p align="center">
    <sub>Passage is a product by <a href="https://1password.com/product/passage">1Password</a>, the global leader in access management solutions with nearly 150k business customers.</sub><br />
    <sub>This project is licensed under the MIT license. See the <a href="LICENSE.md">LICENSE</a> file for more info.</sub>
</p>
