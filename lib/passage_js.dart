@JS()
library passage;

import 'package:js/js.dart';
import 'auth_result.dart';

@JS('Passage')
class Passage {
  external Passage(String appId);

  external Future<AuthResult> register(String identifier);
}
