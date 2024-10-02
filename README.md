<img src="https://storage.googleapis.com/passage-docs/Lockup%20Vertical%20color.png" alt="Passage logo" style="width:250px;"/>

[![Pub](https://img.shields.io/pub/v/passage_flutter.svg)](https://pub.dartlang.org/packages/passage_flutter)

### Native passkey authentication for your Flutter app
## Welcome!
Integrating passkey technology can be really hard. That's why we built the Passage Flutter SDK - to make passkey authentication easy for you and your users - across native iOS, native Android, and web.

<img width="1069" alt="Passage Flutter" src="https://storage.googleapis.com/passage-docs/passage-flutter.png">

<br>

## Installation

```sh
flutter pub add passage_flutter
```
<br>

## Example Usage

```dart
import 'package:passage_flutter/passage_flutter.dart';

final passage = PassageFlutter('YOUR_PASSAGE_APP_ID');

// Register a new user with a passkey
await passage.passkey.register('name@email.com');

// Get authenticated user info
final user = await passage.currentUser.userInfo();
```

To see a full example, check out our [Flutter Example App](https://github.com/passageidentity/example-flutter).
<br>

## Documentation
To get started using Passage in your Flutter app, please visit our [Passage Docs](https://docs.passage.id/mobile/cross-platform/flutter).
