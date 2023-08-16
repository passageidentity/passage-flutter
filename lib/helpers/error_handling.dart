import 'package:flutter/services.dart';

String getErrorCode(dynamic error) {
  if (error is PlatformException) {
    return error.code;
  }
  return 'UNKNOWN';
}

@override
String getErrorMessage(dynamic error) {
  if (error is PlatformException && error.message != null) {
    return error.message!;
  }
  return error.toString();
}
