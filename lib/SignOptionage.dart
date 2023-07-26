import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yoga_workout_4_all_new/SignUpDashboardPage.dart';
import 'package:flutter_yoga_workout_4_all_new/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../generated/l10n.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'ForgotPasswordPage.dart';
import 'IntroPage.dart';

import 'PrefData.dart';

import 'SignInPage.dart';
import 'Subscription/SubscriptionWidget.dart';
import 'online_models/LoginModel.dart';
import 'onlineData/ConstantUrl.dart';

class SignOptionPage extends StatefulWidget {
  @override
  _SignOptionPage createState() {
    return _SignOptionPage();
  }
}

class _SignOptionPage extends State<SignOptionPage> {
  bool isRemember = false;
  int themeMode = 0;

  @override
  Widget build(BuildContext context) {
    // final function = ModalRoute.of(context)!.settings.arguments as Function;
    setStatusBarColor(Colors.white);
    return GestureDetector(
      child: WillPopScope(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: getColorStatusBar(Colors.white),
            body: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                      child: Image.asset("assets/images/home.png"),
                    )
                ),
                Positioned(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 300,
                          child: Image.asset("assets/images/home_bigtitle.png"),),
                        SizedBox(height: 30,),
                        Container(
                          width: 280,
                          child: Image.asset("assets/images/home_smalltitle.png"),),
                      ],
                    ),
                  ),
                  top: 50,
                ),

                Positioned(
                  bottom: 30,
                  child:  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal:
                        ConstantWidget.getWidthPercentSize(context, 3)),
                    child: Column(
                      children: [
                        ConstantWidget.getBorderWithBlackBackgroundButtonWidget(
                            context, "GET STARTED", () async{
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (c) {
                            return SignUpDashboardPage((){
                              Navigator.pop(context);
                            });
                          },));
                        }, borderColor: Colors.grey, fillColor: Colors.white, fontColor: accentColor),


                        ConstantWidget.getBorderWithBlackBackgroundButtonWidget(
                            context, "ALREADY HAVE AN ACCOUNT", () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ));
                        }, borderColor: primaryColor, fillColor: accentColor, fontColor: primaryColor),

                        SizedBox(
                          height: ConstantWidget.getScreenPercentSize(context, 5),
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),
          ),
          onWillPop: () {
            PrefData.setIsSetting(false);
            Navigator.pop(context);
            return new Future.value(false);
          }),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }


}

