import '../helpers/error_handling.dart'
    if (dart.library.js) '/helpers/error_handling_web.dart';

class PassageError implements Exception {
  final String message;
  final String code;

  PassageError({required this.code, this.message = ''});

  @override
  String toString() {
    return "PassageError(code: $code, message: $message)";
  }

  factory PassageError.fromObject(
      {required Object object, String? overrideCode}) {
    final code = overrideCode ?? getErrorCode(object);
    print('code: $code');
    final message = getErrorMessage(object);
    print('message: $message');
    return PassageError(code: code, message: message);
  }
}
