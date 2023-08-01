import 'dart:convert';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

class Passkey {
  final String id;
  final String friendlyName;
  final String createdAt;
  final String credId;
  final String lastLoginAt;
  final String? updatedAt;
  final String userId;
  final int? usageCount;

  Passkey({
    required this.id,
    required this.friendlyName,
    required this.createdAt,
    required this.credId,
    required this.lastLoginAt,
    this.updatedAt,
    required this.userId,
    this.usageCount,
  });

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
    Map<String, dynamic> map = jsonDecode(jsonString);
    return Passkey.fromMap(map);
  }

  factory Passkey.fromJSObject(jsObject) {
    final Map<String, dynamic> resultMap = Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
    return Passkey.fromMap(resultMap);
  }
}

class PassageUser {
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
    Map<String, dynamic> map = jsonDecode(jsonString);
    return PassageUser.fromMap(map);
  }

  factory PassageUser.fromJSObject(jsObject) {
    final Map<String, dynamic> resultMap = Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
    print(resultMap);
    return PassageUser.fromMap(resultMap);
  }
}
