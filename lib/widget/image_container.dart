


import 'dart:io';

import 'package:bloc_pattern/helpers/constants.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final Border border;
  final BoxShape shape;
  final AssetImage? image;
  final File? fileImage;
  final BoxFit fit;

  const ImageContainer(
      {Key? key,
      required this.border,
      required this.shape,
       this.image,
      required this.fit, this.fileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.imageContainer,
      width: Constants.imageContainer,
      decoration: BoxDecoration(
        border: border,
        shape: shape,
        image: DecorationImage(
          image: image as ImageProvider,
          fit: fit,
        ),
      ),
    );
  }
}
