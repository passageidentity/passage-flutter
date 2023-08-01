import 'dart:convert';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';

@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);

// class AllowedFallbackAuth {
//   static const String LoginCode = 'otp';
//   static const String MagicLink = 'magic_link';
//   static const String None = 'none';
// }

// class Identifier {
//   static const String Email = 'email';
//   static const String Phone = 'phone';
//   static const String Both = 'both';
// }

// class RequiredIdentifier {
//   static const String Phone = 'phone';
//   static const String Email = 'email';
//   static const String Both = 'both';
//   static const String Either = 'either';
// }

class PassageAppInfo {
  final String allowedIdentifier;
  final String authFallbackMethod;
  final String authOrigin;
  final String id;
  final String name;
  final bool publicSignup;
  final String redirectUrl;
  final String requiredIdentifier;
  final bool requireIdentifierVerification;
  final int sessionTimeoutLength;
  final List<PassageAppUserMetadataSchema>? userMetadataSchema;

  // PassageAppInfo({
  //   required this.allowedIdentifier,
  //   required this.authFallbackMethod,
  //   required this.authOrigin,
  //   required this.id,
  //   required this.name,
  //   required this.publicSignup,
  //   required this.redirectUrl,
  //   required this.requiredIdentifier,
  //   required this.requireIdentifierVerification,
  //   required this.sessionTimeoutLength,
  //   this.userMetadataSchema,
  // });

  PassageAppInfo.fromMap(Map<String, dynamic> map)
      : allowedIdentifier = map['allowedIdentifier'],
        authFallbackMethod = map['authFallbackMethod'],
        authOrigin = map['authOrigin'],
        id = map['id'],
        name = map['name'],
        publicSignup = map['publicSignup'],
        redirectUrl = map['redirectUrl'],
        requiredIdentifier = map['requiredIdentifier'],
        requireIdentifierVerification = map['requireIdentifierVerification'],
        sessionTimeoutLength = map['sessionTimeoutLength'],
        userMetadataSchema = (map['userMetadataSchema'] as List<dynamic>?)
            ?.map((item) => PassageAppUserMetadataSchema.fromMap(
                item as Map<String, dynamic>))
            .toList();

  factory PassageAppInfo.fromJson(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return PassageAppInfo.fromMap(map);
  }

  factory PassageAppInfo.fromJSObject(jsObject) {
    final Map<String, dynamic> resultMap = Map.fromIterable(
      _getKeysOfObject(jsObject),
      value: (key) => js_util.getProperty(jsObject, key),
    );
    return PassageAppInfo.fromMap(resultMap);
  }
}

class PassageAppUserMetadataSchema {
  final String fieldName;
  final String friendlyName;
  final String id;
  final bool profile;
  final bool registration;
  final String type;

  PassageAppUserMetadataSchema({
    required this.fieldName,
    required this.friendlyName,
    required this.id,
    required this.profile,
    required this.registration,
    required this.type,
  });

  PassageAppUserMetadataSchema.fromMap(Map<String, dynamic> map)
      : fieldName = map['fieldName'],
        friendlyName = map['friendlyName'],
        id = map['id'],
        profile = map['profile'],
        registration = map['registration'],
        type = map['type'];
}
