import 'passage_flutter_models/auth_result.dart';
import 'passage_flutter_models/passage_social_connection.dart';
import 'passage_flutter_platform/passage_flutter_platform_interface.dart';

class PassageSocial {
  Future<void> authorize(SocialConnection connection) {
      return PassageFlutterPlatform.instance.authorizeWith(connection);
  }

  Future<AuthResult> finish(String code) {
    return PassageFlutterPlatform.instance.finishSocialAuthentication(code);
  }

  Future<AuthResult> authorizeIOS(SocialConnection connection) {
    return PassageFlutterPlatform.instance.authorizeIOSWith(connection);
  }
}