import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';

import 'generated/l10n.dart';
import 'package:intl/intl.dart';

String maOneFont = "MeriendaOne";
String sharedDesiredWeight = "100Lbs";
String beFonts = "Bebasneue";

void exitApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}

String CHALLENGES_WORKOUT = "1";
String CATEGORY_WORKOUT = "2";
String DISCOVER_WORKOUT = "3";
String QUICK_WORKOUT = "4";
String STRETCH_WORKOUT = "5";
String CUSTOM_WORKOUT = "6";

getHistoryTitle(String s) {
  if (s == CHALLENGES_WORKOUT) {
    return 'My Plan';
  } else if (s == CATEGORY_WORKOUT) {
    return 'Body Workout';
  } else if (s == DISCOVER_WORKOUT) {
    return 'Seasonal Yoga';
  } else if (s == QUICK_WORKOUT) {
    return 'Extra Workout';
  } else if (s == STRETCH_WORKOUT) {
    return 'Body Fitness';
  } else if (s == CUSTOM_WORKOUT) {
    return "Custom Workout";
  }
}

class Constants {
  static int actionMale = 0;
  static int actionFemale = 1;
  static int actionOther = 2;
  static String assetsImagePath = "assets/images/";
  static String assetsGifPath = "assets/gifs/";
  static String assetsImageFormat = "";
  static String fontsFamily = 'OpenSans';
  static String boldFontsFamily = 'SecularOne';
  static String splashFontsFamily = 'ReemKufi';
  static String chilankaFontsFamily = 'Chilanka';

  static String videoURL = 'https://www.youtube.com/watch?v=ml6cT4AZdqI';
  static int levelBeginner = 1;
  static int levelIntermediate = 2;
  static int levelAdvanced = 3;
  static const int yogaId = 1;
  static const int seasonalId = 2;
  static const int yogaStyleWorkoutId = 3;
  static const int fitnessId = 4;
  static const double calDefaultCalculation = 0.28;
  static final calFormatter = new NumberFormat("#.##");
  static final String defTimeZoneName = "America/Detroit";

  static DateFormat addDateFormat = DateFormat("dd-MM-yyyy", "en-US");
  static DateFormat showDateFormat = DateFormat("EEE dd MMMM", "en-US");

  static DateFormat timeFormats = DateFormat("mm:ss", "en-US");
  static DateFormat historyTitleDateFormat =
      DateFormat("MMMM dd, yyyy", "en-US");
  static final formatter = new NumberFormat("#.##");

  // static final formatter = new NumberFormat(",##");
  static int minTime = 0;
  static int maxTime = 4;

  static String getLevelName(int i, BuildContext buildContext) {
    // String levelName="";
    if (i == levelBeginner) {
      return S.of(buildContext).beginner;
    } else if (i == levelIntermediate) {
      return S.of(buildContext).intermediate;
    } else {
      return S.of(buildContext).advanced;
    }
  }

  static String decode(String codeUnits) {
    var unescape = HtmlUnescape();
    String singleConvert = unescape
        .convert(codeUnits.replaceAll("\\n\\n", "<br>"))
        .replaceAll("\\n", "<br>");
    return unescape.convert(singleConvert);
  }

  static double feetAndInchToCm(double feet, double inch) {
    double meter;
    double f1 = (feet / 3.281);
    double i1 = (inch / 39.37);
    meter = f1 + i1;
    return meter * 100;
  }

  static void meterToInchAndFeet(double cm, TextEditingController ftController,
      TextEditingController inchController) {
    double meter = cm / 100;
    double inch = (meter * 39.37);
    double ft1 = inch / 12;
    int n = ft1.toInt();
    double in1 = ft1 - n;
    double in2;
    in2 = in1 * 12;
    ftController.text = n.round().toString();
    inchController.text = in2.round().toString();
  }

  static String meterToInchAndFeetText(double cm) {
    double meter = cm / 100;
    double inch = (meter * 39.37);
    double ft1 = inch / 12;
    int n = ft1.toInt();
    double in1 = ft1 - n;
    double in2;
    in2 = in1 * 12;
    return n.round().toString() + " ft " + in2.round().toString() + " in";
    // ftController.text = n.round().toString();
    // inchController.text = in2.round().toString();
  }

  static double getScreenPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height * percent) / 100;
  }

  static double getWidthPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width * percent) / 100;
  }

  static double getPercentSize(double total, double percent) {
    return (total * percent) / 100;
  }

  static double kgToPound(double kg) {
    return kg * 2.205;
    // return (total * percent) / 100;
  }

  static double poundToKg(double kg) {
    return kg / 2.205;
    // return (total * percent) / 100;
  }

  static String getTableNames(int ids) {
    String string = "tbl_yoga_exercise_list";
    switch (ids) {
      case yogaId:
        string = "tbl_yoga_exercise_list";
        break;
      case seasonalId:
        string = "tbl_seasonal_exercise_list";
        break;
      case yogaStyleWorkoutId:
        string = "tbl_yoga_style_exercise_list";
        break;
      case fitnessId:
        string = "tbl_body_fitness_exercise_list";
        break;
    }
    return string;
  }

  static Color getColorFromHex(String colors) {
    var color = "0xFF$colors";
    try {
      return Color(int.parse(color));
    } catch (e) {
      print(e);
      return Color(0xFFFFFFFF);
    }
  }

  static format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  static formatMinutes(Duration d) => d.toString().substring(2, 7);

  static String getTimeFromSec(int sec) {
    final d1 = Duration(seconds: sec);
    return format(d1);
  }

  static String getMMSSFromSec(int sec) {
    final d1 = Duration(seconds: sec);
    return formatMinutes(d1);
  }

  static showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    // Custom Toast Position
  }

  static String getAppLink() {
    String pkgName = "com.gws.yogagogo";
    String appStoreIdentifier = "1562289688";
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=$pkgName";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/us/app/apple-store/id$appStoreIdentifier";
    }
    return "";
  }

  static Color darken(Color c, [int percent = 30]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  static Color brighten(Color c, [int percent = 15]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
  }
}
