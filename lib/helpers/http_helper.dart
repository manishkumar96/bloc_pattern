import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/exceptions/api_exceptions.dart';
import 'package:bloc_pattern/helpers/api_constants.dart';
import 'package:bloc_pattern/helpers/constants.dart';
import 'package:bloc_pattern/helpers/pref_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static final HttpHelper _getInstance = HttpHelper._internal();

  HttpHelper._internal();

  factory HttpHelper() {
    return _getInstance;
  }

  Future<dynamic> uploadImage(File imageFile) async {
    var dio = Dio();
    dio.options.baseUrl = ApiConstants.baseUrl1;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;

    var uploadUrl = "s3uploads/image-upload";
    Constants.printValue("API REQUEST :" + ApiConstants.baseUrl1 + uploadUrl);

    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: fileName)
    });

    var apiResponse = await dio.post(uploadUrl,
        data: formData,
        options: Options(method: 'POST', responseType: ResponseType.json));

    if (apiResponse.statusCode == 200) {
      print("apiResponse.data");
      return apiResponse.data;

    } else {

      print("error");

      /*CommonHelper.checkStatusCode(apiResponse.statusCode, StringHelper.error,
          'Failed to uplaod image on server');*/

      return null;
    }
  }

  Future<Map?> post(
      {required String url, String? body, String authToken = ''}) async {
    Constants.printValue('API URL: ' + url);
    Constants.printValue('API BODY: ' + body!);

    var apiHeaders;
    if (authToken.isNotEmpty) {
      apiHeaders = {
        "content-type": "application/json",
        "Authorization": authToken
      };
    } else {
      apiHeaders = {"content-type": "application/json"};
    }

    Constants.printValue('Api headers :' + apiHeaders.toString());

    var responseData;

    try {
      final apiResponse =
          await http.post(Uri.parse(url), body: body, headers: apiHeaders);

      Map<String, String> headers = apiResponse.headers;

      Constants.printValue("HEADERS: " + headers.toString());

      headers.forEach((String key, String authToken) {
        if (key == "authorization") {
          PrefHelper.putString(Constants.PREF_AUTH_TOKEN, authToken);
        }
      });

      Constants.printValue("STATUS CODE :" + apiResponse.statusCode.toString());
      Constants.printValue("MESSAGE: " + apiResponse.body.toString());
      responseData = _returnResponse(response: apiResponse);
    } on SocketException {
      return null;
    }
    return responseData;
  }

  _returnResponse({required http.Response response, bool? isUserData}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());

        break;

      case 401:
        throw UnAuthorisedException(response.body.toString());
        break;

      case 403:
        throw InvalidInputException(response.body.toString());
        break;

      case 404:
        throw BadRequestException(response.body.toString());
        break;

      case 500:
        throw UnAuthorisedException(response.body.toString());
        break;

      default:
        throw FetchDataException(
            'Error occured while communicating with server with status code : ${response.statusCode}');
    }
  }
}