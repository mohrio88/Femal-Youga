import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../HomeWidget.dart';
import '../PrefData.dart';
import '../SignInPage.dart';
import '../models/model_delete_custom_plan_exercise.dart';
import '../online_models/IntensivelyModel.dart';
import '../online_models/UserDetail.dart';
import 'package:http/http.dart' as http;

import 'dummy_data.dart';
import 'package:intl/intl.dart' show DateFormat;

class ConstantUrl {
  static String termsURL = 'https://app.yoganearme.club/t-and-c.html';
  static String privacyURL = 'https://app.yoganearme.club/privacy-policy.html';

  static DateFormat addDateFormat = DateFormat("dd-MM-yyyy", "en-US");

  static String mainUrl =

      //'http://192.168.101.80/Yoga/';
      'https://app.yoganearme.club/admin/';

  static String baseUrl = mainUrl + 'api/';
  static String uploadUrl = mainUrl + 'uploads/';
  static String urlGetAllChallenge = baseUrl + "challenges.php";
  static String checkAlreadyRegisterUrl = baseUrl + "checkalreadyregister.php";
  static String registerUrl = baseUrl + "register.php";
  static String loginUrl = baseUrl + "login.php";
  static String forgotPasswordUrl = baseUrl + "forgotpassword.php";
  static String deleteAccountUrl = baseUrl + "deleteaccount.php";
  static String logOutUrl = baseUrl + "logout.php";
  static String urlGetChallengeWeek = baseUrl + "getweek.php";
  static String urlGetChallengeDays = baseUrl + "getdays.php";
  static String urlGetAllDiscover = baseUrl + "discover.php";
  static String urlUpdatePassword = baseUrl + "updatepassword.php";
  static String urlResetPassword = baseUrl + "changepassword.php";
  static String urlGetDiscoverExercise = baseUrl + "discoverexercise.php";
  static String urlGetMyPlanExercise = baseUrl + "daysstretchesexercise.php";
  static String urlGetAllWorkout = baseUrl + "category.php";
  static String urlGetAllWorkoutsofOneBodySpecific =
      baseUrl + "bodyworkout.php";
  static String urlGetAllOtherWorkOutCategories =
      baseUrl + "quickworkoutcategory.php";
  static String urlGetChallengeExercise = baseUrl + "challengesexercise.php";
  static String urlGetALLWorkoutExerciseOfCategory =
      baseUrl + "categoryexercise.php";
  static String urlGetWorkoutExercise = baseUrl + "bodyworkoutexercise.php";
  static String urlGetAllQuickWorkout = baseUrl + "quickworkout.php";
  static String urlGetExerciseDetail = baseUrl + "getexercise.php";
  static String urlGetAllExercise = baseUrl + "getallexercise.php";
  static String urlGetSettings = baseUrl + "setting.php";
  static String urlEditProfile = baseUrl + "editprofile.php";
  static String urlAddCompleteWeek = baseUrl + "weekcompleted.php";
  static String urlAddCompleteDay = baseUrl + "daycompleted.php";
  static String urlGetHomeWorkout = baseUrl + "gethomeworkout.php";
  static String urlAddHomeWorkout = baseUrl + "homeworkout.php";
  static String urlAddHistory = baseUrl + "workoutscompleted.php";
  static String urlGetWorkoutCompleted = baseUrl + "getworkoutcompleted.php";
  static String urlGetCustomPlan = baseUrl + "getcustomplan.php";
  static String urlDeleteCustomPlan = baseUrl + "deletecustomplan.php";
  static String urlAddCustomPlan = baseUrl + "customplan.php";
  static String urlEditCustomPlan = baseUrl + "editcustomplan.php";
  static String urlGetCustomPlanExercise =
      baseUrl + "getcustomplanexercise.php";
  static String urlGetQuickWorkoutExercise =
      baseUrl + "quickworkoutexercise.php";
  static String urlDeleteCustomPlanExercise =
      baseUrl + 'deletecustomplanexercise.php';
  static String urlAddCustomPlanExercise = baseUrl + "customplanexercise.php";
  static String urlEditCustomPlanExercise =
      baseUrl + "editcustomplanexercise.php";

  static String urlGetAllStretches = baseUrl + "stretches.php";
  static String urlGetStretchesExercise = baseUrl + "stretchesexercise.php";
  static String varPost = "post";
  static String varExerciseId = "exercise_id";
  static String varCatId = "category_id";
  static String varDiscoverId = "discover_id";
  static String varQuickWorkoutId = "quickworkout_id";
  static String varStretchesId = "stretches_id";
  static String varChallengeId = "challenges_id";
  static String paramChallengeWeekId = "week_id";
  static String paramWorkoutId = "workout_id";
  static String paramDaysId = "days_id";
  static String paramFirstName = "first_name";
  static String paramLastName = "last_name";
  static String paramImage = "image";
  static String paramPassword = "password";
  static String paramLoginType = "login_type";
  static String paramUserName = "username";
  static String paramMobile = "mobile";
  static String paramDeviceId = "device_id";
  static String paramOldPassword = "oldpassword";
  static String paramNewPassword = "newpassword";
  static String paramUserId = "user_id";
  static String paramChallengeId = "challenges_id";
  static String varDaysId = "days_id";
  static String paramCompleteDate = "completed_date";
  static String varWeekId = "week_id";
  static String paramCompleteDuration = "completed_duration";
  static String paramWorkout = "workouts";
  static String paramSubCategory = "sub_category";
  static String paramKcal = "kcal";
  static String paramDuration = "duration";
  static String paramEmail = "email";
  static String paramAge = "age";
  static String paramHeight = "height";
  static String paramWeight = "weight";
  static String paramDesiredWeight = "desired_weight";
  static String paramAreas = "area";
  static String loginType = "login_type";
  static String paramIntensively = "intensively";
  static String paramCountry = "country";
  static String paramSession = "session";
  static String paramWorkoutType = "workout_type";
  static final String loginError = "Please login first";
  static final String feedbackMail = "fitnfineapps@gmail.com";
  static String paramCustomPlanId = "custom_plan_id";
  static String paramName = 'name';
  static String paramDescription = "description";
  static String paramCustomPlanExerciseId = "custom_plan_exercise_id";
  static String paramExerciseId = "exercise_id";
  static String paramExerciseTime = "exercise_time";

  static String urlAllPackagePlan = baseUrl + "plan.php";
  static String cancelPurchasePlan = baseUrl + "cancelplan.php";

  static String urlAddPurchasePlan = baseUrl + "addpurchaseplan.php";

  static String paramPlanID = "plan_id";
  static String paramPurchaseDate = "purchase_date";
  static String paramCancelDate = "cancel_date";

  static String urlCheckPurchasePlanDay = baseUrl + "checkpurchaseplanday.php";

  static String urlAppleRedirect = baseUrl + "appleredirecturl.php";

  static Future<bool> isLogin() async {
    return await PrefData.getIsSignIn();
  }

  static bool isNotEmpty(String s) {
    return (s.isNotEmpty);
  }

  static Future<Map> getCommonParams() async {
    bool _isSignIn = await PrefData.getIsSignIn();
    String s = await PrefData.getUserDetail();
    String deviceId = await ConstantUrl.getDeviceId();
    String session = await PrefData.getSession();

    print("service---1" + s);
    if (_isSignIn && s.isNotEmpty) {
      Map<String, dynamic> userMap;
      userMap = jsonDecode(s) as Map<String, dynamic>;

      final UserDetail user = UserDetail.fromJson(userMap);
      print(user);

      print("addWholeHistory-----${user.userId}---$session---$deviceId");
      return {
        ConstantUrl.paramUserId: user.userId,
        ConstantUrl.paramSession: session,
        ConstantUrl.paramDeviceId: deviceId,
      };
    } else {
      return {
        ConstantUrl.paramUserId: '',
        ConstantUrl.paramSession: 'session',
        ConstantUrl.paramDeviceId: '',
      };
    }
  }

  static Future<UserDetail> getUserDetail() async {
    String s = await PrefData.getUserDetail();
    print("service---1" + s);
    if (s.isNotEmpty) {
      Map<String, dynamic> userMap;
      userMap = jsonDecode(s) as Map<String, dynamic>;
      final UserDetail user = UserDetail.fromJson(userMap);
      print(user);
      print("service---" + user.toString());
      return user;
    } else {
      return new UserDetail();
    }
  }

  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool phoneNumberValidator(String value) {
    Pattern pattern = r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  static void sendLoginPage(BuildContext context,
      {Function? function, Function? argument}) {
    Get.to(SignInPage(), arguments: argument)!.then((value) {
      if (value != null && value) {
        if (function != null) {
          function();
        }
      }
    });
  }

  static void checkLoginError(BuildContext context, String error) {
    if (error.isNotEmpty) {
      if (error.contains(loginError)) {
        PrefData.setUserDetail("");
        PrefData.setSession("");
        PrefData.setIsSignIn(false);
        ConstantUrl.sendLoginPage(context, function: () {}, argument: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeWidget()));
        });
      }
    }
  }

  static Future<String> getDeviceId() async {
    String? deviceId = "";

    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    return deviceId!;
  }

  static Future<bool> getNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static showToast(String s, BuildContext context) {
    checkLoginError(context, s);

    if (s.isNotEmpty) {
      Fluttertoast.showToast(
          msg: s,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 12);

      // Toast.show(s, context,
      //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  static List<IntensivelyModel> getIntensivelyModel() {
    List<IntensivelyModel> list = [];

    IntensivelyModel model = new IntensivelyModel();
    model.title = "Beginner";
    model.desc =
        "I want to exercise that is easy and gentle on\nyour joints and tendons..";
    list.add(model);

    model = new IntensivelyModel();
    model.title = "Intermediate";
    model.desc = "I do some physical activity and moderate\nexercise";
    list.add(model);

    model = new IntensivelyModel();
    model.title = "Advanced";
    model.desc = "I do exercise most days and my fitness\nlevel is good";
    list.add(model);

    return list;
  }

  static List<IntensivelyModel> getTimeInWeekModel() {
    List<IntensivelyModel> list = [];

    IntensivelyModel model = new IntensivelyModel();
    model.title = "2-3 times in week";
    model.desc =
        "Aerobic exercise can help improve your cardiovascular health,tone muscle ,and support...Duration and frequency:2 to 3 times per week.";
    list.add(model);

    model = new IntensivelyModel();
    model.title = "5 days in week";
    model.desc =
        "Training four to five times a week is ideal,but most people find that unachievable due to time constraints,so many says it's best to aim for three.";
    list.add(model);

    model = new IntensivelyModel();
    model.title = "All 7 days";
    model.desc =
        "Certified fitness trainer jeff bell says if you find yourself constantly skipping rest days to fit in workouts seven.";
    list.add(model);

    return list;
  }

  static deleteExercise(BuildContext context, Function function,
      String customPlanExerciseId, String id) async {
    Map data = await ConstantUrl.getCommonParams();
    data[ConstantUrl.paramCustomPlanExerciseId] = customPlanExerciseId;

    final response = await http
        .post(Uri.parse(ConstantUrl.urlDeleteCustomPlanExercise), body: data);

    DummyData.removeExercise(id);
    var value =
        ModelDeleteCustomPlanExercise.fromJson(jsonDecode(response.body));

    ConstantUrl.showToast(value.data.error, context);
    checkLoginError(context, value.data.error);
    if (value.data.success == 1) {
      function();
    }
  }
}
