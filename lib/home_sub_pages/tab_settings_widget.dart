import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import '../ChangePasswordPage.dart';
import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../HomeWidget.dart';
import '../PrefData.dart';
import '../ProfilePage.dart';
import '../SignInPage.dart';
import '../SizeConfig.dart';
import '../WidgetHealthInfo.dart';
import '../Widgets.dart';
import '../generated/l10n.dart';
import '../onlineData/ConstantUrl.dart';
import '../online_models/LogOutModel.dart';
import '../online_models/UserDetail.dart';
import 'package:http/http.dart' as http;

class TabSettings extends StatefulWidget {
  @override
  _TabSettings createState() => _TabSettings();
}

class _TabSettings extends State<TabSettings> {
  int getRestTime = 0;
  String dropdownValue = '10';
  final myController = TextEditingController();
  String remindTime = "05:30";
  int orgRemindHour = 5;
  int orgRemindMinute = 30;
  int orgRemindSec = 0;
  String remindAmPm = "AM";
  String remindDays = "";
  bool isScreenOn = false;
  bool isSwitchOn = false;
  String loginType = "0";

  List<String> spinnerItems = ['10', '20', '30', '40', '50', '60'];
  List<String> caloriesList = ['100', '200', '300', '400', '500', '600'];

  Future<dynamic> showUnitDialog(BuildContext contexts) async {
    bool isKg = await PrefData().getIsKgUnit();

    int _currentIndex = (isKg) ? 0 : 1;

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Change Unit System", Colors.black87, 1),
              content: Container(
                width: 400,
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ringTone.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: _currentIndex,
                      title: getSmallNormalTextWithMaxLine(
                          ringTone[index], Colors.black87, 1),
                      onChanged: (value) {
                        setState(() {
                          _currentIndex = value as int;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    PrefData().setIsKgUnit((_currentIndex == 0) ? true : false);
                    Navigator.pop(context, ringTone[_currentIndex]);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      getIsKg();
      setState(() {});
    });
  }

  Future<void> _isScreenOn() async {
    isScreenOn = await Wakelock.enabled;
    remindTime = await PrefData().getRemindTime();
    remindAmPm = await PrefData().getRemindAmPm();
    isSwitchOn = await PrefData().getIsReminderOn();
    remindDays = await PrefData().getRemindDays();

    setState(() {});
  }

  int cal = 200;

  Future<void> _getDailyCal() async {
    cal = await PrefData().getDailyCalGoal();
    setState(() {
      myController.text = "$cal";
    });
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    try {
      Location getLocal =
      tz.getLocation(timeZoneName!.replaceAll("Calcutta", "Kolkata"));
      tz.setLocalLocation(getLocal);
    } catch (e) {
      print(e);
      Location getLocal = tz.getLocation(Constants.defTimeZoneName);
      tz.setLocalLocation(getLocal);
    }
  }

  bool isKg = true;

  @override
  void initState() {
    _configureLocalTimeZone();
    _getDailyCal();
    _getRestTimes();
    _isScreenOn();
    getIsKg();

    super.initState();
  }

  bool isLogin = false;

  void getIsKg() async {
    isKg = await PrefData().getIsKgUnit();
    isLogin = await ConstantUrl.isLogin();
    if(isLogin==true){
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      loginType = userDetail.loginType??"-1";
    }
    setState(() {});
  }

  _getRestTimes() async {
    getRestTime = await PrefData().getRestTime();
    dropdownValue = "$getRestTime";
  }

  openReminderDialog() async {
    double dialogWidth = 300;
    var checkDialogWidth = dialogWidth - 30;
    List<String> selectedList = [];
    List<String> selectedOrgDayList = [];
    remindDays = await PrefData().getRemindDays();
    if (remindDays.isNotEmpty) {
      var getData = jsonDecode(remindDays);
      selectedList = new List<String>.from(getData);
    }
    List<String> daysDateTimeList = [
      DateTime.sunday.toString(),
      DateTime.monday.toString(),
      DateTime.tuesday.toString(),
      DateTime.wednesday.toString(),
      DateTime.thursday.toString(),
      DateTime.friday.toString(),
      DateTime.saturday.toString()
    ];

    List<String> daysList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    if (selectedList.length > 0) {
      selectedOrgDayList = [];
      selectedList.forEach((element) {
        int i = daysList.indexOf(element);
        selectedOrgDayList.add(daysDateTimeList[i]);
      });
    }

    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: dialogWidth,
                  padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Set Workout Reminder", Colors.black, 1,
                          TextAlign.start, FontWeight.normal, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                orgRemindHour = value!.hour;
                                orgRemindMinute = value.minute;
                                String amPm = "PM";
                                if (value.period == DayPeriod.am) {
                                  amPm = "AM";
                                }
                                String time =
                                    (value.hourOfPeriod < 10 ? "0" : "") +
                                        value.hourOfPeriod.toString() +
                                        ":" +
                                        (value.minute < 10 ? "0" : "") +
                                        value.minute.toString();
                                setState(() {});
                                remindTime = time;
                                remindAmPm = amPm;
                                return value;
                              });
                            },
                            child: getLargeBoldTextWithMaxLine(
                                remindTime, Colors.black87, 1),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: getSmallNormalText(
                                remindAmPm, Colors.black87, TextAlign.start),
                            flex: 1,
                          ),
                          Switch(
                            value: isSwitchOn,
                            onChanged: (value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: double.infinity,
                        height: (checkDialogWidth / 7),
                        alignment: Alignment.center,
                        child: ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String getName = daysList[index];
                            bool isSelected = selectedList.contains(getName);
                            return GestureDetector(
                              onTap: () {
                                if (isSwitchOn) {
                                  setState(() {
                                    if (selectedList.contains(getName)) {
                                      selectedList.remove(getName);
                                      selectedOrgDayList.remove(
                                          daysDateTimeList[index].toString());
                                    } else {
                                      selectedList.add(getName);
                                      selectedOrgDayList.add(
                                          daysDateTimeList[index].toString());
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(1),
                                width: (checkDialogWidth / 7) - 2,
                                height: (checkDialogWidth / 7) - 2,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? accentColor
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: getExtraSmallNormalTextWithMaxLine(
                                      "${getName[0]}",
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      1,
                                      TextAlign.center),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      style: TextButton.styleFrom(backgroundColor: lightPink),
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (selectedList.length > 0) {
                          String s = jsonEncode(selectedList);
                          PrefData().addReminderDays(s);
                        }
                        PrefData().setIsReminderOn(isSwitchOn);
                        PrefData().addReminderTime(remindTime);
                        PrefData().addReminderAmPm(remindAmPm);
                        _cancelAllNotifications();
                        if (selectedOrgDayList.length > 0) {
                          selectedOrgDayList.forEach((element) {
                            _scheduleWeeklyMondayTenAMNotification(
                                int.parse(element));
                          });
                        }
                        Navigator.pop(context);
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  TZDateTime _nextInstanceOfMondayTenAM(int day) {
    TZDateTime scheduledDate = _nextInstanceOfTenAM();
    print("schedule===${scheduledDate.weekday}--${DateTime.monday}");
    while (scheduledDate.weekday != day) {
      print("schedule123===${scheduledDate.weekday}--${DateTime.monday}");
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> _scheduleWeeklyMondayTenAMNotification(int day) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        day,
        'Yoga Reminder',
        'Daily Workout Reminder',
        _nextInstanceOfMondayTenAM(day),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'com.gws.yogagogo', 'com.gws.yogagogo channel',
              channelDescription: 'Workout Reminder'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  TZDateTime _nextInstanceOfTenAM() {
    final TZDateTime now = tz.TZDateTime.now(tz.local);
    TZDateTime scheduledDate = TZDateTime(
        tz.local, now.year, now.month, now.day, orgRemindHour, orgRemindMinute);
    print(
        "schedule===$scheduledDate--$now--${scheduledDate.isBefore(now)}--$orgRemindHour===$orgRemindMinute");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  openAlertBox() {
    bool isValidate = true;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: 300.0,
                  padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Set Your Daily Goal", Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  errorText: !isValidate
                                      ? "kcal cannot be smaller than ${myController.text}?"
                                      : null,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  )),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: accentColor,
                                  fontFamily: Constants.fontsFamily),
                              controller: myController,
                            ),
                            flex: 1,
                          ),
                          getMediumNormalTextWithMaxLine(
                              "Kcal", Colors.grey, 1, TextAlign.start)
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                    // color: lightPink,
                      style: TextButton.styleFrom(backgroundColor: lightPink),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          double val = double.parse(myController.text);
                          if (val > 5000) {
                            setState(() {
                              isValidate = false;
                            });
                          } else {
                            isValidate = true;
                            PrefData().addDailyCalGoal(val.toInt());
                            _getDailyCal();
                          }
                          Navigator.pop(context);
                        } else {
                          _getDailyCal();
                          Navigator.pop(context);
                        }
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  Future<void> share() async {
    String share = "${S.of(context).app_name}\n${Constants.getAppLink()}";
    // await Share.share(
    //   share,
    // );
    await FlutterShare.share(
      title: 'share',
      text: share,
    );
  }

  void showDailyCaloriesTime() async {
    String value = cal.toString();

    print("value---$value");

    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    double height = ConstantWidget.getDefaultButtonSize(context);
    int _crossAxisCount = 2;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    double radius = ConstantWidget.getPercentSize(height, 20);

    double _crossAxisSpacing = ConstantWidget.getScreenPercentSize(context, 2);
    var widthItem =
        (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
            _crossAxisCount;

    double _aspectRatio = widthItem / height;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 42,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Daily Goal',
                          Colors.black,
                          ConstantWidget.getScreenPercentSize(context, 2.5),
                          FontWeight.bold,
                          TextAlign.start,
                          1),
                    ),
                    getDefaultButton(context, function: () {
                      Navigator.pop(context);
                    })
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
                GridView.count(
                  crossAxisCount: _crossAxisCount,
                  childAspectRatio: _aspectRatio,
                  shrinkWrap: true,
                  crossAxisSpacing: _crossAxisSpacing,
                  mainAxisSpacing: _crossAxisSpacing,
                  primary: false,
                  children: List.generate(caloriesList.length, (index) {
                    return GestureDetector(
                      child: Container(
                        height: height,
                        // margin: EdgeInsets.symmetric(
                        //     vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),

                        decoration: getDefaultDecoration(
                            radius: radius,
                            borderColor: value == caloriesList[index]
                                ? accentColor
                                : Colors.grey.shade300),

                        child: Center(
                            child: ConstantWidget.getDefaultTextWidget(
                                '${caloriesList[index]} Calories',
                                TextAlign.center,
                                FontWeight.w500,
                                fontSize,
                                value == spinnerItems[index]
                                    ? accentColor
                                    : subTextColor)),
                      ),
                      onTap: () {
                        setState(() {
                          value = caloriesList[index];
                        });
                      },
                    );
                  }),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
                ConstantWidget.getButtonWidget(context, "Save", accentColor,
                        () {
                      if (value.isNotEmpty) {
                        double val = double.parse(value);
                        if (val > 5000) {
                          setState(() {});
                        } else {
                          PrefData().addDailyCalGoal(val.toInt());
                        }
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
              ],
            );
          }),
        );
      },
    ).then((value) => _getDailyCal());
  }

  void showTrainingTime() async {
    String value = dropdownValue;

    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    double height = ConstantWidget.getDefaultButtonSize(context);
    int _crossAxisCount = 2;
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    double radius = ConstantWidget.getPercentSize(height, 20);

    double _crossAxisSpacing = ConstantWidget.getScreenPercentSize(context, 2);
    var widthItem =
        (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
            _crossAxisCount;

    double _aspectRatio = widthItem / height;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 44,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              // padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: margin),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ConstantWidget.getCustomTextWidget(
                            'Select Time',
                            Colors.black,
                            ConstantWidget.getScreenPercentSize(context, 2.5),
                            FontWeight.bold,
                            TextAlign.start,
                            1),
                      ),
                      getDefaultButton(context, function: () {
                        Navigator.pop(context);
                      })
                    ],
                  ),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
                GridView.count(
                  crossAxisCount: _crossAxisCount,
                  childAspectRatio: _aspectRatio,
                  shrinkWrap: true,
                  crossAxisSpacing: _crossAxisSpacing,
                  mainAxisSpacing: _crossAxisSpacing,
                  primary: false,
                  padding: EdgeInsets.symmetric(
                      horizontal: margin, vertical: (margin / 2)),
                  children: List.generate(spinnerItems.length, (index) {
                    return GestureDetector(
                      child: Container(
                        height: height,
                        decoration: getDefaultDecoration(
                            radius: radius,
                            borderColor: value == spinnerItems[index]
                                ? accentColor
                                : Colors.grey.shade300),
                        child: Center(
                            child: ConstantWidget.getDefaultTextWidget(
                                '${spinnerItems[index]} Seconds',
                                TextAlign.center,
                                FontWeight.w500,
                                fontSize,
                                value == spinnerItems[index]
                                    ? accentColor
                                    : subTextColor)),
                      ),
                      onTap: () {
                        setState(() {
                          value = spinnerItems[index];
                        });
                      },
                    );
                  }),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: margin),
                  child: ConstantWidget.getButtonWidget(
                      context, "Save", accentColor, () {
                    setState(() {
                      PrefData().addRestTime(int.parse(value));
                      dropdownValue = value;
                    });
                    Navigator.of(context).pop();
                  }),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
              ],
            );
          }),
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showSoundDialog() async {
    bool isSwitched = await PrefData().getIsMute();
    bool isSwitchedSound = await PrefData().getIsSoundOn();

    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 40,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Sound',
                          Colors.black,
                          ConstantWidget.getScreenPercentSize(context, 2.5),
                          FontWeight.bold,
                          TextAlign.start,
                          1),
                    ),
                    getDefaultButton(context, function: () {
                      Navigator.pop(context);
                    })
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5)),
                ConstantWidget.getShadowWidget(
                    widget: Row(
                      children: [
                        SvgPicture.asset(
                          Constants.assetsImagePath + 'volume.svg',
                          height:
                          ConstantWidget.getScreenPercentSize(context, 3),
                        ),
                        SizedBox(
                          width: margin / 2,
                        ),
                        Expanded(
                          child: ConstantWidget.getCustomTextWidget(
                              'TTS Voice',
                              textColor,
                              ConstantWidget.getScreenPercentSize(context, 2),
                              FontWeight.w500,
                              TextAlign.start,
                              1),
                          flex: 1,
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            trackColor: bgColor,
                            thumbColor: Colors.white,
                            activeColor: accentColor,
                          ),
                        )
                      ],
                    ),
                    radius: ConstantWidget.getScreenPercentSize(context, 2),
                    leftPadding: margin,
                    rightPadding: margin,
                    bottomPadding: (margin / 2),
                    topPadding: (margin / 2)),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 2.5)),
                ConstantWidget.getShadowWidget(
                    widget: Row(
                      children: [
                        SvgPicture.asset(
                          Constants.assetsImagePath + 'volume.svg',
                          height:
                          ConstantWidget.getScreenPercentSize(context, 3),
                        ),
                        SizedBox(
                          width: margin / 2,
                        ),
                        Expanded(
                          child: ConstantWidget.getCustomTextWidget(
                              'Sound',
                              textColor,
                              ConstantWidget.getScreenPercentSize(context, 2),
                              FontWeight.w500,
                              TextAlign.start,
                              1),
                          flex: 1,
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: isSwitchedSound,
                            onChanged: (value) {
                              setState(() {
                                isSwitchedSound = value;
                              });
                            },
                            trackColor: bgColor,
                            thumbColor: Colors.white,
                            activeColor: accentColor,
                          ),
                        )
                      ],
                    ),
                    radius: ConstantWidget.getScreenPercentSize(context, 2),
                    leftPadding: margin,
                    rightPadding: margin,
                    topPadding: (margin / 2),
                    bottomPadding: (margin / 2)),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 1.3),
                ),
                ConstantWidget.getButtonWidget(context, 'Save', blueButton,
                        () async {
                      PrefData().setIsMute(isSwitched);
                      PrefData().setIsSoundOn(isSwitchedSound);
                      Navigator.pop(context);
                    }),
                SizedBox(
                  height: margin,
                ),
              ],
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    initializeScreenSize(context);
    double textMargin = SizeConfig.safeBlockHorizontal! * 2.5;

    Widget divider = Container(
      height: 1,
      color: cellColor,
    );
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: bgDarkWhite,
        padding: EdgeInsets.symmetric(horizontal: (textMargin * 1.3)),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Visibility(
            visible: isLogin,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: getSettingTabTitle(context, 'Profile'.toUpperCase()),
            ),
          ),
          Visibility(
            visible: isLogin,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: textMargin),
                  child: Row(
                    children: [
                      Expanded(
                        child: getSettingSingleLineText(
                            context, 'User.svg', "Profile"),
                        flex: 1,
                      ),
                    ],
                  )),
            ),
          ),
          Visibility(child: divider, visible: isLogin && loginType=="0"),
          Visibility(
            visible: isLogin && loginType=="0",
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: textMargin),
                  child: Row(
                    children: [
                      Expanded(
                        child: getSettingSingleLineText(
                            context, 'lock-svgrepo-com.svg', "Change Password"),
                        flex: 1,
                      ),
                    ],
                  )),
            ),
          ),
          Visibility(child: divider, visible: isLogin),
          SizedBox(
            height: (textMargin / 2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: textMargin),
            child: getSettingTabTitle(context, S.of(context).workout),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Cup.svg', "Training Rest",
                        isSubContent: true),
                    flex: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      showTrainingTime();
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: textColor,
                        ),
                        iconSize:
                        ConstantWidget.getScreenPercentSize(context, 2.5),
                        elevation: 0,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: ConstantWidget.getScreenPercentSize(
                                context, 1.9),
                            fontFamily: Constants.fontsFamily),
                        underline: Container(
                          height: 0,
                          color: Colors.black12,
                        ),
                        onChanged: (value) {
                          setState(() {
                            PrefData().addRestTime(int.parse(value!));
                            dropdownValue = value;
                          });
                        },
                        onTap: () {},
                        items: spinnerItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value + " Sec"),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              )),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Goal.svg', "Daily Goal",
                        isSubContent: true),
                    flex: 1,
                  ),
                  getCustomText(
                      "${myController.text} kcal",
                      Colors.green,
                      1,
                      TextAlign.start,
                      FontWeight.w600,
                      ConstantWidget.getScreenPercentSize(context, 1.9))
                ],
              ),
            ),
            onTap: () {
              showDailyCaloriesTime();
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'volume.svg', "Sound Options"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () async {
              showSoundDialog();
            },
          ),
          divider,
          SizedBox(
            height: (textMargin / 2),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: textMargin),
            child: getSettingTabTitle(context, "GENERAL"),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: getSettingSingleLineText(
                  context, 'Clock.svg', "Set Workout Reminder",
                  content: remindTime + " " + remindAmPm),
            ),
            onTap: () {
              openReminderDialog();
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Info.svg', "Health Info"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new HealthInfo(),
                ),
              );
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: getSettingSingleLineText(
                  context, 'CPU.svg', "Change Unit System",
                  content: (isKg) ? ringTone[0] : ringTone[1]),
            ),
            onTap: () {
              showUnitDialog(context);
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Mobile.svg', "Keep Screen On",
                        isSubContent: true),
                    flex: 1,
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      value: isScreenOn,
                      onChanged: (value) {
                        setState(() {
                          isScreenOn = value;
                          Wakelock.toggle(enable: isScreenOn);
                        });
                      },
                      trackColor: bgColor,
                      thumbColor: Colors.white,
                      activeColor: accentColor,
                    ),
                  )
                ],
              ),
            ),
            onTap: () {},
          ),
          divider,
          SizedBox(
            height: (textMargin / 2),
          ),
          // FutureBuilder<bool>(
          //   future: ConstantWidget.isPlanValid(),
          //   builder: (context, snapshot) {
          //     if (snapshot.data != null && !snapshot.data!) {
          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           ConstantWidget.getVerSpace(20.h),
          //           getCustomText('Subscribe', textColor, 1, TextAlign.start,
          //               FontWeight.w600, 19.sp),
          //           ConstantWidget.getVerSpace(12.h),
          //           GestureDetector(
          //             onTap: () {
          //               Get.to(InAppPurchase(
          //                 isClose: () {
          //                   Future.delayed(Duration(seconds: 1), () {
          //                     setState(() {});
          //                   });
          //                 },
          //               ))!
          //                   .then((value) => setState);
          //             },
          //             child: Container(
          //                 padding: EdgeInsets.symmetric(vertical: 14.h),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     getHomeProWidget(
          //                         context: context, verSpace: 0, horSpace: 0),
          //                     SizedBox(
          //                       width: 15.w,
          //                     ),
          //                     Expanded(
          //                       child: getCustomText(
          //                           "Subscribe (Remove Ads)",
          //                           textColor,
          //                           1,
          //                           TextAlign.start,
          //                           FontWeight.w400,
          //                           17.sp),
          //                       flex: 1,
          //                     ),
          //                     Icon(
          //                       Icons.navigate_next,
          //                       color: textColor,
          //                       size: ConstantWidget.getScreenPercentSize(
          //                           context, 3),
          //                     )
          //                   ],
          //                 )),
          //           ),
          //         ],
          //       );
          //     } else {
          //       return Container(
          //         height: 0,
          //         width: 0,
          //       );
          //     }
          //   },
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: textMargin),
            child: getSettingTabTitle(context, "SUPPORT US"),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Share_setting.svg', "Share With Friends"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              share();
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'Message-5.svg', "Feedback"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () async {
              final MailOptions mailOptions = MailOptions(
                body: 'Feedback',
                subject: 'Yoga Workout',
                recipients: ['demo@gmail.com'],
                isHTML: true,
              );
              await FlutterMailer.send(mailOptions);
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'star-svgrepo-com.svg', "Rate Us"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              LaunchReview.launch(
                  androidAppId: "com.gws.yogagogo", iOSAppId: "6443448709");
            },
          ),
          divider,
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        context, 'security-svgrepo-com.svg', "Privacy Policy"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              _launchURL();
            },
          ),
          divider,
          SizedBox(
            height: (textMargin / 2),
          ),
          ConstantWidget.getButtonWidget(
              context, isLogin ? "Logout" : "Log In", accentColor, () {
            if (isLogin) {
              checkNetwork();
            } else {
              PrefData.setIsSetting(true);
              ConstantUrl.sendLoginPage(context, function: () {
                getIsKg();

                controller.onChange(0.obs);
              }, argument: () {
                controller.onChange(0.obs);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeWidget()));
              });
            }
          })
        ]));
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      logOut();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> logOut() async {
    String deviceId = await ConstantUrl.getDeviceId();

    String s = await PrefData.getUserDetail();

    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      String session = await PrefData.getSession();

      Map data = {
        ConstantUrl.paramSession: session,
        ConstantUrl.paramUserId: userDetail.userId,
        ConstantUrl.paramDeviceId: deviceId,
      };

      print(
          "deviceId------$session======${userDetail.userId}--------${deviceId}");

      final response =
      await http.post(Uri.parse(ConstantUrl.logOutUrl), body: data);
      if (response.statusCode == 200) {
        // await progressDialog.hide();

        print("res--" + response.body.toString());

        Map<String, dynamic> map = json.decode(response.body);

        LogoutModel user = LogoutModel.fromJson(map);

        if (user.data!.success == 1) {
          PrefData.setIsSignIn(false);
          PrefData.setSession("");
          PrefData.setUserDetail("");

          getIsKg();
          ConstantUrl.showToast('Log out', context);

          ConstantUrl.sendLoginPage(
            context,
            function: () {},
          );
        } else {
          ConstantUrl.showToast('Please Try Again', context);
        }

        print("value-----failed");
      }
    }
  }

  _launchURL() async {
    await launchUrl(Uri.parse(ConstantUrl.privacyURL));
  }
}
