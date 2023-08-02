import 'dart:convert';
import '/passage_flutter_models/passage_flutter_model.dart';

T fromJson<T extends PassageFlutterModel>(String jsonString, Function fromMap) {
  Map<String, dynamic> map = jsonDecode(jsonString);
  return fromMap(map) as T;
}
