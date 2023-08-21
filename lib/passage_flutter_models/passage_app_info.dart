import 'package:flutter/foundation.dart';

import 'passage_flutter_model.dart';
import '/helpers/data_conversion.dart'
    if (dart.library.js) '/helpers/data_conversion_web.dart';

class PassageAppInfo implements PassageFlutterModel {
  final String allowedIdentifier;
  final PassageAuthFallbackMethod authFallbackMethod;
  final String authOrigin;
  final String id;
  final String name;
  final bool publicSignup;
  final String redirectUrl;
  final String requiredIdentifier;
  final bool requireIdentifierVerification;
  final int sessionTimeoutLength;
  final List<PassageAppUserMetadataSchema>? userMetadataSchema;

  PassageAppInfo.fromMap(Map<String, dynamic> map)
      : allowedIdentifier =
            map['allowedIdentifier'] ?? map['allowed_identifier'],
        authFallbackMethod = getAuthFallbackMethod(map),
        authOrigin = map['authOrigin'] ?? map['auth_origin'],
        id = map['id'],
        name = map['name'],
        publicSignup = map['publicSignup'] ?? map['public_signup'],
        redirectUrl = map['redirectUrl'] ?? map['redirect_url'],
        requiredIdentifier =
            map['requiredIdentifier'] ?? map['required_identifier'],
        requireIdentifierVerification = map['requireIdentifierVerification'] ??
            map['require_identifier_verification'],
        sessionTimeoutLength =
            map['sessionTimeoutLength'] ?? map['session_timeout_length'],
        userMetadataSchema = getMetadataSchema(map['userMetadataSchema'] ??
            map['user_metadata_schema'] as List<dynamic>);

  factory PassageAppInfo.fromJson(jsonString) {
    return fromJson(jsonString, PassageAppInfo.fromMap);
  }

  static getMetadataSchema(List<dynamic> list) {
    if (list.isEmpty) {
      return List<PassageAppUserMetadataSchema>.empty();
    }
    return list
        .map((item) => kIsWeb
            ? PassageAppUserMetadataSchema.fromJson(item)
            : PassageAppUserMetadataSchema.fromMap(item))
        .toList();
  }

  static PassageAuthFallbackMethod getAuthFallbackMethod(
      Map<String, dynamic> map) {
    String? authFallbackMethod =
        map['authFallbackMethod'] ?? map['auth_fallback_method'];
    switch (authFallbackMethod) {
      case 'magicLink':
      case 'magic_link':
        return PassageAuthFallbackMethod.magicLink;
      case 'otp':
        return PassageAuthFallbackMethod.otp;
      default:
        return PassageAuthFallbackMethod.none;
    }
  }
}

class PassageAppUserMetadataSchema implements PassageFlutterModel {
  final String fieldName;
  final String friendlyName;
  final String id;
  final bool profile;
  final bool registration;
  final String type;

  PassageAppUserMetadataSchema.fromMap(Map<String, dynamic> map)
      : fieldName = map['fieldName'],
        friendlyName = map['friendlyName'],
        id = map['id'],
        profile = map['profile'],
        registration = map['registration'],
        type = map['type'];

  factory PassageAppUserMetadataSchema.fromJson(jsonString) {
    return fromJson(jsonString, PassageAppUserMetadataSchema.fromMap);
  }
}

enum PassageAuthFallbackMethod {
  otp,
  magicLink,
  none,
}
