import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:bloc_pattern/models/image_model.dart';
import 'package:bloc_pattern/models/sign_up_models.dart';
import 'package:flutter/material.dart';
import 'api_constants.dart';
import 'package:http/http.dart' as http;
import 'http_helper.dart';

class ApiHelper {
  static final ApiHelper _getInstance = ApiHelper._internal();

  ApiHelper._internal();

  factory ApiHelper() {
    return _getInstance;
  }

  final HttpHelper _httpHelper = HttpHelper();

  Future<SignUpModel> createNewUser(String reqBody) async {
    var result = await _httpHelper.post(
        url: ApiConstants.API_POST_SIGN_UP, body: reqBody, authToken: "");
    return SignUpModel.fromJson(result!);
  }

  Future<ImageModel> uploadImage(File imageFile) async {

    final result  = await _httpHelper.uploadImage(imageFile);
    if(result == null){
      return Future.error("Failed to upload image on server");
    }

    return ImageModel.fromJson(result);
  }
}
