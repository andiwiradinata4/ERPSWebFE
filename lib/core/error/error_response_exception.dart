import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';
import 'package:erps/core/models/response.dart';

class ErrorResponseException implements Exception {
  final int _statusCode;
  final String _message;
  final Map<String, List<String>> _errors;

  ErrorResponseException(this._statusCode, this._message, this._errors);

  int get statusCode => _statusCode;

  String get message => _message;

  Map<String, List<String>> get errors => _errors;

  @override
  String toString() {
    return 'ErrorResponseException{_statusCode: $_statusCode, _message: $_message, _errors: $_errors}';
  }

  static ErrorResponseException fromHttpResponse(Response response) {
    Map<String, dynamic> errors = jsonDecode(response.body);
    late Map<String, List<String>> errorMsg;
    if (errors.containsKey("errors")) {
      errorMsg = {};
      String allMessages = '';
      final tempErrors = errors["errors"];
      for (String key in tempErrors.keys) {
        final errorValues = tempErrors[key];
        if (errorValues is JSArray)
          {
            final toDartValues = errorValues.toDart;
            final jsArray = errorValues.toString();
            log(jsArray);

            errorMsg[key] = toDartValues.map((e) => e.toString()).toList();
            allMessages += toDartValues.map((e) => e.toString()).toList().join(",");
          }
        errors.addAll({'error': allMessages});
      }

    } else if (errors.containsKey('detail')) {
      errorMsg = {};
      errors.addAll({'error': errors["detail"]});
      errorMsg = {'detail': [errors["detail"]]};
    } else if (errors.containsKey('Message')) {
      errorMsg = {};
      errors.addAll({'error': errors["Message"]});
      errorMsg = {'detail': [errors["Message"]]};
    }  else {
      errorMsg = {};
      String msg = '';
      for (String key in errors.keys) {
        dynamic errorValue = errors[key];
        if (errorValue is List) {
          msg = errorValue.map((e) => e).toList().join(', ');
        }
        errorMsg[key] = List<String>.from(errors[key]);
      }
      errors.addAll({'error': msg});
    }
    return ErrorResponseException(
        response.statusCode, errors["error"], errorMsg);
  }
}
