import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_yoga_workout_4_all_new/BodySpesificWorkoutList.dart';
import 'package:flutter_yoga_workout_4_all_new/online_models/ModeBodySpecificCategory.dart';
import 'package:flutter_yoga_workout_4_all_new/online_models/ModelOtherWorkoutCategoryList.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../HomeWidget.dart';
import '../PrefData.dart';
import '../SignInPage.dart';
import '../models/ModelDetailExerciseList.dart';
import '../models/ModelDummySend.dart';
import '../models/WorkoutHistoryModel.dart';
import '../models/model_get_custom_plan_exercise.dart';
import '../online_models/AddDayComplete.dart';
import '../online_models/AddWeekModel.dart';
import '../online_models/ChallengeDaysModel.dart';
import '../online_models/ChallengeWeekModel.dart';
import '../online_models/HomeSuccess.dart';
import '../online_models/HomeWorkout.dart';
import '../online_models/ModelAllChallenge.dart';
import '../online_models/ModelBodySpecificSubCategoryWorkouts.dart';
import '../online_models/ModelDiscover.dart';
import '../online_models/ModelQuickWorkout.dart';
import '../online_models/ModelStretches.dart';
import '../online_models/ModelWorkout.dart';
import '../online_models/UserDetail.dart';
import '../online_models/model_add_purchase_plan.dart';
import '../online_models/model_check_purchase_plan_day.dart';
import '../online_models/model_get_custom_plan.dart';
import '../online_models/model_package_plan.dart';
import 'ConstantUrl.dart';

Future<ModelGetCustomPlan?> getCustomPlan(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetCustomPlan), body: data);

  print("checkResponseCustom==${response.body}");
  var value = ModelGetCustomPlan.fromJson(jsonDecode(response.body));

  print("checkResponseCustom==${value}");

  checkLoginError(context, value.data.error);

  return value;
}

Future<List<Packageplan>?> getAllPackagesPlan() async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();
    print(
        "userDetail${ConstantUrl.urlAllPackagePlan}----$session--$deviceId==-${userDetail.userId}--");

    Map data = {
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramSession: session,
      ConstantUrl.paramDeviceId: deviceId,
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.urlAllPackagePlan), body: data);

    // print("response--getpackageplan--11-${response.body}===${userDetail.userId}");
    if (checkValidResCode(response.statusCode) && response.body.isNotEmpty) {
      print("response--getpackageplan--12-${response.body}");

      ModelPackagePlan model =
          ModelPackagePlan.fromJson(jsonDecode(response.body));

      print("f===${model.data!.packageplan}");
      if (model.data != null && model.data!.packageplan != null) {
        return ModelPackagePlan.fromJson(jsonDecode(response.body))
            .data!
            .packageplan!;
      } else {
        return null;
      }

      // return ModelPackagePlan.fromJson(jsonDecode(response.body)).data!=null ? ModelPackagePlan.fromJson(jsonDecode(response.body)).data!.packageplan!??[]:[];
    } else {
      print("eerrr");
      return null;
    }
  } else {
    return null;
  }
}

Future<PlanData?> getAllPackagesPlanNew() async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();
    print(
        "userDetail${ConstantUrl.urlAllPackagePlan}----$session--$deviceId==-${userDetail.userId}--");

    Map data = {
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramSession: session,
      ConstantUrl.paramDeviceId: deviceId,
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.urlAllPackagePlan), body: data);
    if (checkValidResCode(response.statusCode) && response.body.isNotEmpty) {
      print("response--getpackageplan--12-${response.body}");

      ModelPackagePlan model =
          ModelPackagePlan.fromJson(jsonDecode(response.body));

      print("f===${model.data!.packageplan}");
      if (model.data != null && model.data!.packageplan != null) {
        return ModelPackagePlan.fromJson(jsonDecode(response.body)).data!;
      } else {
        return null;
      }
    } else {
      print("eerrr");
      return null;
    }
  } else {
    return null;
  }
}

bool checkValidResCode(int code) {
  return code == 200;
}

Future<List<Challenge>?> getAllChallenge(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  try {
    final response =
        await http.post(Uri.parse(ConstantUrl.urlGetAllChallenge), body: data);

    print("urlGetAllChallenge==${response.body}");
    var value = ModelAllChallenge.fromJson(jsonDecode(response.body));
    checkLoginError(context, value.data.error);

    if (value.data.success == 1) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      int intensivelyPosition = 0;

      if (userDetail.intensively != null &&
          userDetail.intensively!.isNotEmpty) {
        intensivelyPosition = int.parse(userDetail.intensively!);
      }

      print(
          "userDetail==${userDetail.intensively}===${value.data.challenges.length}");

      List<Challenge>? list = null;

      if (value.data.challenges.length > intensivelyPosition) {
        list = [];
        list.add(value.data.challenges[intensivelyPosition]);
      }

      return list;
    }

    print("errro====${value.data.error}");
  } catch (e) {
    print(e);
    return null;
  }
  return null;
}

Future<ChallengeWeekModel?> getChallengeWeek(
    BuildContext context, String challengeId) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramChallengeId] = challengeId;

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetChallengeWeek), body: data);

  print("checkResponse==${response.body}");

  var value = ChallengeWeekModel.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<ChallengeDaysModel?> getChallengeDay(
    BuildContext context, String planId) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramPlanID] = (int.parse(planId) + 1).toString();
  print(data);
  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetChallengeDays), body: data);
  print(response.body);
  var value = ChallengeDaysModel.fromJson(jsonDecode(response.body));
  print("day Challengae");
  print(value.data!.days!);
  print(value.data!.error ?? "no error");
  return value;
}

Future<ModelDetailExerciseList?> getChallengeDetailExerciseList(
    BuildContext context, String daysIdGet) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramDaysId] = daysIdGet;

  final response = await http
      .post(Uri.parse(ConstantUrl.urlGetChallengeExercise), body: data);
  print(
      "rescode==list=${ConstantUrl.urlGetChallengeExercise}==$daysIdGet--${response.body}");

  var value = ModelDetailExerciseList.fromJson(jsonDecode(response.body));

  return value;
}

checkLoginError(BuildContext context, String error) {
  if (error.isNotEmpty) {
    if (error.contains(ConstantUrl.loginError)) {
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

Future<AddDayComplete?> addDayComplete(
    BuildContext context, String dayId, String weekID) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.varDaysId] = dayId;
  data[ConstantUrl.varWeekId] = weekID;

  final response =
      await http.post(Uri.parse(ConstantUrl.urlAddCompleteDay), body: data);

  var value = AddDayComplete.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);
  return value;
}

Future<AddWeekModel?> addComplete(BuildContext context, String weekId) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramChallengeWeekId] = weekId;

  final response =
      await http.post(Uri.parse(ConstantUrl.urlAddCompleteWeek), body: data);

  var value = AddWeekModel.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<HomeWorkout?> getHomeWorkoutData(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetHomeWorkout), body: data);

  print("dataResponse-----${response.body}");
  var value = HomeSuccess.fromJson(jsonDecode(response.body));

  if (value.data!.success! == 1) {
    return HomeWorkout.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<WorkoutHistoryModel?> getAllWorkoutHistory(
    BuildContext context, String date) async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();

    Map data = {
      ConstantUrl.paramSession: session,
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramDeviceId: deviceId,
      ConstantUrl.paramCompleteDate: date,
    };

    final response = await http
        .post(Uri.parse(ConstantUrl.urlGetWorkoutCompleted), body: data);

    if (response.body.isEmpty) {
      return null;
    }
    print("urlGetAllCustomDietPlan=1212==-${response.body}");

    print("rescode=1212==-$session----$deviceId----${userDetail.userId}");

    var value = WorkoutHistoryModel.fromJson(jsonDecode(response.body));
    return value;
  } else {
    return null;
  }
}

Future<ModelGetCustomPlanExercise?> getCustomPlanExercise(
  BuildContext context,
) async {
  String customPlanId = await PrefData.getCustomPlanId();

  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramCustomPlanId] = customPlanId;

  final response = await http
      .post(Uri.parse(ConstantUrl.urlGetCustomPlanExercise), body: data);

  print("checkResponse==${response.body}");
  var value = ModelGetCustomPlanExercise.fromJson(jsonDecode(response.body));

  print("checkResponsevalue==${value.data.customplanexercise.length}");

  checkLoginError(context, value.data.error);

  return value;
}

Future<ModelWorkout?> getYogaWorkout(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetAllWorkout), body: data);
  print("rescode===${response.statusCode}--${response.body}");

  var value = ModelWorkout.fromJson(jsonDecode(response.body));

  return value;
}

Future<ModelDetailExerciseList?> getExerciseList(
    BuildContext context, String categoryId) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.varCatId] = categoryId;

  final response = await http.post(
      Uri.parse(ConstantUrl.urlGetALLWorkoutExerciseOfCategory),
      body: data);
  print("rescode===${response.statusCode}--${response.body}");

  var value = ModelDetailExerciseList.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<ModelDetailExerciseList?> getDetailExerciseList(
    BuildContext context, ModelDummySend dummySend) async {
  Map data = await ConstantUrl.getCommonParams();
  data[dummySend.sendParam] = dummySend.id;

  final response =
      await http.post(Uri.parse(dummySend.serviceName), body: data);
  print("serviceName===${dummySend.serviceName}==${dummySend.sendParam}===");
  print("rescode===${response.statusCode}--${response.body}");

  var value = ModelDetailExerciseList.fromJson(jsonDecode(response.body));
  print(value.data!.exercise_tools);
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<ModelDetailExerciseList?> getMyPlanExerciseList(
    BuildContext context, String dayId) async {
  Map data = await ConstantUrl.getCommonParams();
  data["days_id"] = dayId;

  final response = await http.post(
      Uri.parse(
        ConstantUrl.urlGetMyPlanExercise,
      ),
      body: data);

  print("rescode=myplandays==${dayId}--${response.body}");

  var value = ModelDetailExerciseList.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<int?> getTotalExercise(
    BuildContext context, ModelDummySend dummySend) async {
  Map data = await ConstantUrl.getCommonParams();
  data[dummySend.sendParam] = dummySend.id;

  final response =
      await http.post(Uri.parse(dummySend.serviceName), body: data);
  print("rescode===${response.statusCode}--${response.body}");

  var value = ModelDetailExerciseList.fromJson(jsonDecode(response.body));

  // ignore: unnecessary_null_comparison
  if (value != null) {
    if (value.data != null) {
      if (value.data!.success == 1) {
        if (value.data!.exercise != null && value.data!.exercise!.length > 0) {
          return value.data!.exercise!.length;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}

addHistoryData(BuildContext context, String title, String startTime,
    int totalDuration, double cal, String id, String date) async {
  getHomeWorkoutData(context).then((value) {
    int second = 0;
    double kcal = 0;
    int workout = 0;
    if (value != null && value.data!.success == 1) {
      Homeworkout homeWorkout = value.data!.homeworkout!;
      second = int.parse(homeWorkout.duration!);
      kcal = double.parse(homeWorkout.kcal!);
      workout = int.parse(homeWorkout.workouts!);
    }

    second = second + totalDuration;
    kcal = kcal + cal;
    workout = workout + 1;

    addHomeWorkoutData(context, workout, kcal, second);
  });
}

DateFormat addDateFormat = DateFormat("yyyy-MM-dd", "en-US");

Future<bool?> addWholeHistory(BuildContext context, double cal, int second,
    String workoutType, String id) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramKcal] = cal.toString();
  data[ConstantUrl.paramCompleteDuration] = second.toString();
  data[ConstantUrl.paramCompleteDate] = addDateFormat.format(DateTime.now());
  data[ConstantUrl.paramWorkoutType] = workoutType;
  data[ConstantUrl.paramWorkoutId] = id;

  print("addWholeHistory---id--$id--------$workoutType----$cal");
  print(data);

  final response =
      await http.post(Uri.parse(ConstantUrl.urlAddHistory), body: data);

  print(
      "addWholeHistory---12--${response.body}===${response.statusCode}----${addDateFormat.format(DateTime.now())}");

  return true;
}

Future<HomeWorkout?> addHomeWorkoutData(
    BuildContext context, int workout, double cal, int second) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramWorkout] = workout.toString();
  data[ConstantUrl.paramKcal] = cal.toString();
  data[ConstantUrl.paramDuration] = second.toString();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlAddHomeWorkout), body: data);

  print("addResponse-----${response.body}");

  var value = HomeWorkout.fromJson(jsonDecode(response.body));
  checkLoginError(context, value.data!.error!);

  return value;
}

Future<ModelDiscover?> getAllDiscover(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetAllDiscover), body: data);

  var value = ModelDiscover.fromJson(jsonDecode(response.body));

  return value;
}

Future<ModelQuickWorkout?> getAllYogaStyleWorkout(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetAllQuickWorkout), body: data);

  var value = ModelQuickWorkout.fromJson(jsonDecode(response.body));

  print("ModelQuickWorkout====${response.body}");

  return value;
}

Future<ModelStretches?> getAllStretch(BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetAllStretches), body: data);

  var value = ModelStretches.fromJson(jsonDecode(response.body));

  print("responseBody---${response.body}");

  return value;
}

Future<ModelAddPurchasePlan?> addPurchasePlan(
    String planId, String purchaseDate, String status,
    {String purchaseId = "noId"}) async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();
    Map data = {
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramSession: session,
      ConstantUrl.paramDeviceId: deviceId,
      ConstantUrl.paramPlanID: planId,
      ConstantUrl.paramPurchaseDate: purchaseDate,
      "is_active": "1",
      "device_type": Platform.isIOS ? "IOS" : "Android",
      "transaction_id": purchaseId,
      "purchase_token": deviceId,
      "status": status
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.urlAddPurchasePlan), body: data);

    print(
        "response--addpurchaseplan---${response.statusCode}===${userDetail.userId}====${session}==${deviceId}==${planId}===${purchaseDate}");
    print("response--addpurchaseplan11111---${response.body}");
    if (checkValidResCode(response.statusCode) && response.body.isNotEmpty) {
      return ModelAddPurchasePlan.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } else {
    return null;
  }
}

Future<void> cancelPurchasePlan(String productId) async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  // List<Packageplan>? list = await getAllPackagesPlan();
  //
  // String planId = '';
  //
  // if (list != null) {
  // await  list.map((element) {
  //     String id = Platform.isIOS ? element.skuIdIOS! : element.skuIdAndroid!;
  //
  //     if (productId == id) {
  //       planId = element.planId!;
  //     }
  //   });
  // }
  //

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();
    // print(
    //     "userDetail${ConstantUrl.urlAddPurchasePlan}----$session--$deviceId===--");
    String date = ConstantUrl.addDateFormat.format(DateTime.now());

    Map data = {
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramSession: session,
      ConstantUrl.paramDeviceId: deviceId,
      ConstantUrl.paramPlanID: "",
      ConstantUrl.paramCancelDate: date,
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.cancelPurchasePlan), body: data);

    print(
        "response--cancelpurchaseplan---${response.body}===${userDetail.userId}====$session==$deviceId");
    //   if (checkValidResCode(response.statusCode) && response.body.isNotEmpty) {
    //     return ModelAddPurchasePlan.fromJson(jsonDecode(response.body));
    //   } else {
    //     return null;
    //   }
    // } else {
    //   return null;
  }
}

Future<Checkpurchaseplanday?> checkPurchasePlanDay() async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();
    print("userDetail purchase----$session--$deviceId==-$s--");

    Map data = {
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramSession: session,
      ConstantUrl.paramDeviceId: deviceId
    };

    final response = await http
        .post(Uri.parse(ConstantUrl.urlCheckPurchasePlanDay), body: data);

    if (checkValidResCode(response.statusCode) && response.body.isNotEmpty) {
      print("response--checkpurchaseplanday---${response.body}");

      ModelCheckPurchasePlanDay _checkPurchasePlanDay =
          ModelCheckPurchasePlanDay.fromJson(jsonDecode(response.body));
      print("response--checkpurchaseplanday1212---${response.body}");

      if (_checkPurchasePlanDay.data!.success == 1) {
        return _checkPurchasePlanDay.data!.checkpurchaseplanday!;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else {
    return null;
  }
}

//================ New Workout Module=============
Future<ModeBodySpecificCategory?> getAllBodySpecificCategory(
    BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response =
      await http.post(Uri.parse(ConstantUrl.urlGetAllWorkout), body: data);

  var value = ModeBodySpecificCategory.fromJson(jsonDecode(response.body));

  return value;
}

Future<ModelOtherWorkoutCategoryList?> getAllOtherWorkoutCategoies(
    BuildContext context) async {
  Map data = await ConstantUrl.getCommonParams();

  final response = await http
      .post(Uri.parse(ConstantUrl.urlGetAllOtherWorkOutCategories), body: data);
  var value = ModelOtherWorkoutCategoryList.fromJson(jsonDecode(response.body));
  return value;
}

Future<ModelBodySpecificSubCategoryWorkouts?>
    getAllBodySpecificSubCategoryDetail(
        BuildContext context, String subCategoryId) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.varCatId] = subCategoryId;
  final response = await http.post(
      Uri.parse(ConstantUrl.urlGetAllWorkoutsofOneBodySpecific),
      body: data);
  var value =
      ModelBodySpecificSubCategoryWorkouts.fromJson(jsonDecode(response.body));
  return value;
}
