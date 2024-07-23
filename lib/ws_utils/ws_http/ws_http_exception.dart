class WSHttpResponseNot200Exception implements Exception {
  String cause;

  WSHttpResponseNot200Exception(this.cause);

  @override
  String toString() {
    return "HttpResponseNot200Exception: $cause";
  }
}

class WSHttpResponseCodeNotSuccess implements Exception {
  int code;
  String message;
  String? subMsg;

  WSHttpResponseCodeNotSuccess(this.code, this.message, {this.subMsg});

  @override
  String toString() {
    return "HttpResponseCodeNotSuccess: {message:$message,code:$code,subMsg:$subMsg}";
  }
}
