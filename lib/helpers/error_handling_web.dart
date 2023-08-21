import 'dart:js';

import '/passage_flutter_models/passage_error_code.dart';

String getErrorCode(dynamic error) {
  String? code;
  if (error is JsObject) {
    code = error["code"]?.toString();
  }
  return code ?? PassageErrorCode.unknkown;
}

String getErrorMessage(dynamic error) {
  String? message;
  if (error is JsObject) {
    message = error["message"]?.toString() ?? error.toString();
  }
  return message ?? error.toString();
}
