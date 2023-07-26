import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../HomeWidget.dart';
import '../SizeConfig.dart';
import '../WidgetAllYogaWorkout.dart';
import '../WidgetChallengesExerciseList.dart';
import '../Widgets.dart';
import '../ads/ads_file.dart';
import '../controller/home_controller.dart';
import '../generated/l10n.dart';
import '../models/ModelDummySend.dart';
import '../models/ModelHistory.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/HomeWorkout.dart';
import '../online_models/ModelAllChallenge.dart';
import '../online_models/ModelWorkout.dart';

class TabHome extends StatefulWidget {
  TabHome();

  @override
  _TabHome createState() => _TabHome();
}

class _TabHome extends State<TabHome> with TickerProviderStateMixin {
  List<Widget> progressWidget = [];
  AnimationController? animationController;
  double getCal = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList = [];
  int getTime = 0;
  double listLength = 1;
  Animation<dynamic>? animation;

  AdsFile? adsFile;

  void _calcTotal() async {
    getHomeWorkoutData(context).then((value) {
      print("value---$value");

      if (value != null && value.data!.success == 1) {
        Homeworkout homeWorkout = value.data!.homeworkout!;
        int second = int.parse(homeWorkout.duration!);
        double kcal = double.parse(homeWorkout.kcal!);
        int workout = int.parse(homeWorkout.workouts!);

        setState(() {
          getTime = second;
          getCal = kcal;
          getTotalWorkout = workout;
        });
      } else {
        print("second---true");
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {
      animationController!.dispose();
    } catch (e) {
      print(e);
    }
    disposeRewardedAd(adsFile);
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });
    progressWidget.add(getProgressDialog());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _calcTotal();

    super.initState();
  }

  getCompleteContent(String s, String s1, String icon) {
    double padding = ConstantWidget.getScreenPercentSize(context, 2);
    return Expanded(
      child: ConstantWidget.getShadowWidget(
          widget: Column(
            children: [
              SvgPicture.asset(
                Constants.assetsImagePath + icon,
                height: ConstantWidget.getScreenPercentSize(context, 4),
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 1.5),
              ),
              ConstantWidget.getTextWidget(
                  s,
                  textColor,
                  TextAlign.start,
                  FontWeight.bold,
                  ConstantWidget.getScreenPercentSize(context, 2.2)),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 0.3),
              ),
              ConstantWidget.getTextWidget(
                  s1,
                  subTextColor,
                  TextAlign.start,
                  FontWeight.w500,
                  ConstantWidget.getScreenPercentSize(context, 1.6)),
            ],
          ),
          margin: (textMargin / 2),
          radius: ConstantWidget.getScreenPercentSize(context, 2),
          topPadding: padding,
          bottomPadding: padding),
      flex: 1,
    );
  }

  double textMargin = 0;

  Future<PaletteGenerator?> updatePaletteGenerator(String image) async {
    print("image===="+image);
    PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(
      Image.network(ConstantUrl.uploadUrl + image).image,
    );
    return paletteGenerator;
  }

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sliderHeight = SizeConfig.safeBlockVertical! * 22;
    double sliderRadius = Constants.getPercentSize(sliderHeight, 12);

    textMargin = SizeConfig.safeBlockHorizontal! * 3.5;

    setStatusBarColor(bgDarkWhite);
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgDarkWhite,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: (textMargin / 2), vertical: textMargin),
            child: Row(
              children: [
                getCompleteContent(
                    "$getTotalWorkout", S.of(context).workouts, "dumbbell.svg"),
                SizedBox(
                  width: ConstantWidget.getScreenPercentSize(context, 1),
                ),
                getCompleteContent("${Constants.calFormatter.format(getCal)}",
                    S.of(context).kcal, "bonfire.svg"),
                SizedBox(
                  width: ConstantWidget.getScreenPercentSize(context, 1),
                ),
                getCompleteContent(Constants.getTimeFromSec(getTime),
                    'Duration', "stopwatch.svg"),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(textMargin),
              child: getTitleTexts(context, S.of(context).challenges)),
          FutureBuilder<List<Challenge>?>(
            future: getAllChallenge(context),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData && snapshot.data != null) {
                List<Challenge> challengesList = snapshot.data!;
                print(challengesList);
                List<Container>? imageSliders = (challengesList != null)
                    ? challengesList.map((item) {
                  double progress =
                      (item.totaldayscompleted * 100) / item.totaldays;

                  if (progress > 100) {
                    progress = 100;
                  }
                  double sliderProgress =
                      (item.totaldayscompleted) / item.totaldays;

                  return Container(
                    child: FutureBuilder<PaletteGenerator?>(
                      future: updatePaletteGenerator(item.image),
                      builder: (context, snapshot) {
                        Color color = "#99d8ef".toColor();
                        if (!snapshot.hasError) {
                          if (snapshot.data != null) {
                            color = snapshot.data!.dominantColor!.color;
                          }
                        }
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //     new WidgetChallengesExerciseList(
                            //       item,
                            //       bgColor: color.withOpacity(0.4),
                            //     ),
                            //   ),
                            // ).then((value) {
                            //   setState(() {});
                            // });
                            checkIsProPlan(
                                context: context,
                                adsFile: adsFile!,
                                isActive: item.isActive,
                                setState: setState,
                                function: () {
                                  setStatusBarColor(
                                      color.withOpacity(0.4));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      new WidgetChallengesExerciseList(
                                        item,
                                        bgColor: color.withOpacity(0.4),
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 210.h,
                            margin: EdgeInsets.symmetric(
                                horizontal: textMargin),

                            // margin: EdgeInsets.only(
                            //     right: Constants.getWidthPercentSize(
                            //         context, 4)),
                            decoration: getDefaultDecoration(
                                bgColor: color.withOpacity(0.4),
                                radius: sliderRadius),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                            sliderRadius)),
                                    child: Hero(
                                      tag: item.challengesName,
                                      child: Image.network(
                                          ConstantUrl.uploadUrl +
                                              item.image),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                        ConstantWidget.getPercentSize(
                                            sliderHeight, 15),
                                        horizontal: ConstantWidget
                                            .getWidthPercentSize(
                                            context, 4)),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: ConstantWidget
                                                  .getPercentSize(
                                                  sliderHeight, 3)),
                                          child: ConstantWidget
                                              .getTextWidgetWithFont(
                                              item.challengesName,
                                              textColor,
                                              TextAlign.start,
                                              FontWeight.bold,
                                              ConstantWidget
                                                  .getPercentSize(
                                                  sliderHeight,
                                                  11),
                                              Constants
                                                  .chilankaFontsFamily),
                                        ),
                                        ConstantWidget
                                            .getTextWidgetWithFont(
                                            "${item.totalweek} ${S.of(context).week}",
                                            // "${item.weeks} ${S.of(context).week}",
                                            textColor,
                                            TextAlign.start,
                                            FontWeight.w400,
                                            Constants.getPercentSize(
                                                sliderHeight, 8.5),
                                            Constants.fontsFamily),
                                        Expanded(
                                          child: Container(),
                                          flex: 1,
                                        ),
                                        new LinearPercentIndicator(
                                          width: ConstantWidget
                                              .getWidthPercentSize(
                                              context, 44),
                                          lineHeight: ConstantWidget
                                              .getPercentSize(
                                              sliderHeight, 4.5),
                                          percent: (sliderProgress > 1)
                                              ? 1
                                              : sliderProgress,
                                          padding: EdgeInsets.zero,
                                          backgroundColor: Colors.white,
                                          barRadius: Radius.circular(
                                              ConstantWidget
                                                  .getPercentSize(
                                                  sliderHeight, 8)),
                                          progressColor: color,
                                        ),
                                        SizedBox(
                                          height: ConstantWidget
                                              .getPercentSize(
                                              sliderHeight, 4),
                                        ),
                                        ConstantWidget
                                            .getTextWidgetWithFont(
                                            "${progress.toInt()}%",
                                            textColor,
                                            TextAlign.start,
                                            FontWeight.w400,
                                            Constants.getPercentSize(
                                                sliderHeight, 8),
                                            Constants.fontsFamily),
                                      ],
                                    ),
                                  ),
                                ),
                                getProWidget(
                                    isActive: item.isActive,
                                    context: context)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList()
                    : null;

                // return imageSliders![0];

                return imageSliders == null ? Container() : imageSliders[0];
              } else {
                return Shimmer.fromColors(
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    height: 210.h,
                    margin: EdgeInsets.symmetric(horizontal: textMargin),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20.h)),
                  ),
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                );
              }
            },
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 1.6),
          ),
          Padding(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: getTitleTexts(context, S.of(context).yoga)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WidgetAllYogaWorkout(),
                          ));
                    },
                    child: getCustomText(
                        S.of(context).seeAll,
                        subTextColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        ConstantWidget.getScreenPercentSize(context, 1.6)),
                  )
                ],
              )),
          FutureBuilder<ModelWorkout?>(
            future: getYogaWorkout(context),
            builder: (context, snapshot) {
              print("getworkouts123=${snapshot.data}");

              if (snapshot.hasData && snapshot.data != null) {
                ModelWorkout? modelWorkout = snapshot.data;

                if (modelWorkout!.data!.success == 1) {
                  List<Category>? workoutList = modelWorkout.data!.category;

                  double height =
                  ConstantWidget.getScreenPercentSize(context, 23);

                  return Container(
                    height: height,
                    child: ListView.builder(
                        itemCount: workoutList!.length,
                        scrollDirection: Axis.horizontal,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Category _modelWorkoutList = workoutList[index];

                          ModelDummySend dummySend = new ModelDummySend(
                              _modelWorkoutList.categoryId!,
                              _modelWorkoutList.category!,
                              ConstantUrl.urlGetWorkoutExercise,
                              ConstantUrl.varCatId,
                              getCellColor(index),
                              _modelWorkoutList.image!,
                              true,
                              _modelWorkoutList.description!,
                              CATEGORY_WORKOUT);

                          return Container(
                            height: height,
                            width:
                            ConstantWidget.getWidthPercentSize(context, 33),
                            decoration: getDefaultDecoration(
                                radius:
                                ConstantWidget.getPercentSize(height, 10),
                                bgColor: getCellColor(index)),
                            margin: EdgeInsets.only(left: textMargin),
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  checkIsProPlan(
                                      context: context,
                                      adsFile: adsFile!,
                                      isActive:
                                      _modelWorkoutList.isActive ?? "0",
                                      setState: setState,
                                      function: () {
                                        sendToWorkoutList(context, dummySend);
                                      });
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Hero(
                                          tag: _modelWorkoutList.image ??
                                              "anim1",
                                          child: Image.network(
                                            '${ConstantUrl.uploadUrl + _modelWorkoutList.image!}',
                                            height:
                                            ConstantWidget.getPercentSize(
                                                height, 45),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ConstantWidget.getPercentSize(
                                              height, 12),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                              ConstantWidget.getPercentSize(
                                                  height, 2),
                                              horizontal:
                                              ConstantWidget.getPercentSize(
                                                  height, 3)),
                                          child: ConstantWidget
                                              .getTextWidgetWithFont(
                                              _modelWorkoutList.category!,
                                              textColor,
                                              TextAlign.center,
                                              FontWeight.bold,
                                              ConstantWidget.getPercentSize(
                                                  height, 8.5),
                                              Constants.fontsFamily),
                                        ),
                                        FutureBuilder<int?>(
                                          future: getTotalExercise(
                                              context, dummySend),
                                          builder: (context, snapshot) {
                                            int totalExercise = 0;
                                            if (snapshot.hasData) {
                                              totalExercise = snapshot.data!;
                                            } else {
                                              totalExercise = 0;
                                            }

                                            return ConstantWidget
                                                .getTextWidgetWithFont(
                                                "$totalExercise ${S.of(context).exercises}",
                                                textColor,
                                                TextAlign.start,
                                                FontWeight.w400,
                                                Constants.getPercentSize(
                                                    height, 7),
                                                Constants.fontsFamily);
                                          },
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 127.h,
                                      width: 177.h,
                                      child: getProWidget(
                                          isActive:
                                          _modelWorkoutList.isActive ?? "0",
                                          context: context,
                                          verSpace: 10.h),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return getNoData(context);
                }
              } else {
                double height =
                ConstantWidget.getScreenPercentSize(context, 23);
                return Container(
                  height: height,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: height,
                            width:
                            ConstantWidget.getWidthPercentSize(context, 33),
                            decoration: getDefaultDecoration(
                                radius: 20.h, bgColor: getCellColor(index)),
                            margin: EdgeInsets.only(left: textMargin),
                            child: Container(
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: ConstantWidget.getPercentSize(
                                              height, 45)),
                                      SizedBox(
                                        height: ConstantWidget.getPercentSize(
                                            height, 12),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                            ConstantWidget.getPercentSize(
                                                height, 2),
                                            horizontal:
                                            ConstantWidget.getPercentSize(
                                                height, 3)),
                                        child: ConstantWidget
                                            .getTextWidgetWithFont(
                                            "",
                                            textColor,
                                            TextAlign.center,
                                            FontWeight.bold,
                                            ConstantWidget.getPercentSize(
                                                height, 8.5),
                                            Constants.fontsFamily),
                                      ),
                                      ConstantWidget.getTextWidgetWithFont(
                                          "${S.of(context).exercises}",
                                          textColor,
                                          TextAlign.start,
                                          FontWeight.w400,
                                          Constants.getPercentSize(height, 7),
                                          Constants.fontsFamily)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
            },
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 1.6),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                getCustomText("My Plan", textColor, 1, TextAlign.start,
                    FontWeight.w700, 20.sp),
              ),
              ConstantWidget.getVerSpace(12.h),
              Container(
                height: 169.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 1,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.onChange(2.obs);
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(
                            end: 12.h, start: index == 0 ? 20.h : 0),
                        width: 374.w,
                        child: Column(
                          children: [
                            ConstantWidget.getVerSpace(11.h),
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: AlignmentDirectional.centerEnd,
                              children: [
                                Container(
                                  height: 158.h,
                                  decoration: BoxDecoration(
                                      color: "FFF3D0".toColor(),
                                      borderRadius:
                                      BorderRadius.circular(22.h)),
                                  child: Row(
                                    children: [
                                      getHorSpace(20.h),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          getCustomText(
                                              "Custom Workout",
                                              textColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w700,
                                              22.sp),
                                          ConstantWidget.getVerSpace(4.h),
                                          Container(
                                            width: 203.h,
                                            child: getMultilineCustomFont(
                                                "Add your custom plan by tapping to create a new plan",
                                                12.sp,
                                                "#525252".toColor(),
                                                fontWeight: FontWeight.w500,
                                                textAlign: TextAlign.start,
                                                txtHeight: 1.25.h),
                                          ),
                                          ConstantWidget.getVerSpace(12.h),
                                          Row(
                                            children: [
                                              getCustomText(
                                                  "Let’s Start",
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w600,
                                                  16.sp),
                                              getHorSpace(6.h),
                                              getSvgImage("arrow_right.svg",
                                                  height: 24.h,
                                                  width: 24.h,
                                                  color: textColor)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    height: 263.h,
                                    width: 165.h,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          end: 15.h, bottom: 15.h),
                                      child: getAssetImage(
                                        "plan.png",
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 1.6),
          ),
        ],
      ),
    );
  }
}
