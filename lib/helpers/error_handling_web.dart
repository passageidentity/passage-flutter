import 'dart:js';

class PassageErrorCode {
  // Note: These strings are used for web. Mobile implements these in native code.
  static const PASSKEYS_NOT_SUPPORTED = 'PASSKEYS_NOT_SUPPORTED';
  static const INVALID_ARGUMENT = 'INVALID_ARGUMENT';
  static const PASSKEY_ERROR = 'PASSKEY_ERROR';
  static const USER_CANCELLED = 'USER_CANCELLED';
  static const USER_UNAUTHORIZED = 'USER_UNAUTHORIZED';
  static const OTP_ERROR = 'OTP_ERROR';
  static const MAGIC_LINK_ERROR = 'MAGIC_LINK_ERROR';
  static const TOKEN_ERROR = 'TOKEN_ERROR';
  static const APP_INFO_ERROR = 'APP_INFO_ERROR';
  static const CHANGE_EMAIL_ERROR = 'CHANGE_EMAIL_ERROR';
  static const CHANGE_PHONE_ERROR = 'CHANGE_PHONE_ERROR';
  static const UNKNOWN = 'UNKNOWN';
}

String getErrorCode(dynamic error) {
  String? code;
  if (error is JsObject) {
    code = error["code"]?.toString();
  }
  return code ?? PassageErrorCode.UNKNOWN;
}

String getErrorMessage(dynamic error) {
  String? message;
  if (error is JsObject) {
    message = error["message"]?.toString() ?? error.toString();
  }
  return message ?? error.toString();
}
