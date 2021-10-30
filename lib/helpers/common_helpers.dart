import 'dart:io';

import 'package:bloc_pattern/helpers/pref_helper.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

class CommonHelper {
  MediaQueryData? mediaQuery;
  var context, orientation, screenWidth, screenHeight;
  Size? screenSize;

  CommonHelper(this.context) {
    init();
  }

  void init() {
    mediaQuery = MediaQuery.of(context);
    orientation = mediaQuery!.orientation;
    screenSize = mediaQuery!.size;
    screenHeight = screenSize!.height;
    screenWidth = screenSize!.width;
  }

  startActivityWithReplacement(child) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => child));
  }

  void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<String> getDeviceDetails() async {
    late String identifier;

    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        identifier = build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;

        identifier = data.identifierForVendor;
      }
    } on PlatformException {
      Constants.printValue('Failed to get platform version');
    }

    return identifier;
  }

}
