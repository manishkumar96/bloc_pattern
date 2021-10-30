import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/helpers/api_helper.dart';
import 'package:bloc_pattern/helpers/snackbar_helper.dart';
import 'package:bloc_pattern/models/error_response_model.dart';
import 'package:bloc_pattern/models/image_model.dart';
import 'package:bloc_pattern/models/sign_up_models.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

class UserBloc extends Object with SignUpValidators implements Bloc {
  final _apiHelper = ApiHelper();

  final BehaviorSubject<bool> _progressController = BehaviorSubject<bool>();

  StreamSink get progressSink => _progressController.sink;

  Stream get progressStream => _progressController.stream;

  final _nameController = BehaviorSubject<String>();

  Function(String) get nameChanged => _nameController.sink.add;

  Stream<String> get nameStream =>
      _nameController.stream.transform(_nameValidator);

  final _emailController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;

  Stream<String> get emailStream =>
      _emailController.stream.transform(_emailValidator);

  final _zipCodeController = BehaviorSubject<String>();

  Function(String) get zipCodeChanged => _zipCodeController.sink.add;

  Stream<String> get zipCodeStream =>
      _zipCodeController.stream.transform(_zipCodeValidator);

  Stream<bool> get submitCheck => Rx.combineLatest3(
      nameStream, emailStream, zipCodeStream, (name, email, zipcode) => true);

  final BehaviorSubject _signUpController = BehaviorSubject<SignUpModel>();

  StreamSink get signUpSink => _signUpController.sink;

  Stream get signUpStream => _signUpController.stream;

  Future<dynamic> signUp(String deviceId, GlobalKey<ScaffoldState> _scaffoldKey,
      BuildContext bcontext) async {
    progressSink.add(true);
    try {
      var response =
          await _apiHelper.createNewUser(_addRegisterDeviceData(deviceId));
      signUpSink.add(response);
      progressSink.add(false);
    } on Exception catch (exception) {
      progressSink.add(false);
      var response = json.decode(exception.toString()) as Map<String, dynamic>;
      var errorMessage = ErrorResponse.fromJson(response);
      signUpSink.addError(errorMessage.message!);
      SnackBarHelper(context: bcontext, message: errorMessage.message);
    }
  }

  @override
  void dispose() {
    _progressController.close();
    _nameController.close();
    _zipCodeController.close();
    _nameController.close();
    _emailController.close();
    _signUpController.close();
  }

  String _addRegisterDeviceData(String deviceId) {
    var jorequest = json.encode({
      "name": _nameController.value.toString(),
      "email": _emailController.value.toString(),
      "zipcode": _zipCodeController.value.toString(),
      "deviceId": deviceId,
    });
    return jorequest;
  }
}

mixin SignUpValidators {
  final _emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Please enter a valid email');
    }
  });

  final _nameValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.toString().length >= 2) {
      sink.add(name);
    } else if (name.toString().length <= 2) {
      sink.addError('Full name must be atleast 2 character long');
    } else {
      sink.addError('Please enter valid name');
    }
  });

  final _zipCodeValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (type, sink) {
    if (type.toString().trim().isNotEmpty) {
      sink.add(type);
    } else if (type.toString().trim().length < 5) {
      sink.addError('Zip code must be atleast 5 character long');
    } else {
      sink.addError('zip code must not be empty');
    }
  });
}
