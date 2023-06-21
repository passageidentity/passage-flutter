import 'passage_flutter_platform_interface.dart';
import 'auth_result.dart';

class PassageFlutter {
  Future<AuthResult?> register(String identifier) {
    return PassageFlutterPlatform.instance.register(identifier);
  }
}
