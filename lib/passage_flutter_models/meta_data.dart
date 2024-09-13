import 'passage_flutter_model.dart';
import 'dart:convert';

class Metadata implements PassageFlutterModel {
  final dynamic userMetadata;

  Metadata({required this.userMetadata});

  Metadata.fromMap(Map<String, dynamic> map)
      : userMetadata = map['userMetadata'];

  factory Metadata.fromJson(String jsonString) {
    final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
    
    return Metadata.fromMap(decodedJson);
  }

  Map<String, dynamic> toMap() {
    return {
      'userMetadata': userMetadata,
    };
  }
}
