@JS()
library passage;

import 'package:js/js.dart';

@JS('Passage')
class Passage {
  external Passage(String appId);

  external dynamic register(String identifier);
  external dynamic login(String identifier);
}
