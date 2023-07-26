import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/custom_workout/selected_list.dart';


import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../PrefData.dart';
import '../Widgets.dart';
import '../controller/select_workout_controller.dart';
import '../models/ModelDetailExerciseList.dart';
import '../models/ModelDummySend.dart';
import '../models/model_add_custom_plan_exercise.dart';
import '../models/model_edit_custom_plan_exercise.dart';
import '../models/model_get_custom_plan_exercise.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../onlineData/dummy_data.dart';
import '../online_models/ModelWorkout.dart';

class SelectWorkout extends StatefulWidget {
  final List<String> exerciseIdList;

  SelectWorkout(this.exerciseIdList);

  @override
  State<SelectWorkout> createState() => _SelectWorkoutState();
}

class _SelectWorkoutState extends State<SelectWorkout>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.delete<SelectWorkoutController>();

    DummyData.removeAllData();

    Get.back();

    return new Future.value(false);
  }

  List<String> workoutcategoryList = [
    "Warm up",
    "ABS Workout",
    "Butt Workout",
    "Arm & shoulder Workout"
  ];
  var count = 0;

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  SelectWorkoutController controller = Get.put(SelectWorkoutController());
  List<Exercise>? exerciseList;
  List<Exercise> allExerciseList = [];
  List<Customplanexercise>? customPlanExerciseList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();

    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });

    Future.delayed(Duration.zero, () {
      controller.onChangeIdList(RxList<String>.from(widget.exerciseIdList));
      controller.onOldIdList(RxList<String>.from(widget.exerciseIdList));
    });

    getYogaWorkout(context).then((value) {
      controller.onChange(value!.data!.category![0].categoryId!.obs);

      getExerciseList(context, controller.categoryId.value).then((value) {
        setState(() {
          exerciseList = value!.data!.exercise!;
        });
        getCustomPlanExercise(context).then((value) {
          setState(() {
            customPlanExerciseList = value?.data.customplanexercise;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    try {
      if (animationController != null) {
        animationController!.dispose();
      }
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildAppBar(),
              ConstantWidget.getVerSpace(27.h),
              buildCategoryList(),
              ConstantWidget.getVerSpace(27.h),
              buildSelectWidget(),
              ConstantWidget.getVerSpace(20.h),
              buildSelectWorkoutList(),
              buildDoneButton(context),
              ConstantWidget.getVerSpace(40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          GestureDetector(
              child: getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
              onTap: () {
                _requestPop().then((value) {
                  setState(() {});
                });
              }),
          getHorSpace(12.sp),
          ConstantWidget.getCustomText("Select Workout", Colors.black, 1,
              TextAlign.start, FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  Widget buildDoneButton(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getButton(context, Colors.black, "Done", Colors.white, () async {
        await deletePlan().then((value) async {
          await addPlan().then((value) async {
            if (isPlanSuccess) {
              ConstantUrl.showToast("Add Custom Plan Exercise", context);
            }
            String customPlanId = await PrefData.getCustomPlanId();
            String customPlanDescription =
                await PrefData.getCustomPlanDescription();
            String customPlanName = await PrefData.getCustomPlanName();
            DummyData.removeAllData();
            Get.to(SelectedList(ModelDummySend(
                customPlanId,
                customPlanName,
                ConstantUrl.urlGetWorkoutExercise,
                ConstantUrl.varCatId,
                getCellColor(0),
                "ssds",
                true,
                customPlanDescription,
                CUSTOM_WORKOUT)));
          });
        });
      }, 20.sp,
          weight: FontWeight.w700,
          buttonHeight: 60.h,
          borderRadius: BorderRadius.circular(22.h)),
    );
  }

  Future<void> deletePlan() async {
    List l1 = controller.idList;
    List l2 = widget.exerciseIdList;
    l2.removeWhere((element) => l1.contains(element));
    l2.forEach((element) async {
      String customExerciseId = await DummyData.getCustomPlanId(element);
      ConstantUrl.deleteExercise(context, () {
        print("customExerciseId===$customExerciseId");
      }, customExerciseId, element);
    });
  }

  bool isPlanSuccess = false;

  Future<void> addPlan() async {
    await Future.forEach(controller.exerciseIdList, (element) async {
      int time = await DummyData.getDuration(element.toString());

      String customPlanId = await PrefData.getCustomPlanId();

      Map data = await ConstantUrl.getCommonParams();
      data[ConstantUrl.paramCustomPlanId] = customPlanId;
      data[ConstantUrl.paramExerciseId] = element;
      data[ConstantUrl.paramExerciseTime] = time.toString();

      if (!controller.idList.contains(element)) {
        final response = await http
            .post(Uri.parse(ConstantUrl.urlAddCustomPlanExercise), body: data);

        var value =
            ModelAddCustomPlanExercise.fromJson(jsonDecode(response.body));

        isPlanSuccess = true;
        if (value.data.success == 1) {
          print("data=====ADd===$isPlanSuccess");
        }
      } else {
        String customExerciseId =
            await DummyData.getCustomPlanId(element.toString());

        data[ConstantUrl.paramCustomPlanExerciseId] = customExerciseId;

        final response = await http
            .post(Uri.parse(ConstantUrl.urlEditCustomPlanExercise), body: data);

        var value =
            ModelEditCustomPlanExercise.fromJson(jsonDecode(response.body));

        if (value.data.success == 1) {
          print("data=====Edit===true");
        }
      }
    });
  }

  Widget buildSelectWorkoutList() {
    if (exerciseList == null) {
      return getProgressDialog();
    } else {
      return Expanded(
          flex: 1,
          child: GetBuilder<SelectWorkoutController>(
            init: SelectWorkoutController(),
            builder: (controller) => ListView.builder(
              physics: BouncingScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              itemCount: exerciseList?.length,
              itemBuilder: (context, index) {
                Exercise? _modelExerciseList = exerciseList?[index];
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Curves.easeInOut,
                  ),
                );
                animationController!.forward();

                String key = _modelExerciseList!.exerciseId!;
                return AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 50 * (1.0 - animation.value), 0.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 20.h, right: 20.h, bottom: 20.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.h, vertical: 12.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: containerShadow,
                                    blurRadius: 32,
                                    offset: Offset(-2, 5))
                              ],
                              borderRadius: BorderRadius.circular(22.h)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 78.h,
                                      width: 78.h,
                                      decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius:
                                              BorderRadius.circular(12.h)),
                                      child: Image.network(
                                          ConstantUrl.uploadUrl +
                                              _modelExerciseList.image!),
                                    ),
                                    getHorSpace(12.h),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstantWidget.getCustomText(
                                              _modelExerciseList.exerciseName!,
                                              textColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w700,
                                              17.sp),
                                          ConstantWidget.getVerSpace(6.h),
                                          Container(
                                            width: 105.w,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12.h),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: containerShadow,
                                                      blurRadius: 32,
                                                      offset: Offset(-2, 5))
                                                ]),
                                            child: FutureBuilder<int>(
                                              future:
                                                  DummyData.getDuration(key),
                                              builder: (context, snapshot) {
                                                int time = 0;

                                                if (snapshot.data != null) {
                                                  time = snapshot.data!;
                                                }

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller.addDuration(
                                                            index, key, time);
                                                      },
                                                      child: getSvgImage(
                                                          "add.svg",
                                                          color: accentColor,
                                                          width: 24.h,
                                                          height: 24.h),
                                                    ),
                                                    getHorSpace(8.h),
                                                    ConstantWidget
                                                        .getCustomText(
                                                            "${time}s",
                                                            textColor,
                                                            1,
                                                            TextAlign.center,
                                                            FontWeight.w700,
                                                            17.sp),
                                                    getHorSpace(8.h),
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller
                                                            .minusDuration(
                                                                index,
                                                                key,
                                                                time);
                                                      },
                                                      child: getSvgImage(
                                                          "minus.svg",
                                                          color: accentColor,
                                                          width: 24.h,
                                                          height: 24.h),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              getPaddingWidget(
                                  EdgeInsets.only(top: 6.h, right: 8.h),
                                  GestureDetector(
                                    onTap: () async {
                                      if (controller.exerciseIdList.contains(
                                          _modelExerciseList.exerciseId)) {
                                        controller.onRemoveValue(
                                            _modelExerciseList.exerciseId!);
                                      } else {
                                        controller.onAddValue(
                                            _modelExerciseList.exerciseId!);
                                      }

                                      print(
                                          "controller===${controller.exerciseIdList.length}");
                                    },
                                    child: getSvgImage(
                                        controller.exerciseIdList.contains(
                                                _modelExerciseList.exerciseId)
                                            ? "check_orange.svg"
                                            : "uncheck_orange.svg",
                                        width: 16.h,
                                        height: 16.h,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ));
    }
  }

  RxBool isSelect = false.obs;

  Future<void> onSelectFunction() async {
    if (exerciseList != null && exerciseList!.length > 0) {
      exerciseList!.forEach((element) {
        Exercise? _modelExerciseList = element;

        if (!isSelect.value) {
          controller.onAddValue(_modelExerciseList.exerciseId!);
        }
      });
    }
  }

  Future<void> onRemoveSelectFunction() async {
    if (exerciseList != null && exerciseList!.length > 0) {
      exerciseList!.forEach((element) {
        Exercise? _modelExerciseList = element;

        if (isSelect.value) {
          controller.onRemoveValue(_modelExerciseList.exerciseId!);
        }
      });
    }
  }

  Widget buildSelectWidget() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      GetBuilder<SelectWorkoutController>(
        init: SelectWorkoutController(),
        builder: (controller) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Obx(() => Row(
            //       children: [
            //         ConstantWidget.getCustomText("Select All", textColor, 1,
            //             TextAlign.start, FontWeight.w600, 14.sp),
            //         getHorSpace(12.h),
            //         GestureDetector(
            //           onTap: () {
            //             onSelectFunction().then((value) {
            //               if (!isSelect.value) {
            //                 isSelect(true);
            //               }
            //             });
            //           },
            //           child: getSvgImage(
            //               isSelect.value
            //                   ? "check_orange.svg"
            //                   : "uncheck_orange.svg",
            //               height: 16.h,
            //               width: 16.h,
            //               color: Colors.black),
            //         )
            //       ],
            //     )),
            ConstantWidget.getCustomText("${controller.exerciseIdList.length}",
                textColor, 1, TextAlign.center, FontWeight.w600, 14.sp),
            // GestureDetector(
            //   onTap: () {
            //     onRemoveSelectFunction().then((value) {
            //       if (isSelect.value) {
            //         isSelect(false);
            //       }
            //     });
            //   },
            //   child: ConstantWidget.getCustomText("Cancel", textColor, 1,
            //       TextAlign.center, FontWeight.w600, 14.sp),
            // )
          ],
        ),
      ),
    );
    // }
  }

  Container buildCategoryList() {
    return Container(
      height: 36.h,
      child: FutureBuilder<ModelWorkout?>(
        future: getYogaWorkout(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            ModelWorkout? modelWorkout = snapshot.data;

            if (modelWorkout!.data!.success == 1) {
              List<Category>? workoutList = modelWorkout.data!.category;
              return GetBuilder<SelectWorkoutController>(
                init: SelectWorkoutController(),
                builder: (controller) => ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: workoutList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Category _modelWorkoutList = workoutList[index];
                    return Wrap(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.h),
                            alignment: Alignment.center,
                            height: 36.h,
                            decoration: index ==
                                    (int.parse(controller.categoryId.value) - 1)
                                ? BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(12.h))
                                : null,
                            child: getCustomText(
                                _modelWorkoutList.category!,
                                index ==
                                        (int.parse(
                                                controller.categoryId.value) -
                                            1)
                                    ? Colors.white
                                    : "#525252".toColor(),
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                14.sp),
                            margin: EdgeInsets.only(
                                right: 12.h, left: index == 0 ? 20.h : 0),
                          ),
                          onTap: () {
                            controller
                                .onChange(_modelWorkoutList.categoryId!.obs);
                            getExerciseList(
                                    context, controller.categoryId.value)
                                .then((value) {
                              setState(() {
                                exerciseList = value!.data!.exercise!;
                              });
                              getCustomPlanExercise(context).then((value) {
                                setState(() {
                                  customPlanExerciseList =
                                      value?.data.customplanexercise;
                                });
                              });
                            });
                          },
                        )
                      ],
                    );
                  },
                ),
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
}
