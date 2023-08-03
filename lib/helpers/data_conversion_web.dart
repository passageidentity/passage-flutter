import 'dart:js_util' as js_util;
import 'package:js/js.dart';
import '/passage_flutter_models/passage_flutter_model.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

T fromJson<T extends PassageFlutterModel>(jsObject, Function fromMap) {
  final Map<String, dynamic> resultMap = jsObjectToMap(jsObject);
  return fromMap(resultMap) as T;
}

Map<String, dynamic> jsObjectToMap(jsObject) {
  return Map.fromIterable(
    _getKeysOfObject(jsObject),
    value: (key) => js_util.getProperty(jsObject, key),
  );
}
