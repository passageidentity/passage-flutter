import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';

class PassageFlutter {
  Future<String?> getPlatformVersion() {
    return PassageFlutterPlatform.instance.getPlatformVersion();
  }

  Future<AuthResult?> register(String identifier) {
    return PassageFlutterPlatform.instance.register(identifier);
  }
}
