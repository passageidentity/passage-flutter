import 'package:passage_flutter/passage_hosted.dart';
import 'package:passage_flutter/passage_otp.dart';
import 'package:passage_flutter/passage_magliclink.dart';
import 'package:passage_flutter/passage_passkey.dart';
import 'package:passage_flutter/passage_social.dart';
import 'package:passage_flutter/passage_token_store.dart';
import 'passage_flutter_models/passage_app_info.dart';
import 'passage_flutter_models/passage_user.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageFlutter {
  late final PassagePasskey passkey;
  late final PassageSocial social;
  late final PassageOneTimePasscode oneTimePasscode;
  late final PassageMagliclink magliclink;
  late final PassageHosted hosted;
  late final PassageTokenStore tokenStore;
  PassageFlutter([String? appId]) {
    if (appId != null) {
      PassageFlutterPlatform.instance.initWithAppId(appId);
    }
    passkey = PassagePasskey();
    social = PassageSocial();
    oneTimePasscode = PassageOneTimePasscode();
    magliclink = PassageMagliclink();
    hosted = PassageHosted();
    tokenStore = PassageTokenStore();
  }

  Future<void> overrideBasePath(String path) async {
    return await PassageFlutterPlatform.instance
        .overrideBasePath(path);
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

  Future<CurrentUser?> identifierExists(String identifier) {
    return PassageFlutterPlatform.instance.identifierExists(identifier);
  }

}
