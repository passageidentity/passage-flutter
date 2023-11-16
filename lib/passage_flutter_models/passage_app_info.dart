import 'package:flutter/foundation.dart';

import 'passage_flutter_model.dart';
import '/helpers/data_conversion.dart'
    if (dart.library.js) '/helpers/data_conversion_web.dart';

class PassageAppInfo implements PassageFlutterModel {
  final String allowedIdentifier;
  @Deprecated('Check the authMethods property for the full list of supported authentication methods and their configurations.')
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
  final AuthMethods authMethods;

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
            map['user_metadata_schema'] as List<dynamic>),
        authMethods = getAuthMethods(map['authMethods'] ??
            map['auth_methods']);

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

  static AuthMethods getAuthMethods(
      Map<String, dynamic> map) {
    return kIsWeb
        ? AuthMethods.fromJson(map)
        : AuthMethods.fromMap(map);
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

class AuthMethods implements PassageFlutterModel {
  final EmailAndSMSAuthMethod? magicLink;
  final EmailAndSMSAuthMethod? otp;
  final PasskeyAuthMethod? passkeys;

  AuthMethods.fromMap(Map<String, dynamic> map)
      : magicLink = getEmailAndSMSAuthMethod(map['magicLink'] ?? map['magic_link']),
        otp = getEmailAndSMSAuthMethod(map['otp']),
        passkeys = getPasskeyAuthMethod(map['passkeys']);

  factory AuthMethods.fromJson(jsonString) {
    return fromJson(jsonString, AuthMethods.fromMap);
  }

  static EmailAndSMSAuthMethod getEmailAndSMSAuthMethod(
      Map<String, dynamic> map) {
      return kIsWeb
            ? EmailAndSMSAuthMethod.fromJson(map)
            : EmailAndSMSAuthMethod.fromMap(map);
  }

  static PasskeyAuthMethod getPasskeyAuthMethod(
      Map<String, dynamic> map) {
      return kIsWeb
            ? PasskeyAuthMethod.fromJson(map)
            : PasskeyAuthMethod.fromMap(map);
  }

}

class EmailAndSMSAuthMethod implements PassageFlutterModel {
  final int ttl;
  final DisplayUnit ttlDisplayUnit;

  EmailAndSMSAuthMethod.fromMap(Map<String, dynamic> map)
      : ttl = map['ttl'],
        ttlDisplayUnit = getTtlDisplayUnit(map);

  factory EmailAndSMSAuthMethod.fromJson(jsonString) {
    return fromJson(jsonString, EmailAndSMSAuthMethod.fromMap);
  }

  static DisplayUnit getTtlDisplayUnit(
      Map<String, dynamic> map) {
    String? ttlDisplayUnit =
        map['ttlDisplayUnit'] ?? map['ttl_display_unit'];
    switch (ttlDisplayUnit) {
      case 's':
        return DisplayUnit.s;
      case 'm':
        return DisplayUnit.m;
      case 'h':
        return DisplayUnit.h;
      case 'd':
        return DisplayUnit.d;
      default:
        return DisplayUnit.s;
    }
  }
}

class PasskeyAuthMethod implements PassageFlutterModel {
  factory PasskeyAuthMethod.fromJson(jsonString){
    return fromJson(jsonString, PasskeyAuthMethod.fromMap);
  }
  PasskeyAuthMethod.fromMap(Map<String, dynamic> map);
}

enum DisplayUnit {
  s,
  m,
  h,
  d,
}
