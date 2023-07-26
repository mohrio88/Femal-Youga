import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter_yoga_workout_4_all_new/IntroModel.dart';
import 'package:flutter_yoga_workout_4_all_new/SignOptionage.dart';
import 'package:flutter_yoga_workout_4_all_new/Subscription/SubscriptionWidget.dart';
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

class SignUpFinalPage extends StatefulWidget {

  final GuideIntroModel introModel;
  late final Function function;

  SignUpFinalPage(this.introModel);

  @override
  _SignUpFinalPage createState() {
    return _SignUpFinalPage();
  }
}

class _SignUpFinalPage extends State<SignUpFinalPage> {
  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      signUp();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> signUp() async {
    String deviceId = await ConstantUrl.getDeviceId();

    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    print("deviceId------${deviceId}");

    Map data = {
      ConstantUrl.paramFirstName: widget.introModel.username??"",
      ConstantUrl.paramUserName:  widget.introModel.loginType != "0"? widget.introModel.socialId: widget.introModel.username,
      ConstantUrl.paramEmail: widget.introModel.email??"",
      ConstantUrl.paramPassword: widget.introModel.loginType != "0"? widget.introModel.socialId: widget.introModel.password,
      ConstantUrl.paramAge: widget.introModel.age,
      ConstantUrl.paramAreas: widget.introModel.areas,
      ConstantUrl.paramHeight:  widget.introModel.height,
      ConstantUrl.paramWeight:  widget.introModel.weight,
      ConstantUrl.paramDesiredWeight:  widget.introModel.desiredWeight,
      ConstantUrl.paramCountry: widget.introModel.country??"",
      ConstantUrl.paramIntensively: widget.introModel.intensively,
      ConstantUrl.loginType: widget.introModel.loginType,
      ConstantUrl.paramDeviceId: deviceId,
    };

    print(data.toString());

    final response =
    await http.post(Uri.parse(ConstantUrl.registerUrl), body: data);

    if (response.statusCode == 200) {

      print("data------${data.toString()}");
      print("response------${response.body}");


      Map<String, dynamic> map = json.decode(response.body);

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      print("response------${response.body}");
      RegisterModel user = RegisterModel.fromJson(map);

      dialogUtil.dismissLoadingDialog();

      if (user.dataModel.login != null) {
        ConstantUrl.showToast(user.dataModel.login!.error!, context);
      }
      if (user.dataModel.success == 1) {
        // Navigator.of(context).pop();
        signIn();
      }
      print("res--1" + user.toString());
    }
  }

  Future<void> signIn() async {
    String deviceId = await ConstantUrl.getDeviceId();

    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    Map data = {
      ConstantUrl.paramUserName:  widget.introModel.loginType != "0"? widget.introModel.socialId: widget.introModel.username,
      ConstantUrl.paramPassword: widget.introModel.loginType != "0"? widget.introModel.socialId: widget.introModel.password,
      ConstantUrl.paramLoginType : widget.introModel.loginType,
      ConstantUrl.paramDeviceId: deviceId,
    };

    final response =
    await http.post(Uri.parse(ConstantUrl.loginUrl), body: data);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);

      LoginModel user = LoginModel.fromJson(map);
      print("response----12--${deviceId}------${response.body}");
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (user.dataModel!.login != null) {
        // ConstantUrl.showToast(user.dataModel!.login!.error!, context);
      }

      dialogUtil.dismissLoadingDialog();
      if (user.dataModel!.success == 1) {
        if (user.dataModel!.login != null) {
          PrefData.setUserDetail(
              json.encode(user.dataModel!.login!.userDetail));
          PrefData.setSession(user.dataModel!.login!.session!);
          PrefData.setIsSignIn(true);
          PrefData.setFirstSignUp(false);
          Future.delayed(Duration(seconds: 1),(){
            // Navigator.of(context).pop();
            // sendHomePage(context, 0);
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => SubscriptionWidget()
            //   ),
            //       (route)=> false,
            // );
            Get.to(SubscriptionWidget())!.then((value) {
              if(value == null){
                sendHomePage(context, 0,isPushReplace: true);
              }
              if (value != null && value) {
                //function();
              }
            });
          });

          PrefData.setIsSetting(false);
          // sendHomePage(context, 0);
        }
      }
    }
  }



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

    return Scaffold(
      appBar: getColorStatusBar(Colors.black54),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset("assets/images/bg_signupfinal.png", fit: BoxFit.fitHeight,)),
            ConstantWidget.getLoginAppBar(context,
                function: _requestPop),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0),
                    child: Image.asset("assets/images/txt_signupfinal.png", scale: 1.4,),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child:  ConstantWidget.getIconButtonWidget(
                            context, 'No', borderColor: Colors.grey, fillColor : Colors.grey, fontColor : Colors.black54, asset: "" ,() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignOptionPage()
                              ),
                              (route)=> false,
                          );
                        }),
                      ),
                      SizedBox(width: 20,),
                      Expanded(
                        flex: 2,
                        child:  ConstantWidget.getIconButtonWidget(
                            context, 'Yes', borderColor: Colors.white, fillColor : Colors.white, fontColor : Colors.black, asset: "" ,() async {
                          await checkNetwork();
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => SubscriptionWidget()
                          //   ),
                          //       (route)=> false,
                          // );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }



}
