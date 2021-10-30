class SignUpModel {

  int? statusCode;

  String? message;

  Data? data;

  SignUpModel({required this.statusCode, required this.message, required this.data});

  SignUpModel.fromJson(Map<dynamic, dynamic> json) {

    statusCode = json['statusCode'];

    message = json['message'];

    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {

  Response? response;

  Data({this.response});

  Data.fromJson(Map<String, dynamic> json) {

    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }
}

class Response {

  String? userId, email, name, deviceId, creationDate;

  int? insertDate;

  Response({required this.userId, required this.email, required this.name, required this.deviceId,
    required this.insertDate, required this.creationDate});

  Response.fromJson(Map<String, dynamic> json) {

    userId = json['userId'];

    email = json['email'];

    name = json['name'];

    deviceId = json['deviceId'];

    insertDate = json['insertDate'];

    creationDate = json['creationDate'];
  }
}