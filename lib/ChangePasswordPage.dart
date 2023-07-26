import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../onlineData/ConstantUrl.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'PrefData.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';
import 'generated/l10n.dart';
import 'online_models/UpdatePasswordModel.dart';
import 'online_models/UserDetail.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPage createState() {
    return _ChangePasswordPage();
  }
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController textConfirmPasswordController = TextEditingController();

  Future<bool> _requestPop() {
    Navigator.of(context).pop();

    return Future.value(false);
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
            // padding: EdgeInsets.symmetric(
            //     horizontal: ConstantWidget.getScreenPercentSize(context, 2.5)),
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
                          'Change Password',
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
                          context, 'Old Password', textPasswordController),
                      ConstantWidget.getPasswordTextFiled(context,
                          'New Password', textConfirmPasswordController),
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
    String s = await PrefData.getUserDetail();

    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    print("s----" + s);
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      String deviceId = await ConstantUrl.getDeviceId();
      String session = await PrefData.getSession();
      Map data = {
        ConstantUrl.paramUserId: userDetail.userId,
        ConstantUrl.paramSession: session,
        ConstantUrl.paramDeviceId: deviceId,
        ConstantUrl.paramOldPassword: textPasswordController.text,
        ConstantUrl.paramNewPassword: textConfirmPasswordController.text,
      };

      final response =
          await http.post(Uri.parse(ConstantUrl.urlUpdatePassword), body: data);
      if (response.statusCode == 200) {
        print("questionRes------" + response.body.toString());

        dialogUtil.dismissLoadingDialog();
        Map<String, dynamic> map = json.decode(response.body);

        UpdatePasswordModel changePasswordModel =
            UpdatePasswordModel.fromJson(map);

        if (changePasswordModel.data!.success == 1) {
          _requestPop();
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
}
