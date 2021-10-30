import 'package:bloc_pattern/blocs/user_blocs.dart';
import 'package:bloc_pattern/extensions/extension.dart';
import 'package:bloc_pattern/helpers/common_helpers.dart';
import 'package:bloc_pattern/helpers/constants.dart';
import 'package:bloc_pattern/helpers/pref_helper.dart';
import 'package:bloc_pattern/helpers/progress_indicators.dart';
import 'package:bloc_pattern/models/sign_up_models.dart';
import 'package:bloc_pattern/resources_helper/dimens.dart';
import 'package:bloc_pattern/resources_helper/strings.dart';
import 'package:bloc_pattern/ui/image_upload.dart';
import 'package:bloc_pattern/widget/btn_widget.dart';
import 'package:bloc_pattern/widget/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late CommonHelper _commonHelper;

  late UserBloc _usersBloc;

  final _nameController = TextEditingController(),
      _typeController = TextEditingController(),
      _emailController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  late String deviceID;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _usersBloc = UserBloc();

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => getDeviceInformation());
  }

  getDeviceInformation() {
    _commonHelper.getDeviceDetails().then((value) {
      setState(() {
        deviceID = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _commonHelper = CommonHelper(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      body: Stack(
        children: [
          SizedBox(
            height: _commonHelper.screenHeight,
            width: _commonHelper.screenWidth,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Constants.FONT_CHOOSE_LANGUAGE),
                  ),
                  StreamBuilder(
                    stream: _usersBloc.nameStream,
                    builder: (projectName, snapshot) =>
                        TextFieldWidget(
                          screenWidth: _commonHelper.screenWidth,
                          hintText: StringHelper.name,
                          focusNode: _nameFocusNode,
                          errorText: snapshot.error,
                          onChangedValue: _usersBloc.nameChanged,
                          marginTop: DimensHelper.sideMargins,
                          inputFormatter: [
                            LengthLimitingTextInputFormatter(30)
                          ],
                          keyboardType: TextInputType.text,
                          secondFocus: _emailFocusNode,
                          autoFocus: false,
                          editingController: _nameController,
                          inputAction: TextInputAction.next,
                        ),
                  ),
                  StreamBuilder(
                    stream: _usersBloc.emailStream,
                    builder: (email, snapshot) =>
                        TextFieldWidget(
                          autoFocus: false,
                          focusNode: _emailFocusNode,
                          errorText: snapshot.error,
                          hintText: StringHelper.email,
                          inputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          editingController: _emailController,
                          marginTop: DimensHelper.sideMargins,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
                            LengthLimitingTextInputFormatter(50)
                          ],
                          onChangedValue: _usersBloc.emailChanged,
                          screenWidth: _commonHelper.screenWidth,
                        ),
                  ),
                  StreamBuilder(
                    stream: _usersBloc.zipCodeStream,
                    builder: (zipcode, snapshot) =>
                        TextFieldWidget(
                            secondFocus: _emailFocusNode,
                            autoFocus: false,
                            focusNode: _typeFocusNode,
                            errorText: snapshot.error,
                            hintText: StringHelper.zipCode,
                            inputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            editingController: _typeController,
                            marginTop: DimensHelper.sideMargins,
                            inputFormatter: [
                              LengthLimitingTextInputFormatter(5)
                            ],
                            onChangedValue: _usersBloc.zipCodeChanged,
                            screenWidth: _commonHelper.screenWidth),
                  ),
                  StreamBuilder(
                    stream: _usersBloc.submitCheck,
                    builder: (submit, snapshot) =>
                        ButtonWidget(
                          width: _commonHelper.screenWidth,
                          height: _commonHelper.screenHeight,
                          btnTxt: StringHelper.submit,
                          onPressed: () {
                            if (snapshot.hasData) _onSubmitBtnTap();
                          },
                        ),
                  )
                ],
              ),
            ),
          ),
          _signUpObserver(),
          StreamBuilder<bool>(
            stream: _usersBloc.progressStream as Stream<bool>,
            builder: (context, snapshot) {
              return ProgresBarIndicator(
                  _commonHelper.screenSize, snapshot.getVisibility!);
            },
          )
        ],
      ),
    ).setBackgroundImage;
  }

  void _onSubmitBtnTap() {
    _commonHelper.hideKeyBoard(context);
    _usersBloc.signUp(deviceID, _scaffoldKey, context);
  }

  @override
  void dispose() {
    super.dispose();
    _usersBloc.dispose();
  }

  Widget _signUpObserver() {
    return StreamBuilder<SignUpModel>(
      stream: _usersBloc.signUpStream as Stream<SignUpModel>,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future.delayed(const Duration(milliseconds: Constants.futureDelayed), () {
            PrefHelper.putBoolean(Constants.PREF_SIGN_UP_COMPLETE, true);
            _commonHelper.startActivityWithReplacement(const UploadImage());
          });
        }
        return Container();
      },
    );
  }
}
