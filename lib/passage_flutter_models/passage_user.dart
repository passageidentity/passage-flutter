import 'passage_flutter_model.dart';
import '../helpers/data_conversion.dart';

class PassageUser implements PassageFlutterModel {
  final String id;
  final String? status;
  final String? email;
  final bool emailVerified;
  final String? phone;
  final bool phoneVerified;
  final String createdAt;
  final String? updatedAt;
  final String? lastLoginAt;
  final int loginCount;
  final dynamic userMetadata;
  final bool webauthn;
  // TODO: Fix error from Passage JS mapping of arrays
  // final List<Passkey> webauthnDevices;
  // final List<String> webauthnTypes;

  PassageUser.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        email = map['email'],
        emailVerified = map['emailVerified'] ?? map['email_verified'],
        phone = map['phone'],
        phoneVerified = map['phoneVerified'] ?? map['phone_verified'],
        createdAt = map['createdAt'] ?? map['created_at'],
        updatedAt = map['updatedAt'] ?? map['updated_at'],
        lastLoginAt = map['lastLoginAt'] ?? map['last_login_at'],
        loginCount = map['loginCount'] ?? map['login_count'],
        userMetadata = map['userMetadata'] ?? map['user_metadata'],
        webauthn = map['webauthn'];
  // webauthnDevices =
  //     (map['webauthnDevices'] ?? map['webauthn_devices'] as List<dynamic>)
  //         .map((item) => Passkey.fromMap(item as Map<String, dynamic>))
  //         .toList(),
  // webauthnTypes = List<String>.from(map['webauthnTypes']);

  factory PassageUser.fromJson(String jsonString) {
    return fromJson(jsonString, PassageUser.fromMap);
  }

  factory PassageUser.fromJSObject(jsObject) {
    return fromJSObject(jsObject, PassageUser.fromMap);
  }
}
