
import 'passage_flutter_platform_interface.dart';

class PassageFlutter {
  Future<String?> getPlatformVersion() {
    return PassageFlutterPlatform.instance.getPlatformVersion();
  }
}
