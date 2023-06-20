@JS()
library passage;

import 'package:js/js.dart';
import 'auth_result.dart';

@JS('Passage')
class Passage {
  external Passage(String appId);

  external dynamic register(String identifier);
}
