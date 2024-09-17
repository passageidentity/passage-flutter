import 'dart:convert';
import 'passage_flutter_model.dart';

class Metadata implements PassageFlutterModel {
  final dynamic userMetadata;

  Metadata({required this.userMetadata});

  factory Metadata.fromJson(String jsonString) {
    final decodedJson = jsonDecode(jsonString);
    return Metadata.fromMap(decodedJson);
  }

  Metadata.fromMap(Map<String, dynamic> map)
      : userMetadata = map['userMetadata'];

  Map<String, dynamic> toMap() {
    return {
      'userMetadata': userMetadata,
    };
  }

  Map<String, dynamic> toJson() => {
        'userMetadata': userMetadata,
      };
}
