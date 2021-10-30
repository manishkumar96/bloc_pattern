import 'package:bloc_pattern/helpers/constants.dart';
import 'package:flutter/material.dart';

class ImageComponent extends StatelessWidget {

  final String image;
  final double imageHeight;
  final double imageWidth;

    ImageComponent(
      {required this.image,
      required this.imageHeight,
      required this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            right: Constants.borderRadius, left: Constants.five),
        child: Image.asset(
          image,
          height: imageHeight,
          width: imageWidth,
        ));
  }
}
