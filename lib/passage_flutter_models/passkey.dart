import 'passage_flutter_model.dart';
import '../helpers/data_conversion.dart';

class Passkey implements PassageFlutterModel {
  final String id;
  final String friendlyName;
  final String createdAt;
  final String credId;
  final String lastLoginAt;
  final String? updatedAt;
  final String userId;
  final int? usageCount;

  Passkey.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        friendlyName = map['friendlyName'] ?? map['friendly_name'],
        createdAt = map['createdAt'] ?? map['created_at'],
        credId = map['credId'] ?? map['cred_id'],
        lastLoginAt = map['lastLoginAt'] ?? map['last_login_at'],
        updatedAt = map['updatedAt'] ?? map['updated_at'],
        userId = map['userId'] ?? map['user_id'],
        usageCount = map['usageCount'] ?? map['usage_count'];

  factory Passkey.fromJson(String jsonString) {
    return fromJson(jsonString, Passkey.fromMap);
  }

  factory Passkey.fromJSObject(jsObject) {
    return fromJSObject(jsObject, Passkey.fromMap);
  }
}
