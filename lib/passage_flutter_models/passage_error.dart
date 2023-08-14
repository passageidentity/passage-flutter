import 'package:flutter/services.dart';

class PassageError implements Exception {
  final String message;
  final String code;

  PassageError({required this.code, this.message = ''});

  @override
  String toString() {
    return "PassageError(code: $code, message: $message)";
  }

  factory PassageError.fromObject(Object e) {
    String code;
    String? message;
    if (e is PlatformException) {
      code = e.code;
      message = e.message;
    } else {
      code = 'UNKNOWN_ERROR';
    }
    return PassageError(code: code, message: message ?? e.toString());
  }
}
