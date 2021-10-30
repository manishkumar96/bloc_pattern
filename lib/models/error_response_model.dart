class ErrorResponse {
  int? status;
  String? message, data;

  ErrorResponse(
      {required this.status, required this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
