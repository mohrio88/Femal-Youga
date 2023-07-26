import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_yoga_workout_4_all_new/SignOptionage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import '../ConstantWidget.dart';
import '../GuideIntroPage.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'PrefData.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';
import 'ads/app_openad_manager.dart';
import 'generated/l10n.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  bool isFirst = true;

  late AppOpenAdManager appOpenAdManager;

  @override
  void initState() {
    super.initState();
    appOpenAdManager = AppOpenAdManager()..loadAd();




    _getIsFirst();
  }





  _getIsFirst() async {
    bool _isSignIn = await PrefData.getIsSignIn();

    print("is===${_isSignIn}");

    isFirst = await PrefData().getIsFirstIntro();
    bool isIntro = await PrefData.getIsIntro();
    // if (isIntro) {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => GuideIntroPage()));
    //
    //   // Get.to(GuideIntroPage());
    // } else
    if (_isSignIn == false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignOptionPage(),
          ));
    }else {
      Timer(Duration(seconds: 3), () {
        appOpenAdManager.showAdIfAvailable();
        sendHomePage(context, 0, isPushReplace: true);
      });
    }
  }

  ThemeData themeData = new ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: getColorStatusBar(bgDarkWhite),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: bgDarkWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  Constants.assetsImagePath + "splash_icon.png",
                  height: ConstantWidget.getScreenPercentSize(context, 15),
                ),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              ),
              ConstantWidget.getTextWidgetWithFont(
                  S.of(context).yogaFitness,
                  Colors.black,
                  TextAlign.center,
                  FontWeight.bold,
                  ConstantWidget.getScreenPercentSize(context, 4),
                  Constants.splashFontsFamily)
            ],
          ),
        ),
      ),
    );



  }
}
