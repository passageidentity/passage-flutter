import 'package:passage_flutter/passage_flutter_models/passage_user.dart';

class IntegrationTestConfig {
  static const String apiBaseUrl = "https://auth-uat.passage.dev/v1";
  static const String appIdOtp = "Ezbk6fSdx9pNQ7v7UbVEnzeC";
  static const String appIdMagicLink = "Pea2GdtBHN3esylK4ZRlF19U";
  static const int waitTimeMilliseconds = 8000;
  static const String existingUserEmailOtp =
      "authentigator+1716916054778@ncor7c1m.mailosaur.net";
  static const String existingUserEmailMagicLink =
      "authentigator+1716572384858@ncor7c1m.mailosaur.net";
  static const String deactivatedUserEmailMagicLink =
      "authentigator+1716778790434@ncor7c1m.mailosaur.net";

  static final PassageUser currentUser = PassageUser.fromMap({
    'id': "rDZm8yMxTuZMu0oXaEFOAtV3",
    'email': "authentigator+1716572384858@ncor7c1m.mailosaur.net",
    'status': 'active',
    'emailVerified': true,
    'phone': "",
    'phoneVerified': false,
    'createdAt': '2024-05-24T17:40:04.061043Z',
    'userMetadata': null,
    'webauthn': false,
    'webauthnDevices': [],
    'webauthnTypes': [],
  });
}
