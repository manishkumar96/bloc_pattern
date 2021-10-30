
import 'dart:io';

import 'package:bloc_pattern/blocs/user_blocs.dart';
import 'package:bloc_pattern/helpers/api_helper.dart';
import 'package:bloc_pattern/helpers/common_helpers.dart';
import 'package:bloc_pattern/helpers/constants.dart';
import 'package:bloc_pattern/models/image_model.dart';
import 'package:bloc_pattern/resources_helper/colors.dart';
import 'package:bloc_pattern/widget/image_component.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  late CommonHelper _commonHelper;
  late UserBloc _userBloc;
  late String deviceID;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? image;
  late ApiHelper _apiHelper;

  String? imageUrlStr;


  @override
  void initState() {
    super.initState();
    _userBloc =UserBloc();
    _apiHelper=ApiHelper();

  }

  @override
  Widget build(BuildContext context) {
    _commonHelper = CommonHelper(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        height: _commonHelper.screenHeight,
        width: _commonHelper.screenWidth,
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () {

                  _showBottomSheet();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imageUrlStr == null
                            ? const AssetImage("assets/images/bg_choose_language.png")
                            : NetworkImage(imageUrlStr!) as ImageProvider,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userBloc.dispose();
  }


  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: Constants.imageContainer,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorsHelper.colorWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Constants.borderRadius),
                    topRight: Radius.circular(Constants.borderRadius),
                  )),
              child: Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          imageGallery();
                        },
                        child: ImageComponent(
                          imageHeight: 100,
                          imageWidth: 100,
                          image: "assets/images/gallery.png",
                        ),
                      ),
                      const Text(
                        Constants.gallery,
                        style: TextStyle(
                          fontSize: Constants.fontSize,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showCamera();
                        },
                        child: ImageComponent(
                          imageHeight: 100,
                          imageWidth: 100,
                          image: "assets/images/camera.png",
                        ),
                      ),
                      const Text(
                        Constants.camera,
                        style: TextStyle(fontSize: Constants.fontSize),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> showCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 150, maxHeight: 150);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });

      imageData(image);


      Navigator.pop(context);
    }
  }

  void imageGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 150, maxHeight: 150);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      imageData(image);
      Navigator.pop(context);
    }
  }

  void imageData(File? image) {
    _apiHelper.uploadImage(image!).then((onSuccess){
      ImageModel imageModel = onSuccess;
      setState(() {
        imageUrlStr = imageModel.data!.url ;
      });
    }).catchError((onError){
      print("imageData: ");
    });
  }
}
