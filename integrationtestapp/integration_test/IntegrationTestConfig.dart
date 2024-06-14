import 'package:passage_flutter/passage_flutter_models/passage_user.dart';

class IntegrationTestConfig {
  static const String API_BASE_URL = "https://auth-uat.passage.dev";
  static const String APP_ID_OTP = "Ezbk6fSdx9pNQ7v7UbVEnzeC";
  static const String APP_ID_MAGIC_LINK = "Pea2GdtBHN3esylK4ZRlF19U";
  static const int WAIT_TIME_MILLISECONDS = 8000;
  static const String EXISTING_USER_EMAIL_OTP =
      "authentigator+1716916054778@ncor7c1m.mailosaur.net";
  static const String EXISTING_USER_EMAIL_MAGIC_LINK =
      "authentigator+1716572384858@ncor7c1m.mailosaur.net";
  static const String DEACTIVATED_USER_EMAIL_MAGIC_LINK =
      "authentigator+1716778790434@ncor7c1m.mailosaur.net";

  static final PassageUser CURRENT_USER = PassageUser.fromMap({
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
