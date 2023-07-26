import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../onlineData/ConstantUrl.dart';
import 'package:http/http.dart' as http;

import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'HomeWidget.dart';
import 'IntroPage.dart';
import 'PrefData.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'SizeConfig.dart';
import 'generated/l10n.dart';
import 'online_models/GuideIntroModel.dart';
import 'online_models/LoginModel.dart';
import 'online_models/RegisterModel.dart';

class SignUpDashboardPage extends StatefulWidget {
  late final Function function;
  SignUpDashboardPage(this.function);

  @override
  _SignUpDashboardPage createState() {
    return _SignUpDashboardPage();
  }
}

class _SignUpDashboardPage extends State<SignUpDashboardPage> {
  Future<void> fb_login() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'public_profile'
    ]); // by default we request the email and the public profile

    // loginBehavior is only supported for Android devices, for ios it will be ignored
    /*final result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
      loginBehavior: LoginBehavior
          .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    );*/

    if (result.status == LoginStatus.success) {
      var _accessToken = result.accessToken;
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String pretty = encoder.convert(_accessToken!.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      GuideIntroModel introModel = new GuideIntroModel();
      introModel.username = userData["name"];
      //introModel.email = userObj.email;
      introModel.socialId = userData["id"];
      introModel.loginType = "2";
      gotoNextStepOfSignup(introModel);
    } else {
      print(result.status);
      print(result.message);
    }
  }

  //===============================
  //========== Google Auth=================
  // late GoogleSignInAccount _googleSignIn;

  Future<void> _handleSignUp() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      GuideIntroModel introModel = new GuideIntroModel();
      introModel.username = googleUser.displayName;
      introModel.email = googleUser.email;
      introModel.socialId = googleUser.id;
      introModel.loginType = "1";
      gotoNextStepOfSignup(introModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        // handle the error here
      }
    } catch (e) {
      // handle the error here
    }
  }

  //================ Apple Auth Part==========
  Future<void> _onPressedAppleSignInButton() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(credential);

      GuideIntroModel introModel = new GuideIntroModel();
      introModel.username = credential.givenName ?? "Anonymous";
      introModel.email = credential.email ?? "";
      introModel.socialId = credential.userIdentifier;
      introModel.loginType = "3";
      gotoNextStepOfSignup(introModel);
    } catch (e) {
      // handle the error here
    }
  }

  void gotoNextStepOfSignup(GuideIntroModel introModel) {
    Navigator.push(context, MaterialPageRoute(
      builder: (c) {
        return IntroPage(introModel, () {
          Navigator.pop(context);
        });
      },
    ));
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

    return GestureDetector(
        child: WillPopScope(
            child: Scaffold(
              backgroundColor: bgDarkWhite,
              appBar: getColorStatusBar(bgDarkWhite),
              body: Container(
                child: Column(
                  children: [
                    ConstantWidget.getLoginAppBar(context,
                        function: _requestPop),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                ConstantWidget.getWidthPercentSize(context, 3)),
                        children: [
                          SizedBox(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 2.5),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(70, 0, 70, 0),
                            child: Image.asset(
                                "assets/images/signupdash_title.png"),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                            child: Image.asset(
                                "assets/images/signupdash_subtitle.png"),
                          ),
                          SizedBox(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 10),
                          ),
                          ConstantWidget.getIconButtonWidget(
                              context, 'Sign up with Email',
                              borderColor: redColor,
                              fillColor: redColor,
                              fontColor: Colors.white,
                              asset: "assets/images/email_logo.png", () {
                            Navigator.pop(context);

                            Get.to(() => SignUpPage());
                          }),
                          ConstantWidget.getIconButtonWidget(
                              context, 'Sign up with Facebook',
                              borderColor: quickSvgColor,
                              fillColor: quickSvgColor,
                              fontColor: Colors.white,
                              asset: "assets/images/facebook_logo.png", () {
                            fb_login();
                          }),
                          ConstantWidget.getIconButtonWidget(
                              context, 'Sign up with Google',
                              borderColor: blueButton,
                              fillColor: blueButton,
                              fontColor: Colors.white,
                              asset: "assets/images/google_logo.png", () {
                            _handleSignUp();
                          }),
                          Platform.isIOS
                              ? ConstantWidget.getIconButtonWidget(
                                  context, 'Sign up with Apple',
                                  borderColor: accentColor,
                                  fillColor: accentColor,
                                  fontColor: Colors.white,
                                  asset: "assets/images/apple_logo.png", () {
                                  _onPressedAppleSignInButton();
                                })
                              : SizedBox(
                                  height: ConstantWidget.getScreenPercentSize(
                                      context, 2)),
                          SizedBox(
                            height: ConstantWidget.getScreenPercentSize(
                                context, 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstantWidget.getTextWidget(
                            S.of(context).youHaveAnAlreadyAccount,
                            Colors.black,
                            TextAlign.left,
                            FontWeight.w500,
                            ConstantWidget.getScreenPercentSize(context, 1.8)),
                        SizedBox(
                          width:
                              ConstantWidget.getScreenPercentSize(context, 0.5),
                          height:
                              ConstantWidget.getScreenPercentSize(context, 1),
                        ),
                        GestureDetector(
                          child: ConstantWidget.getTextWidget(
                              S.of(context).signIn,
                              redColor,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getScreenPercentSize(context, 2)),
                          onTap: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ));

                            //widget.function();
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 2),
                    ),
                  ],
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

  void sendSignInPage() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      //checkRegister();
    } else {
      getNoInternet(context);
    }
  }

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
      // ConstantUrl.paramFirstName: firstNameController.text,
      // ConstantUrl.paramLastName: lastNameController.text,
      //ConstantUrl.paramUserName: widget.introModel.username,
      // ConstantUrl.paramEmail: emailController.text,
      // ConstantUrl.paramPassword: textPasswordController.text,
      // ConstantUrl.paramMobile: "+${_selectedDialogCountry.phoneCode}" + phoneController.text,
      // ConstantUrl.paramAge: widget.introModel.age,
      // ConstantUrl.paramGender: widget.introModel.gender,
      // ConstantUrl.paramHeight: widget.introModel.height,
      // ConstantUrl.paramWeight: widget.introModel.weight,
      // ConstantUrl.paramAddress: widget.introModel.address,
      // ConstantUrl.paramCity: widget.introModel.city,
      // ConstantUrl.paramState: widget.introModel.state,
      // ConstantUrl.paramCountry: widget.introModel.country,
      // ConstantUrl.paramTimeInWeek: widget.introModel.timeInWeek,
      // ConstantUrl.paramIntensively: widget.introModel.intensively,
      ConstantUrl.paramDeviceId: deviceId,
    };

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
      //ConstantUrl.paramUserName: widget.introModel.username,
      //ConstantUrl.paramPassword: textPasswordController.text,
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
          // Get.back();
          // Get.back();
          // Get.back();

          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
            sendHomePage(context, 0);
          });

          PrefData.setIsSetting(false);
          // sendHomePage(context, 0);
        }
      }
    }
  }
}
