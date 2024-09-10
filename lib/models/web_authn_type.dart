enum WebAuthnType {
  passkey('passkey'),
  securityKey('security_key'),
  platform('platform');

  final String value;

  const WebAuthnType(this.value);
}
