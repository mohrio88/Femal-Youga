import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';
import 'package:flutter_yoga_workout_4_all_new/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../generated/l10n.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'ForgotPasswordPage.dart';
// import 'IntroPage.dart';

import 'PrefData.dart';

import 'SignUpDashboardPage.dart';
// import 'Subscription/SubscriptionWidget.dart';
import 'online_models/LoginModel.dart';
import 'onlineData/ConstantUrl.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  bool isRemember = false;
  int themeMode = 0;
  TextEditingController textNameController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  String countryCode = "IN";

  Future<void> getKeyHash() async {
    String keyHash;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      keyHash = await FlutterFacebookKeyhash.getFaceBookKeyHash ??
          'Unknown platform KeyHash';
    } on PlatformException {
      keyHash = 'Failed to get Kay Hash.';
    }
    print(keyHash);

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    // final function = ModalRoute.of(context)!.settings.arguments as Function;
    setStatusBarColor(bgDarkWhite);
    return GestureDetector(
      child: WillPopScope(
          child: Scaffold(
            backgroundColor: bgDarkWhite,
            appBar: getColorStatusBar(bgDarkWhite),
            // appBar: AppBar(
            //   backgroundColor: bgDarkWhite,
            //   toolbarHeight: 0,
            //   elevation: 0,
            // ),
            body: Container(
              child: Column(
                children: [
                  ConstantWidget.getLoginAppBar(context, function: () {
                    PrefData.setIsSetting(false);
                    Navigator.pop(context);
                  }),
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
                            "Login",
                            textColor,
                            TextAlign.left,
                            FontWeight.bold,
                            ConstantWidget.getScreenPercentSize(context, 3)),
                        SizedBox(
                          height:
                              ConstantWidget.getScreenPercentSize(context, 1.4),
                        ),
                        ConstantWidget.getTextWidget(
                            "Welcome to your account!", //"Version 1.0.0(24)",//
                            textColor,
                            TextAlign.left,
                            FontWeight.w400,
                            ConstantWidget.getScreenPercentSize(context, 2)),
                        SizedBox(
                          height:
                              ConstantWidget.getScreenPercentSize(context, 2),
                        ),
                        ConstantWidget.getDefaultTextFiledWidget(
                          context,
                          S.of(context).username,
                          userNameController,
                        ),
                        ConstantWidget.getPasswordTextFiled(
                            context, 'Password', textPasswordController),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: ConstantWidget.getTextWidget(
                                    'Forgot Password?',
                                    textColor,
                                    TextAlign.end,
                                    FontWeight.w600,
                                    ConstantWidget.getScreenPercentSize(
                                        context, 1.8)),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage(),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height:
                              ConstantWidget.getScreenPercentSize(context, 4),
                        ),
                        ConstantWidget.getIconButtonWidget(
                            context, 'Sign in Now',
                            borderColor: redColor,
                            fillColor: redColor,
                            fontColor: Colors.white,
                            asset: "", () {
                          checkValidation(() {});
                        }),
                        ConstantWidget.getIconButtonWidget(
                            context, 'Sign in with Facebook',
                            borderColor: quickSvgColor,
                            fillColor: quickSvgColor,
                            fontColor: Colors.white,
                            asset: "assets/images/facebook_logo.png", () {
                          //getKeyHash();
                          fb_login();
                        }),
                        ConstantWidget.getIconButtonWidget(
                            context, 'Sign in with Google',
                            borderColor: blueButton,
                            fillColor: blueButton,
                            fontColor: Colors.white,
                            asset: "assets/images/google_logo.png", () {
                          signInWithGoogle();
                        }),
                        Platform.isIOS
                            ? ConstantWidget.getIconButtonWidget(
                                context, 'Sign in with Apple',
                                borderColor: accentColor,
                                fillColor: accentColor,
                                fontColor: Colors.white,
                                asset: "assets/images/apple_logo.png", () {
                                _onPressedAppleSignInButton();
                              })
                            : SizedBox(
                                height: 30,
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstantWidget.getTextWidget(
                                "You haven't an account yet?",
                                Colors.black,
                                TextAlign.left,
                                FontWeight.w500,
                                ConstantWidget.getScreenPercentSize(
                                    context, 1.8)),
                            SizedBox(
                              width: ConstantWidget.getScreenPercentSize(
                                  context, 0.5),
                              height: ConstantWidget.getScreenPercentSize(
                                  context, 1),
                            ),
                            GestureDetector(
                              child: ConstantWidget.getTextWidget(
                                  S.of(context).signUpNow,
                                  redColor,
                                  TextAlign.start,
                                  FontWeight.bold,
                                  ConstantWidget.getScreenPercentSize(
                                      context, 2)),
                              onTap: () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignUpDashboardPage(() {
                                        Navigator.pop(context);
                                      }),
                                    ));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2),
                  ),
                ],
              ),
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

  void checkValidation(Function function) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (ConstantUrl.isNotEmpty(userNameController.text) &&
        ConstantUrl.isNotEmpty(textPasswordController.text)) {
      if ((textPasswordController.text.length >= 6)) {
        checkNetwork(function);
      } else {
        ConstantUrl.showToast(S.of(context).passwordError, context);
      }
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }

  checkNetwork(Function function) async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      signIn(
          "0", userNameController.text, textPasswordController.text, function);
    } else {
      getNoInternet(context);
    }
  }

  Future<void> fb_login() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'public_profile'
    ]); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      var _accessToken = result.accessToken;
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String pretty = encoder.convert(_accessToken!.toJson());
      final userData = await FacebookAuth.instance.getUserData();
      print(userData["id"]);

      signIn("2", userData["id"], userData["id"], () {});
    } else {
      print(result.status);
      print(result.message);
    }
  }
  //===============================
  //========== Google Auth=================
  // late GoogleSignInAccount userObj;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  // void googlelogin() async{
  //   try {
  //     userObj = (await _googleSignIn.signIn())!;

  //     GoogleSignInAuthentication googleSignInAuthentication = await userObj.authentication;
  //     // print(googleSignInAuthentication.idToken);
  //     // print(googleSignInAuthentication.accessToken);
  //     print(userObj.photoUrl);
  //     print(userObj.displayName);
  //     print(userObj.email);
  //     print(userObj.id);
  //     signIn("1", userObj.id, userObj.id, (){});
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          signIn("1", googleSignInAccount.id, googleSignInAccount.id, () {});
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ...
        } else if (e.code == 'invalid-credential') {
          // ...
        }
      } catch (e) {
        // ...
      }
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
      print(credential.email);
      print(credential);
      signIn("3", credential.userIdentifier ?? "",
          credential.userIdentifier ?? "", () {});
    } catch (e) {
      // handle the error here
    }
  }

  Future<void> signIn(String loginType, String userName, String password,
      Function function) async {
    String deviceId = await ConstantUrl.getDeviceId();

    DialogUtil dialogUtil = new DialogUtil(context);
    dialogUtil.showLoadingDialog();

    Map data = {
      ConstantUrl.paramUserName: userName,
      ConstantUrl.paramPassword: password,
      ConstantUrl.paramLoginType: loginType,
      ConstantUrl.paramDeviceId: deviceId,
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.loginUrl), body: data);

    if (response.statusCode == 200) {
      print("login----12--${deviceId}------${response.body}");

      Map<String, dynamic> map = json.decode(response.body);

      LoginModel user = LoginModel.fromJson(map);
      print("response----12--${deviceId}------${response.body}");
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (user.dataModel!.login != null) {
        ConstantUrl.showToast(user.dataModel!.login!.error!, context);
      }

      dialogUtil.dismissLoadingDialog();
      if (user.dataModel!.success == 1) {
        if (user.dataModel!.login != null) {
          PrefData.setUserDetail(
              json.encode(user.dataModel!.login!.userDetail));
          PrefData.setSession(user.dataModel!.login!.session!);
          PrefData.setIsSignIn(true);
          // if (await PrefData.getFirstSignUp() == true) {
          //   Get.back();
          //   Get.back();
          // }

          // function();

          bool isSetting = await PrefData.getIsSetting();

          if (isSetting) {
            HomeController homeController = Get.find();

            if (homeController != null) {
              homeController.index = 0.obs;
            }
          }

          sendHomePage(context, 0, isPushReplace: true);
          // Navigator.push(context, MaterialPageRoute(builder: (c) {
          //   return SubscriptionWidget();
          // },));
          PrefData.setIsSetting(false);
        }
      }
    }
  }
}

getNoInternet(BuildContext context) {
  return Container(
      color: bgDarkWhite,
      child: Center(
        child: Text(
          S.of(context).noInternetConnection,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.bold),
        ),
      ));
}
