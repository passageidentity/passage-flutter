import 'passage_flutter_model.dart';
import '../helpers/data_conversion.dart';

class PassageAppInfo implements PassageFlutterModel {
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
  // TODO: Fix error from Passage JS mapping for user meta data schema
  // final List<PassageAppUserMetadataSchema>? userMetadataSchema;

  PassageAppInfo.fromMap(Map<String, dynamic> map)
      : allowedIdentifier =
            map['allowedIdentifier'] ?? map['allowed_identifier'],
        authFallbackMethod =
            map['authFallbackMethod'] ?? map['auth_fallback_method'],
        authOrigin = map['authOrigin'] ?? map['auth_origin'],
        id = map['id'],
        name = map['name'],
        publicSignup = map['publicSignup'] ?? map['public_signup'],
        redirectUrl = map['redirectUrl'] ?? map['redirect_url'],
        requiredIdentifier =
            map['requiredIdentifier'] ?? map['required_identifier'],
        requireIdentifierVerification = map['requireIdentifierVerification'] ??
            map['require_identifier_verification'],
        sessionTimeoutLength = map['sessionTimeoutLength'] ??
            map['session_timeout_length'] /*,
        userMetadataSchema = (map['userMetadataSchema'] ??
                map['user_metadata_schema'] as List<dynamic>?)
            ?.map((item) => PassageAppUserMetadataSchema.fromMap(
                item as Map<String, dynamic>))
            .toList()*/
  ;

  factory PassageAppInfo.fromJson(String jsonString) {
    return fromJson(jsonString, PassageAppInfo.fromMap);
  }

  factory PassageAppInfo.fromJSObject(jsObject) {
    return fromJSObject(jsObject, PassageAppInfo.fromMap);
  }
}

class PassageAppUserMetadataSchema {
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
}
