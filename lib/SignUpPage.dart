import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter_yoga_workout_4_all_new/IntroModel.dart';
import 'package:flutter_yoga_workout_4_all_new/util/dialog_util.dart';

import 'package:get/get.dart';

import '../onlineData/ConstantUrl.dart';
import 'package:http/http.dart' as http;
import '../online_models/GuideIntroModel.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';

import 'HomeWidget.dart';
import 'IntroPage.dart';
import 'PrefData.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';
import 'generated/l10n.dart';
import 'models/checkregistermodel.dart';
import 'online_models/LoginModel.dart';
import 'online_models/RegisterModel.dart';
import 'package:country_state_city_picker/model/select_status_model.dart' as StatusModel ;

class SignUpPage extends StatefulWidget {


  late final Function function;

  SignUpPage();

  @override
  _SignUpPage createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  GuideIntroModel introModel = new GuideIntroModel();
  bool isRemember = false;
  int themeMode = 0;
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();


  Future<bool> _requestPop() async {
    if (await PrefData.getFirstSignUp() == true) {
      if (await PrefData.getIsSetting() == true) {
        Get.back();
      } else {
        Get.back();
      }
    } else {
      ConstantUrl.sendLoginPage(context, function: () {}, argument: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeWidget()));
      });
      Navigator.pop(context);
    }
    PrefData.setIsSetting(false);
    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
        child: WillPopScope(
            child: Scaffold(
              backgroundColor: bgDarkWhite,
              appBar: getColorStatusBar(bgDarkWhite),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      ConstantWidget.getLoginAppBar(context,
                          function: _requestPop),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(
                            context, 2.5),
                      ),
                      ConstantWidget.getTextWidget(
                          "Sign Up",
                          textColor,
                          TextAlign.center,
                          FontWeight.bold,
                          ConstantWidget.getScreenPercentSize(context, 3)),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(
                            context, 1.4),
                      ),

                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 2),
                      ),
                      ConstantWidget.getDefaultTextFiledWidgetWithBigPadding(context,
                          S.of(context).firstName, firstNameController),
                      ConstantWidget.getDefaultTextFiledWidgetWithBigPadding(
                          context, 'Email', emailController),
                      ConstantWidget.getPasswordTextFiled(context,
                          S.of(context).password, textPasswordController, isHorizontal : true),
                      getDefaultPhoneNumberWidget(context, isHorizontal : true),

                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 3),
                      ),

                      ConstantWidget.getIconButtonWidget(
                          context, S.of(context).signUpNow, borderColor: greenButton, fillColor : greenButton, fontColor : Colors.white, isHorizontal : true , () {
                        checkValidation();
                      }),

                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onWillPop: _requestPop),
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        });
  }



  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      child: CountryPickerDialog(
        titlePadding: EdgeInsets.all(8.0),
        searchCursorColor: Colors.pinkAccent,
        searchInputDecoration: InputDecoration(hintText: 'Search...'),
        isSearchable: true,
        title: Text(' Please select your country'),
        onValuePicked: (Country country) =>
            setState(() => _selectedDialogCountry = country),
        itemBuilder: _buildDialogItem,
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('US'),
          CountryPickerUtils.getCountryByIsoCode('GB'),
        ],
      ),
    ),
  );

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8),
      Flexible(child: Text(country.name))
    ],
  );



  Country _selectedDialogCountry =
  CountryPickerUtils.getCountryByName('United States');


  Widget getDefaultPhoneNumberWidget(BuildContext context, {isHorizontal}) {
    double height = ConstantWidget.getDefaultButtonSize(context);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 27);
    FocusNode myFocusNode = FocusNode();

    Color color = borderColor;

    return StatefulBuilder(
      builder: (context, setState) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                myFocusNode.canRequestFocus = true;
                color = accentColor;
              });
            } else {
              setState(() {
                myFocusNode.canRequestFocus = false;
                color = borderColor;
              });
            }

            print("refresh===true====${myFocusNode.canRequestFocus}");
          },
          focusNode: myFocusNode,
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(
                vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
              horizontal: isHorizontal == null? 0 :  ConstantWidget.getScreenPercentSize(context, 2)
            ),
            alignment: Alignment.centerLeft,
            decoration:
                getDefaultDecoration(radius: radius, borderColor: color),
            child: Row(
              children: [
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 4.5),
                ),
                Text("Country"),
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 4.5),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: (){
                        _openCountryPickerDialog();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(radius),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CountryPickerUtils.getDefaultFlagImage(_selectedDialogCountry),
                            SizedBox(width: 20),
                            Text("${_selectedDialogCountry.name}"),
                            // SizedBox(width: 8),
                            // Flexible(child: Text(_selectedDialogCountry.name))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    size: ConstantWidget.getScreenPercentSize(context, 3),
                    color: textColor),
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkValidation() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (ConstantUrl.isNotEmpty(firstNameController.text) &&
        ConstantUrl.isNotEmpty(textPasswordController.text)) {
      if ((textPasswordController.text.length >= 6)) {
        sendSignInPage();
      } else {
        ConstantUrl.showToast(S.of(context).passwordError, context);
      }
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }



  Future<void> checkRegister() async {
    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    Map data = {
      ConstantUrl.paramUserName: firstNameController.text.trim(),
      ConstantUrl.paramEmail : emailController.text.trim(),
    };

    final response = await http
        .post(Uri.parse(ConstantUrl.checkAlreadyRegisterUrl), body: data);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      print("response-12-----${response.body}");
      CheckRegisterModel user = CheckRegisterModel.fromJson(map);
      dialogUtil.dismissLoadingDialog();
      if (user.data!.success == 0) {
        GuideIntroModel introModel = new GuideIntroModel();
        introModel.username = firstNameController.text.trim();
        introModel.email = emailController.text.trim();
        introModel.password = textPasswordController.text;
        introModel.country = _selectedDialogCountry.name;
        introModel.loginType="0";
        Navigator.push(context, MaterialPageRoute(builder: (c) {
          return IntroPage(introModel, (){
            Navigator.pop(context);
          });
        },));

      } else {
        if (user.data!.login != null) {
          ConstantUrl.showToast(user.data!.login!.error!, context);
        }
      }
      print("res--1" + user.toString());
    }else{
      dialogUtil.dismissLoadingDialog();
      ConstantUrl.showToast("Something went wrong", context);
    }
  }

  void sendSignInPage() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      checkRegister();
      // signUp();
    } else {
      getNoInternet(context);
    }
  }

}
