
import 'package:bloc_pattern/resources_helper/colors.dart';
import 'package:flutter/material.dart';

class ProgresBarIndicator extends Container {
  ProgresBarIndicator(Size? size, bool load, {Key? key}) : super(key: key,
      padding: const EdgeInsets.all(0.0),
      child: load ? Container(
        color: Colors.white.withOpacity(0.7),
        width: size!.width,
        height: size.height,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorsHelper.colorConstGrey),

          ),
        ),
      ) : Container());
}