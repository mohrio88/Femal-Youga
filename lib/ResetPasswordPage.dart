import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../onlineData/ConstantUrl.dart';
import '../util/ResetPasswordDialogBox.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';
import 'generated/l10n.dart';
import 'online_models/ResetPasswordModel.dart';

class ResetPasswordPage extends StatefulWidget {
  final String emailAddress;

  ResetPasswordPage(this.emailAddress);

  @override
  _ResetPasswordPage createState() {
    return _ResetPasswordPage();
  }
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController textConfirmPasswordController =
      new TextEditingController();

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
                    padding: EdgeInsets.symmetric(horizontal: ConstantWidget.getWidthPercentSize(context, 3)),

                    children: [
                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 2.5),
                      ),
                      ConstantWidget.getTextWidget(
                          'Reset Password',
                          textColor,
                          TextAlign.left,
                          FontWeight.bold,
                          ConstantWidget.getScreenPercentSize(context, 3)),
                      SizedBox(
                        height:
                            ConstantWidget.getScreenPercentSize(context, 1.4),
                      ),
                      ConstantWidget.getTextWidget(
                          "Enter a New Password!",
                          textColor,
                          TextAlign.left,
                          FontWeight.w400,
                          ConstantWidget.getScreenPercentSize(context, 2)),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 4),
                      ),
                      ConstantWidget.getPasswordTextFiled(
                          context, 'New Password', textPasswordController),
                      ConstantWidget.getPasswordTextFiled(context,
                          'Confirm Password', textConfirmPasswordController),
                      ConstantWidget.getButtonWidget(
                          context, 'Next', blueButton, () {
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

    if (ConstantUrl.isNotEmpty(textPasswordController.text) &&
        ConstantUrl.isNotEmpty(textConfirmPasswordController.text)) {
      if ((textPasswordController.text.length >= 6) &&
          textConfirmPasswordController.text.length >= 6) {
        checkNetwork();
      } else {
        ConstantUrl.showToast(S.of(context).passwordError, context);
      }
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      changePassword();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> changePassword() async {
    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();
    Map data = {
      ConstantUrl.paramEmail: widget.emailAddress,
      ConstantUrl.paramNewPassword: textPasswordController.text,
    };
    print(ConstantUrl.urlResetPassword);
    final response =
        await http.post(Uri.parse(ConstantUrl.urlResetPassword), body: data);
    if (response.statusCode == 200) {
      print("questionRes------" + response.body.toString());

      dialogUtil.dismissLoadingDialog();

      Map<String, dynamic> map = json.decode(response.body);

      ResetPasswordModel changePasswordModel = ResetPasswordModel.fromJson(map);

      if (changePasswordModel.data!.success == 1) {
        // _requestPop();

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ResetPasswordDialogBox(
                func: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage(),));
                },
              );
            });

      }
      if (changePasswordModel.data!.updatepassword != null) {
        if (changePasswordModel.data!.updatepassword!.length > 0) {
          ConstantUrl.showToast(
              changePasswordModel.data!.updatepassword![0].error!, context);
        }
      }
    }
  }
}
