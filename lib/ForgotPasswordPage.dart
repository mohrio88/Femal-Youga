import 'dart:convert';



import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../onlineData/ConstantUrl.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'OTPPage.dart';

import 'ResetPasswordPage.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';

import 'package:http/http.dart' as http;

import 'generated/l10n.dart';
import 'online_models/ForgotPasswordModel.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() {
    return _ForgotPasswordPage();
  }
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  int themeMode = 0;
  TextEditingController emailController = new TextEditingController();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();

    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();
  }


  @override

  Widget build(BuildContext context) {
    SizeConfig().init(context);




    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          appBar: AppBar(
            backgroundColor: bgDarkWhite,
            elevation: 0,
            toolbarHeight: 0,
            title: Text(""),
          ),
          body: Container(
            child: Column(
              children: [
                ConstantWidget.getLoginAppBar(context, function: _requestPop),
                Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getWidthPercentSize(context, 3)),
                    children: [
                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 2.5),
                      ),
                      ConstantWidget.getTextWidget(
                          'Forgot Password',
                          textColor,
                          TextAlign.left,
                          FontWeight.bold,
                          ConstantWidget.getScreenPercentSize(context, 3)),
                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 1.4),
                      ),
                      ConstantWidget.getTextWidget(
                          "We need your email address for reset password!",
                          textColor,
                          TextAlign.left,
                          FontWeight.w400,
                          ConstantWidget.getScreenPercentSize(context, 2)),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 4),
                      ),
                      ConstantWidget.getDefaultTextFiledWidgetAutoFocus(
                          context, 'Email', emailController),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 2),
                      ),
                      ConstantWidget.getButtonWidget(
                          context, 'Submit', blueButton, () {
                        checkValidation();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }



  void checkValidation() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (ConstantUrl.isNotEmpty(emailController.text.trim())) {
      checkNetwork();
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      forgotPassword();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> forgotPassword() async {
    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    Map data = {
      ConstantUrl.paramEmail: emailController.text.trim(),
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.forgotPasswordUrl), body: data);

    if (response.statusCode == 200) {
      print("res--${response.body}");

      Map<String, dynamic> map = json.decode(response.body);

      ForgotPasswordModel user = ForgotPasswordModel.fromJson(map);

      dialogUtil.dismissLoadingDialog();

      if (user.data!.success == 1) {
        sendPage();
      }

      if (user.data!.forgotpassword != null) {
        ConstantUrl.showToast(user.data!.forgotpassword!.error!, context);
      }

      print("res--1" + user.toString());

    }
  }

  void sendPage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(emailController.text.trim()),
        ));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           OTPPage("+${_selectedDialogCountry.phoneCode}" + phoneController.text, phoneController.text),
    //     ));


  }
}
