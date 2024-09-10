import '../models/user_status.dart';
import '../models/web_authn_type.dart';
import '/helpers/data_conversion.dart'
    if (dart.library.js) '/helpers/data_conversion_web.dart';
import 'passage_flutter_model.dart';

class PublicUserInfo implements PassageFlutterModel {
  final String email;
  final bool emailVerified;
  final String id;
  final String? phone;
  final bool phoneVerified;
  final UserStatus status;
  final dynamic userMetadata;
  final bool webauthn;
  final List<WebAuthnType>? webauthnTypes;

  PublicUserInfo.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        emailVerified = map['emailVerified'],
        id = map['id'],
        phone = map['phone'],
        phoneVerified = map['phoneVerified'],
        status = UserStatus.values.firstWhere(
            (e) => e.value == (map['status'] ?? ''),
            orElse: () => UserStatus.statusUnavailable),
        userMetadata = map['userMetadata'],
        webauthn = map['webauthn'],
        webauthnTypes = (map['webauthnTypes']) != null
            ? List<WebAuthnType>.from((map['webauthnTypes'])
                .map((type) => WebAuthnType.values.firstWhere(
                    (e) => e.value == type,
                    orElse: () => WebAuthnType.passkey)))
            : null;

  factory PublicUserInfo.fromJson(jsonString) {
    return fromJson(jsonString, PublicUserInfo.fromMap);
  }
}
