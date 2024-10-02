import 'package:passage_flutter/passage_app.dart';
import 'package:passage_flutter/passage_current_user.dart';
import 'package:passage_flutter/passage_hosted.dart';
import 'package:passage_flutter/passage_otp.dart';
import 'package:passage_flutter/passage_magliclink.dart';
import 'package:passage_flutter/passage_passkey.dart';
import 'package:passage_flutter/passage_social.dart';
import 'package:passage_flutter/passage_token_store.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageFlutter {
  late final PassagePasskey passkey;
  late final PassageSocial social;
  late final PassageOneTimePasscode oneTimePasscode;
  late final PassageMagliclink magliclink;
  late final PassageHosted hosted;
  late final PassageApp app;
  late final PassageTokenStore tokenStore;
  late final PassageCurrentUser currentUser;
  PassageFlutter(String appId) {
    PassageFlutterPlatform.instance.initialize(appId);
    passkey = PassagePasskey();
    social = PassageSocial();
    oneTimePasscode = PassageOneTimePasscode();
    magliclink = PassageMagliclink();
    hosted = PassageHosted();
    app =PassageApp();
    tokenStore = PassageTokenStore();
    currentUser = PassageCurrentUser();
  }

}
