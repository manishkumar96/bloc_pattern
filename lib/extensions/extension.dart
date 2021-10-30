import 'package:bloc_pattern/resources_helper/dimens.dart';
import 'package:bloc_pattern/resources_helper/icon_path.dart';
import 'package:flutter/cupertino.dart';

extension BackgroundImage on Widget {
  Container get topButtonMargin {
    return Container(
      margin: const EdgeInsets.only(
          left: DimensHelper.sideMargins, top: DimensHelper.sideMargins),
      child: this,
    );
  }

  Container get setBackgroundImage {
    return Container(
        child: this,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(IconPaths.bgGreen), fit: BoxFit.fill)));
  }
}

extension GetProgressVisibilty on AsyncSnapshot<bool> {
  bool? get getVisibility {
    if (hasData) {
      return data;
    } else {
      return false;
    }
  }
}
