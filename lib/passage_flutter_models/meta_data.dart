import 'dart:convert';
import 'passage_flutter_model.dart';

class Metadata implements PassageFlutterModel {
  final dynamic userMetadata;

  Metadata({required this.userMetadata});

  factory Metadata.fromJson(dynamic jsonInput) {
    if (jsonInput is String) {
      final decodedJson = jsonDecode(jsonInput);
      return Metadata.fromMap(decodedJson);
    } else if (jsonInput is Map<String, dynamic>) {
      return Metadata.fromMap(jsonInput);
    } else {
      throw ArgumentError('Invalid input type for Metadata.fromJson');
    }
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
