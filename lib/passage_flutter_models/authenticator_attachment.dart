enum AuthenticatorAttachment {
  platform,
  crossPlatform,
  any,
}

// Extension on AuthenticatorAttachment to get string values
extension AuthenticatorAttachmentExtension on AuthenticatorAttachment {
  String get value {
    switch (this) {
      case AuthenticatorAttachment.platform:
        return 'platform';
      case AuthenticatorAttachment.crossPlatform:
        return 'cross-platform';
      case AuthenticatorAttachment.any:
        return 'any';
      default:
        return '';
    }
  }
}

// Class definition for PasskeyCreationOptions
class PasskeyCreationOptions {
  AuthenticatorAttachment? authenticatorAttachment;

  PasskeyCreationOptions({this.authenticatorAttachment});

  Map<String, dynamic> toJson() => {
        "authenticatorAttachment": authenticatorAttachment?.value,
      };
}
