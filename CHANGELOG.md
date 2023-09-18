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
