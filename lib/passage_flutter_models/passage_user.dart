import 'package:flutter/foundation.dart';

import '/helpers/data_conversion.dart'
    if (dart.library.js) '/helpers/data_conversion_web.dart';
import '/passage_flutter_models/passkey.dart';
import 'passage_flutter_model.dart';

class PassageUser implements PassageFlutterModel {
  final String id;
  final String? status;
  final String? email;
  final bool emailVerified;
  final String? phone;
  final bool phoneVerified;
  final String? createdAt;
  final String? updatedAt;
  final String? lastLoginAt;
  final int? loginCount;
  final dynamic userMetadata;
  final bool webauthn;
  final List<dynamic>? webauthnDevices;
  final List<String>? webauthnTypes;

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
        webauthn = map['webauthn'],
        webauthnDevices = ((map['webauthnDevices'] ?? map['webauthn_devices'])
                as List<dynamic>?)
            ?.map((item) =>
                kIsWeb ? Passkey.fromJson(item) : Passkey.fromMap(item))
            .toList(),
        webauthnTypes =
            List<String>.from(map['webauthnTypes'] ?? map['webauthn_types']);

  factory PassageUser.fromJson(jsonString) {
    return fromJson(jsonString, PassageUser.fromMap);
  }
}
