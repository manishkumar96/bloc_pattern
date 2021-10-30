import 'package:bloc_pattern/helpers/constants.dart';
import 'package:bloc_pattern/resources_helper/colors.dart';
import 'package:bloc_pattern/resources_helper/dimens.dart';
import 'package:bloc_pattern/resources_helper/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  late final bool autoFocus, hideText, editingEnable;
  late final FocusNode? focusNode, secondFocus;
  late  var errorText, hintText;
  late final TextInputAction inputAction;
  late final TextInputType keyboardType;
  late final TextEditingController editingController;
  late final double marginTop, tfHeight, letterSpace;
  late final int maxLines, minLines;
  late final List<TextInputFormatter> inputFormatter;
  late final TextAlign alignment;
  late final ValueChanged<String> onChangedValue;
  late final double screenWidth;
  late final GestureTapCallback? onPressed;

  TextFieldWidget(
      {Key? key, required this.autoFocus,
      this.hideText = false,
      this.editingEnable = false,
      required this.focusNode,
      this.secondFocus,
      required this.errorText,
      required this.hintText,
      required this.inputAction,
      required this.keyboardType,
      required this.editingController,
      required this.marginTop,
      this.tfHeight = 50,
      this.letterSpace = 0.0,
      this.maxLines = 1,
      this.minLines = 1,
      required this.inputFormatter,
      this.alignment = TextAlign.start,
      required this.onChangedValue,
      required this.screenWidth,
      this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      padding: const EdgeInsets.only(
          left: DimensHelper.sideMargins, right: DimensHelper.sideMargins),
      alignment: Alignment.center,
      child: TextFormField(
        onFieldSubmitted: (val) {
          _fieldFocusChanged(context, focusNode!, secondFocus!);
        },
        style: TextStyle(
          fontSize: Constants.FONT_TOP,
          color: ColorsHelper.colorWhite,
          fontFamily: StringHelper.helveticaFontFamily,
          letterSpacing: letterSpace,
        ),
        keyboardType: keyboardType,
        textInputAction: inputAction,
        autofocus: autoFocus,
        onTap: onPressed,
        controller: editingController,
        enabled: !editingEnable,
        focusNode: focusNode,
        autocorrect: false,
        maxLines: maxLines,
        minLines: minLines,
        textCapitalization: TextCapitalization.words,
        obscureText: hideText,
        readOnly: editingEnable,
        textAlign: alignment,
        onChanged: onChangedValue,
        inputFormatters: inputFormatter,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
              fontFamily: StringHelper.helveticaFontFamily,
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: DimensHelper.sideMargins,
                horizontal: DimensHelper.sideMargins),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimensHelper.halfSides)),
                borderSide:
                    BorderSide(color: ColorsHelper.colorGrey, width: 1.0)),
            disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimensHelper.halfSides)),
                borderSide:
                    BorderSide(color: ColorsHelper.colorGrey, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimensHelper.halfSides)),
                borderSide:
                    BorderSide(color: ColorsHelper.colorGrey, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimensHelper.halfSides)),
                borderSide:
                    BorderSide(color: ColorsHelper.colorWhite, width: 0.5)),
            errorText: errorText),
      ),
    );
  }

  void _fieldFocusChanged(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();

    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
      return;
    }
  }
}
