import 'package:bloc_pattern/resources_helper/colors.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class SnackBarHelper extends Container {
  SnackBarHelper(
      { BuildContext? context,
      GlobalKey<ScaffoldState>? scaffoldKey,
      required String? message})
      : super(child: _displaySnackBar(context!, scaffoldKey, message));
}

_displaySnackBar(BuildContext context, final _scaffoldKey, String? _msg) {
  final snackBar = SnackBar(
    content: Text(_msg!,
        style: TextStyle(
          color: ColorsHelper.colorWhite,
          fontWeight: FontWeight.w400,
          fontSize: Constants.FONT_MEDIUM,
        )),
    backgroundColor: ColorsHelper.colorGreen,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  return snackBar;
}
