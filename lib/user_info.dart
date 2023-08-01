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
        friendlyName = map['friendlyName'],
        createdAt = map['createdAt'],
        credId = map['credId'],
        lastLoginAt = map['lastLoginAt'],
        updatedAt = map['updatedAt'],
        userId = map['userId'],
        usageCount = map['usageCount'];
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
  final List<Passkey> webauthnDevices;
  final List<String> webauthnTypes;

  // PassageUser({
  //   required this.id,
  //   this.status,
  //   this.email,
  //   required this.emailVerified,
  //   this.phone,
  //   required this.phoneVerified,
  //   required this.createdAt,
  //   this.updatedAt,
  //   this.lastLoginAt,
  //   required this.loginCount,
  //   required this.userMetadata,
  //   required this.webauthn,
  //   required this.webauthnDevices,
  //   required this.webauthnTypes,
  // });

  PassageUser.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        status = map['status'],
        email = map['email'],
        emailVerified = map['emailVerified'],
        phone = map['phone'],
        phoneVerified = map['phoneVerified'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'],
        lastLoginAt = map['lastLoginAt'],
        loginCount = map['loginCount'],
        userMetadata = map['userMetadata'],
        webauthn = map['webauthn'],
        webauthnDevices = (map['webauthnDevices'] as List<dynamic>)
            .map((item) => Passkey.fromMap(item as Map<String, dynamic>))
            .toList(),
        webauthnTypes = List<String>.from(map['webauthnTypes']);

  factory PassageUser.fromJson(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return PassageUser.fromMap(map);
  }

  factory PassageUser.fromJSObject(jsObject) {
    final Map<String, dynamic> resultMap = Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
    return PassageUser.fromMap(resultMap);
  }
}
