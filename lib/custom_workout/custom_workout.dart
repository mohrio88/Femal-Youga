import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/custom_workout/selected_list.dart';



import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../PrefData.dart';
import '../Widgets.dart';
import '../dialog/add_workout_dialog.dart';
import '../models/ModelDummySend.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/model_delete_custom_plan.dart';
import '../online_models/model_get_custom_plan.dart';

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen>
    with TickerProviderStateMixin {
  double appBarHeight = 200.h;

  var radius = 22.h;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ConstantWidget.getVerSpace(30.h),
          buildCreatePlan(context),
          ConstantWidget.getVerSpace(60.h),
          buildWorkoutList(),
        ],
      ),
    );
  }

  // HomeController homeController = Get.find();

  Widget buildAppBar() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          GestureDetector(
              child: getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
              onTap: () {
                // homeController.onChange(0.obs);
              }),
          getHorSpace(12.sp),
          ConstantWidget.getCustomText("Custom Workout", Colors.black, 1,
              TextAlign.start, FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  Expanded buildWorkoutList() {
    return Expanded(
      flex: 1,
      child: FutureBuilder<ModelGetCustomPlan?>(
        future: getCustomPlan(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            ModelGetCustomPlan? modelGetCustomPlan = snapshot.data;

            if (modelGetCustomPlan!.data.success == 1) {
              List<Customplan>? customPlanList =
                  modelGetCustomPlan.data.customplan;
              return ListView.builder(
                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                primary: true,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: customPlanList.length,
                itemBuilder: (context, index) {
                  Customplan customplan = customPlanList[index];

                  ModelDummySend dummySend = new ModelDummySend(
                      customplan.customPlanId,
                      customplan.name,
                      ConstantUrl.urlGetWorkoutExercise,
                      ConstantUrl.varCatId,
                      getCellColor(index),
                      "ssds",
                      true,
                      customplan.description,
                      CUSTOM_WORKOUT);

                  return GestureDetector(
                    onTap: () {
                      PrefData.setCustomPlanId(customplan.customPlanId);

                      Get.to(() => SelectedList(dummySend))?.then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 20.h, top: index == 0 ? 10.h : 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.h),
                          boxShadow: [
                            BoxShadow(
                                color: containerShadow,
                                blurRadius: 32,
                                offset: Offset(-2, 5))
                          ]),
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        children: [
                          ConstantWidget.getVerSpace(15.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 70.h,
                                    height: 70.h,
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    child: ConstantWidget.getCustomText(
                                        "${index + 1}",
                                        accentColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w700,
                                        36.sp),
                                  ),
                                  getHorSpace(20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstantWidget.getCustomText(
                                          customplan.name,
                                          textColor,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w500,
                                          17.sp),
                                      ConstantWidget.getVerSpace(7.h),
                                      Row(
                                        children: [
                                          getSvgImage("dumble.svg",
                                              height: 15.h, width: 15.h),
                                          getHorSpace(7.h),
                                          getCustomText(
                                              "${customplan.totalexercise} exercise",
                                              "#525252".toColor(),
                                              1,
                                              TextAlign.start,
                                              FontWeight.w600,
                                              14.sp)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              PopupMenuButton(
                                position: PopupMenuPosition.under,
                                offset: Offset(20, 10),
                                child: Container(
                                  child: getSvgImage("more.svg",
                                      height: 24.h, width: 24.h),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.h)),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      height: 50.h,
                                      padding: EdgeInsets.only(
                                          right: 60.h, left: 20.h),
                                      value: "edit",
                                      child: ConstantWidget.getCustomText(
                                          "Edit",
                                          textColor,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w500,
                                          17.sp),
                                    ),
                                    PopupMenuItem(
                                      padding: EdgeInsets.only(
                                          right: 60.h, left: 20.h),
                                      value: "delete",
                                      child: ConstantWidget.getCustomText(
                                          "Delete",
                                          textColor,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w500,
                                          17.sp),
                                      height: 50.h,
                                    ),
                                  ];
                                },
                                onSelected: (value) async {
                                  if (value == "edit") {
                                    showDialog(
                                            builder: (context) {
                                              return AddWorkoutDialog(
                                                  customplan.customPlanId,
                                                  customplan.name,
                                                  customplan.description,
                                                  true);
                                            },
                                            context: context)
                                        .then((value) {
                                      setState(() {});
                                    });
                                  } else if (value == "delete") {
                                    Map data =
                                        await ConstantUrl.getCommonParams();
                                    data[ConstantUrl.paramCustomPlanId] =
                                        customplan.customPlanId;

                                    final response = await http.post(
                                        Uri.parse(
                                            ConstantUrl.urlDeleteCustomPlan),
                                        body: data);

                                    var value = ModelDeleteCustomPlan.fromJson(
                                        jsonDecode(response.body));

                                    ConstantUrl.showToast(
                                        value.data.error, context);
                                    checkLoginError(context, value.data.error);
                                    if (value.data.success == 1) {
                                      setState(() {});
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                          ConstantWidget.getVerSpace(15.h),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return getNoData(context);
            }
          } else {
            return getProgressDialog();
          }
        },
      ),
    );
  }

  Container buildCreatePlan(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      color: Colors.white,
      child: Transform.rotate(
        angle: math.pi,
        child: SizedBox(
          height: 170.h,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            primary: false,
            appBar: AppBar(
              bottomOpacity: 0.0,
              title: const Text(''),
              toolbarHeight: 0,
              elevation: 0,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onTap: () {},
              child: Container(
                width: 60.h,
                height: 60.h,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: "#1A000000".toColor(),
                          blurRadius: 18,
                          offset: Offset(0, 9))
                    ],
                    color: accentColor,
                    borderRadius: BorderRadius.circular(50.h)),
                child: GestureDetector(
                    onTap: () async {
                      if (await ConstantUrl.isLogin()) {
                        showDialog(
                                builder: (context) {
                                  return AddWorkoutDialog("0", "", "", false);
                                },
                                context: context)
                            .then((value) {
                          setState(() {});
                        });
                      } else {
                        if (await PrefData.getFirstSignUp() == true) {
                          Get.toNamed("/intro", arguments: () {
                            showDialog(
                                    builder: (context) {
                                      return AddWorkoutDialog(
                                          "0", "", "", false);
                                    },
                                    context: context)
                                .then((value) {
                              setState(() {});
                            });
                          });
                        } else {
                          ConstantUrl.sendLoginPage(context, function: () {
                            showDialog(
                                    builder: (context) {
                                      return AddWorkoutDialog(
                                          "0", "", "", false);
                                    },
                                    context: context)
                                .then((value) {
                              setState(() {});
                            });
                          }, argument: () {
                            showDialog(
                                    builder: (context) {
                                      return AddWorkoutDialog(
                                          "0", "", "", false);
                                    },
                                    context: context)
                                .then((value) {
                              setState(() {});
                            });
                          });
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 15.h),
                      child: getSvgImage("add.svg"),
                    )),
              ),
            ),
            bottomNavigationBar: Container(
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
                child: BottomAppBar(
                  color: bgColor,
                  elevation: 0,
                  shape: CircularNotchedRectangle(),
                  notchMargin: (10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Transform.rotate(
                          angle: math.pi,
                          child: getPaddingWidget(
                            EdgeInsets.symmetric(horizontal: 20.h),
                            Column(
                              children: [
                                ConstantWidget.getVerSpace(30.h),
                                ConstantWidget.getCustomText(
                                    "Create a new plan",
                                    textColor,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w700,
                                    22.sp),
                                ConstantWidget.getVerSpace(6.h),
                                getMultilineCustomFont(
                                    "You can create and edit your own workout by choosing from various exercise",
                                    17.sp,
                                    "#525252".toColor(),
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.41.h,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
