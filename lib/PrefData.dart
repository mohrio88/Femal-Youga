import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String pkgName = "yoga_workout_ui";
  static String remindTime = pkgName + "ttsSetRemindTime";
  static String remindDays = pkgName + "ttsSetRemindDays";
  static String remindAmPm = pkgName + "ttsSetRemindAmPm";
  static String trainingRest = pkgName + "ttsTrainingRest";
  static String reminderOn = pkgName + "ttsIsReminderOn";
  static String calorieBurn = pkgName + "ttsCalorieBurn";
  static String getDailyGoal = pkgName + "ttsCalorieBurnDailyGoal";
  static String isFirst = pkgName + "ttsIsFirstIntro";
  static String keyHeight = pkgName + "ttsHeightKeys";
  static String keyWeight = pkgName + "ttsWeightKeys";
  static String keyAge = pkgName + "ttsAgeKeys";
  static String keyIsMale = pkgName + "ttsGenderKeys";
  static String isKg = pkgName + "ttsIsKgUNit";
  static String isSoundOn = pkgName + "soundIsMutes";
  static String isTtsOn = pkgName + "ttsIsMutes";
  static String userDetail = pkgName + "userDetail";
  static String isIntro = pkgName + "isIntro";
  static String signIn = pkgName + "signIn";
  static String session = pkgName + "session";
  static String userPlan = pkgName + "userPlan";
  static String isCustomPlanId = "${pkgName}isCustomPlanId";
  static String isCustomPlanDescription = "${pkgName}isCustomPlanDescription";
  static String isCustomPlanName = "${pkgName}isCustomPlanName";
  static String isFirstSignUp = "${pkgName}isFirstSignUp";
  static String isSetting = "${pkgName}isSetting";

  static setFirstSignUp(bool firstSignup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isFirstSignUp, firstSignup);
  }

  static getFirstSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstSignUp) ?? true;
  }

  static setIsSetting(bool setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSetting, setting);
  }

  static getIsSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSetting) ?? false;
  }

  static setCustomPlanName(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanName, s);
  }

  static getCustomPlanName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanName) ?? "";
  }

  static setCustomPlanDescription(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanDescription, s);
  }

  static getCustomPlanDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanDescription) ?? "";
  }

  static setCustomPlanId(String s) async {
    print("session----$s");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanId, s);
  }

  static getCustomPlanId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanId) ?? "";
  }

  static setSession(String s) async {
    print("session----$s");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(session, s);
  }

  static getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(session) ?? "";
  }

  static setIsSignIn(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(signIn, isFav);
  }

  static getIsSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(signIn) ?? false;
  }

  static setUserDetail(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userDetail, s);
  }

  static getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDetail) ?? '';
  }

  addRestTime(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(trainingRest, sizes);
  }

  addReminderTime(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindTime, sizes);
  }

  static setIsIntro(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isIntro, sizes);
  }

  static getIsIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isIntro) ?? true;
    return intValue;
  }

  addReminderDays(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindDays, sizes);
  }

  addReminderAmPm(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindAmPm, sizes);
  }

  addHeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyHeight, sizes);
  }

  addWeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyWeight, sizes);
  }

  addAge(String age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAge, age);
  }

  addDailyCalGoal(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(getDailyGoal, sizes);
  }

  setIsFirst(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirst, sizes);
  }

  setIsKgUnit(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isKg, sizes);
  }

  setIsReminderOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reminderOn, sizes);
  }

  setIsMale(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsMale, sizes);
  }

  addBurnCalorie(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(calorieBurn, sizes);
  }

  getRestTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(trainingRest) ?? 10;
    return intValue;
  }

  getHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble(keyHeight) ?? 100;
    return intValue;
  }

  getRemindTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindTime) ?? "5:30";
    return intValue;
  }

  getRemindDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindDays) ?? "";
    return intValue;
  }

  getRemindAmPm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindAmPm) ?? "AM";
    return intValue;
  }

  getWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble(keyWeight) ?? 50;
    return intValue;
  }

  getAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(keyAge) ?? "25";
    return intValue;
  }

  getDailyCalGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt(getDailyGoal) ?? 200;
    return intValue;
  }

  getIsFirstIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isFirst) ?? true;
    return intValue;
  }

  getIsReminderOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(reminderOn) ?? true;
    return intValue;
  }

  getIsMute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isTtsOn) ?? true;
    return intValue;
  }

  getIsSoundOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isSoundOn) ?? false;
    return intValue;
  }

  setIsMute(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isTtsOn, sizes);
  }

  setIsSoundOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isSoundOn, sizes);
  }

  getIsKgUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isKg) ?? true;
    return intValue;
  }

  getIsMale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(keyIsMale) ?? true;
    return intValue;
  }

  getBurnCalorie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt(calorieBurn) ?? 0;
    return intValue;
  }
}
