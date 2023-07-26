import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/Subscription/SubscriptionWidget.dart';
import 'package:flutter_yoga_workout_4_all_new/home_sub_pages/tab_workout_widget.dart';
import 'package:flutter_yoga_workout_4_all_new/util/CustomAnimatedBottomBar.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';

import 'package:path_provider/path_provider.dart';
import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';
import 'controller/home_controller.dart';
import 'controller/subscription_controller.dart';
import 'custom_workout/custom_workout.dart';
import 'generated/l10n.dart';
import 'home_sub_pages/tab_activity_widget.dart';
import 'home_sub_pages/tab_myplan_widget.dart';
import 'home_sub_pages/tab_settings_widget.dart';

import 'models/ModelDummySend.dart';
import 'onlineData/ConstantUrl.dart';
import 'online_models/UserDetail.dart';

const MethodChannel platform = MethodChannel('dexterx.dev/workout');

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeWidget();
}

class Destination {
  final String title;
  final String toolbarTitle;
  final IconData icon;
  final MaterialColor color;

  const Destination(this.title, this.toolbarTitle, this.icon, this.color);
}

Future<String> writeImageToStorage(Uint8List feedbackScreenshot) async {
  final Directory output = await getTemporaryDirectory();
  final String screenshotFilePath = '${output.path}/feedback.png';
  final File screenshotFile = File(screenshotFilePath);
  await screenshotFile.writeAsBytes(feedbackScreenshot);
  return screenshotFilePath;
}

List<String> ringTone = ['Meters and kilograms', 'Pounds,Feet and inches'];

void sendToWorkoutList(BuildContext context, ModelDummySend dummySend) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return WidgetWorkoutExerciseList(dummySend);
    },
  ));
}

HomeController controller = Get.put(HomeController());

class _HomeWidget extends State<HomeWidget> {
  List<Destination> allDestinations = [];
  UserDetail? userDetail;

  static List<Widget> _widgetOptions = <Widget>[
    //TabHome(),
    TabMyPlan(),
    //TabDiscover(),
    TabWorkout(),
    CustomWorkoutScreen(),
    TabActivity(),
    TabSettings()
  ];

  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  @override
  void initState() {
    super.initState();
    print("home===true");
    Future.delayed(Duration.zero, () {
      controller.onChange(0.obs);
    });
    checkLoginFirst();
    // checkProStatus();
    getUserDetailData();
    setStatusBarColor(bgDarkWhite);
  }

  Future<void> checkLoginFirst() async {
    print("set==treue");

    //

    setState(() {});

    print("set==treue12121212");

    Future.delayed(Duration(seconds: 1), () {
      _widgetOptions = <Widget>[
        //TabHome(),
        TabMyPlan(),
        //TabDiscover(),
        TabWorkout(),
        CustomWorkoutScreen(),
        TabActivity(),
        TabSettings()
      ];

      setState(() {});
    });
  }

  getUserDetailData() async {
    userDetail = await ConstantUrl.getUserDetail();
  }

  String getUserDetail() {
    if (userDetail != null && userDetail!.firstName != null)
      return '${userDetail!.firstName![0].toUpperCase()}${userDetail!.firstName!.substring(1)}' +
          ": 30 Day Body\nTransformation";
    else
      return "Easy Fit: 30 Day Body\nTransformation";
  }

  @override
  void didChangeDependencies() {
    allDestinations = <Destination>[
      Destination(
          S.of(context).home,
          "30 Day Body\nTransformation", //S.of(context).yogaWorkout,
          CupertinoIcons.home,
          Colors.teal),
      Destination(S.of(context).discover, S.of(context).workouts,
          CupertinoIcons.search, Colors.cyan),
      Destination(
          "Custom Workout", "Custom Workout", CupertinoIcons.add, Colors.cyan),
      Destination('Analytics', S.of(context).activity,
          CupertinoIcons.chart_bar_square, Colors.orange),
      Destination(S.of(context).settings, S.of(context).settings,
          Icons.settings, Colors.blue)
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(bgDarkWhite);
    initializeScreenSize(context);
    //refreshUser();
    return WillPopScope(
        // child: GetBuilder<HomeController>(
        //   init: HomeController(),
        //   builder: (controller) => Scaffold(
        //     appBar: new AppBar(
        //       elevation: 0,
        //       automaticallyImplyLeading: false,
        //       backgroundColor: bgDarkWhite,
        //       systemOverlayStyle: SystemUiOverlayStyle(
        //           systemNavigationBarColor: bgDarkWhite,
        //           statusBarColor: bgDarkWhite),
        //       title: getCustomText(
        //           allDestinations[controller.index.value].toolbarTitle,
        //           accentColor,
        //           1,
        //           TextAlign.start,
        //           FontWeight.bold,
        //           ConstantWidget.getScreenPercentSize(context, 2.5)),
        //       actions: [
        //
        //         controller.index.value == 0
        //         ?GestureDetector(
        //           onTap: () {
        //             Get.to(InAppPurchase())!
        //                 .then((value) {
        //               Future.delayed(Duration(seconds: 1),(){
        //                 checkLoginFirst();
        //               });
        //             });
        //           },
        //           child: getAssetImage("crown.png",
        //               height: 30.h, width: 30.h)
        //               .paddingOnly(right: 20.h),
        //         )
        //             // ? FutureBuilder<bool>(
        //             //     future: Preferences.preferences.getBool(
        //             //         key: PrefernceKey.isProUser, defValue: false),
        //             //     builder: (context, snapshot) {
        //             //       if (snapshot.data != null && !snapshot.data!) {
        //             //         return GestureDetector(
        //             //           onTap: () {
        //             //             Get.to(InAppPurchase())!
        //             //                 .then((value) {
        //             //                   setState(() {
        //             //
        //             //                   });
        //             //             });
        //             //           },
        //             //           child: getAssetImage("crown.png",
        //             //                   height: 30.h, width: 30.h)
        //             //               .paddingOnly(right: 20.h),
        //             //         );
        //             //       } else {
        //             //         return Container(
        //             //           height: 0,
        //             //           width: 0,
        //             //         );
        //             //       }
        //             //     },
        //             //   )
        //             : SizedBox(),
        //       ],
        //     ),
        //     resizeToAvoidBottomInset: false,
        //     body: SafeArea(
        //       child: _widgetOptions[controller.index.value],
        //     ),
        //     bottomNavigationBar: _buildBottomBar(controller),
        //   ),
        // ),

        child: Obx(() => Scaffold(
              appBar: new AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: bgDarkWhite,
                systemOverlayStyle: SystemUiOverlayStyle(
                    systemNavigationBarColor: bgDarkWhite,
                    statusBarColor: bgDarkWhite),
                title: getCustomText(
                    controller.index.value == 0
                        ? getUserDetail()
                        : allDestinations[controller.index.value].toolbarTitle,
                    accentColor,
                    controller.index.value == 0 ? 2 : 1,
                    TextAlign.start,
                    FontWeight.bold,
                    ConstantWidget.getScreenPercentSize(context, 2.5)),
                actions: [
                  controller.index.value == 0
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return SubscriptionWidget(
                                  isClose: () {
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      checkLoginFirst();
                                    });
                                  },
                                );
                                // return InAppPurchase(isClose: (){
                                //   Future.delayed(Duration(milliseconds: 200), () {
                                //     checkLoginFirst();
                                //   });
                                // },);
                              },
                            )).then((value) {
                              Future.delayed(Duration(milliseconds: 200), () {
                                checkLoginFirst();
                              });
                            });
                          },
                          child: getAssetImage("crown.png",
                                  height: 30.h, width: 30.h)
                              .paddingOnly(right: 20.h),
                        )
                      : SizedBox(),
                ],
              ),
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: _widgetOptions[controller.index.value],
              ),
              bottomNavigationBar: _buildBottomBar(controller),
            )),
        onWillPop: () async {
          if (controller.index.value != 0) {
            // setState(() {
            //   _currentIndex = 0;
            // });
            controller.onChange(0.obs);
          } else {
            Future.delayed(const Duration(milliseconds: 100), () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            });
          }
          return false;
        });
  }

  Widget _buildBottomBar(HomeController controller) {
    final _inactiveColor = textColor;
    final _activeColor = accentColor;

    double height = ConstantWidget.getScreenPercentSize(context, 9); //7.5
    double iconHeight = ConstantWidget.getPercentSize(height, 22); //28
    return CustomAnimatedBottomBar(
      containerHeight: height,
      backgroundColor: bgDarkWhite,
      selectedIndex: controller.index.value,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => controller.onChange(index.obs),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          title: 'My Plan',
          activeColor: _activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
          iconSize: iconHeight,
          imageName: "tab_myplan.svg",
        ),
        BottomNavyBarItem(
          title: 'Workout',
          activeColor: _activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
          iconSize: iconHeight,
          imageName: "tab_workout.svg",
        ),
        BottomNavyBarItem(
          title: 'Favorite',
          activeColor: _activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
          iconSize: iconHeight,
          imageName: "tab_favorite.svg",
        ),
        BottomNavyBarItem(
          title: 'Progress',
          activeColor: _activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
          iconSize: iconHeight,
          imageName: "tab_progress.svg",
        ),
        BottomNavyBarItem(
          title: 'Settings',
          activeColor: _activeColor,
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
          iconSize: iconHeight,
          imageName: "tab_setting2.svg",
        ),
      ],
    );
  }

  @override
  void onBillingError(error) {
    // TODO: implement onBillingError
  }

  @override
  void onCancelPlan() {
    // TODO: implement onBillingError
  }

  @override
  void onLoaded(bool initialized) {
    // TODO: implement onLoaded
  }

  @override
  void onPending(PurchaseDetails product) {
    // TODO: implement onPending
  }

  @override
  void onPrefValChange(bool value, {String? planId}) async {
    // TODO: implement onPrefValChange

    // if (value) {
    //   await Preferences.preferences
    //       .saveBool(key: PrefernceKey.isProUser, value: true);
    //   await Preferences.preferences.saveString(
    //       key: PrefernceKey.currentProPlan,
    //       value: planId);
    // } else {
    //   await Preferences.preferences.saveBool(
    //       key: PrefernceKey.isProUser, value: false);
    //   await Preferences.preferences.clearPrefValue(PrefernceKey.currentProPlan);
    // }
  }

  @override
  void onPlanCancel() {
    // checkProStatus();
    // TODO: implement onPlanCancel
  }

  @override
  void onSuccessPurchase(PurchaseDetails? product) {
    // checkProStatus();
    // TODO: implement onSuccessPurchase
  }
}
