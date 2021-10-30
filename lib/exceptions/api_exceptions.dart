class ApiExceptions implements Exception {
  final _message;

  ApiExceptions([this._message]);

  String toString() {
    return _message;
  }
}

class BadRequestException extends ApiExceptions {
  BadRequestException([message]) : super(message);
}

class UnAuthorisedException extends ApiExceptions {
  UnAuthorisedException([message]) : super(message);
}

class InvalidInputException extends ApiExceptions {
  InvalidInputException([message]) : super(message);
}

class FetchDataException extends ApiExceptions{
  FetchDataException([message]):super(message);
}
