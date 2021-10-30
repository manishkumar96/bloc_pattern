import 'package:bloc_pattern/extensions/extension.dart';
import 'package:bloc_pattern/helpers/constants.dart';
import 'package:bloc_pattern/resources_helper/colors.dart';
import 'package:bloc_pattern/resources_helper/dimens.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String btnTxt;
  final double height;
  final double width;
  final GestureTapCallback onPressed;

    ButtonWidget(
      {required this.btnTxt,
      required this.height,
      required this.width,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: height * 0.1,
          left: DimensHelper.sideMargins,
          right: DimensHelper.sidesMarginDouble),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: ColorsHelper.colorWhite,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimensHelper.halfSides)),
        ),
        child: Container(
          height: Constants.BTN_SIZE,
          width: width,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Center(
            child: Text(
              btnTxt,
              style: const TextStyle(
                  fontSize: Constants.FONT_MAXIMUM,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ),
      ),
    ).topButtonMargin;
  }
}
