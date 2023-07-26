import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_yoga_workout_4_all_new/models/ModelExerciseList.dart';
import 'package:flutter_yoga_workout_4_all_new/onlineData/dummy_data.dart';
import 'package:flutter_yoga_workout_4_all_new/online_models/ChallengeDaysModel.dart';
import 'package:get/get.dart';
import '../ConstantWidget.dart';
import '../models/ModelDummySend.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';
import 'WidgetWorkout2.dart';
import 'Widgets.dart';

import 'ads/ads_file.dart';
import 'generated/l10n.dart';
import 'models/ModelDetailExerciseList.dart';
import 'onlineData/ConstantUrl.dart';
import 'onlineData/ServiceProvider.dart';
import '../online_models/UserDetail.dart';

String getImageUrl(Exercise exercise) {
  if (exercise.image!.isNotEmpty) {
    // print("${ConstantUrl.uploadUrl}${exercise.image}");
    return "${ConstantUrl.uploadUrl}${exercise.image}";
  }
  if (exercise.thumbnailUrl!.isNotEmpty)
    return "${ConstantUrl.uploadUrl}${exercise.thumbnailUrl}";
  if (exercise.hostIconUrl!.isNotEmpty) return exercise.hostIconUrl!;
  return "";
}

class WidgetMyPlanExerciseList extends StatefulWidget {
  final ModelDummySend modelDumySend;
  final Color color;

  WidgetMyPlanExerciseList(this.modelDumySend, this.color);

  @override
  _WidgetMyPlanExerciseList createState() => _WidgetMyPlanExerciseList();
}

class _WidgetMyPlanExerciseList extends State<WidgetMyPlanExerciseList>
    with TickerProviderStateMixin {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  double getCal = 0;
  int getTime = 0;
  String exerciseTools = "";
  List? priceList;
  AdsFile? adsFile;

  String planId = "-1";
  int userWeight = 0;

  getPlanId() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      planId = userDetail.intensively ?? "-1";
      userWeight = int.parse(userDetail.weight.toString());
      print("usrPlan===" + planId);
      setState(() {});
    }
    ;
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
    getPlanId();
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createAnchoredBanner(context, setState);
      adsFile!.createInterstitialAd();
    });

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
  }

  @override
  void dispose() {
    adsFile!.disposeInterstitialAd();
    adsFile!.disposeBannerAd();
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

  Future<void> share() async {
    await FlutterShare.share(title: 'Share', text: S.of(context).app_name);
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share':
        share();
        break;
    }
  }

  List<Exercise> _list = [];

  PageController controller = PageController();
  double margin = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getWidthPercentSize(context, 4);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(widget.color),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                height: double.infinity,
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height:
                                    Constants.getScreenPercentSize(context, 40),
                                decoration: BoxDecoration(
                                    color: widget.color,
                                    image: widget.modelDumySend.image != null &&
                                            widget.modelDumySend.image!.length >
                                                5
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              ConstantUrl.uploadUrl +
                                                  widget.modelDumySend.image!,
                                            ),
                                            fit: BoxFit.fill)
                                        : null,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(
                                            ConstantWidget.getScreenPercentSize(
                                                context, 1.5)))),
                              ),
                              ConstantWidget.getLoginAppBar(context,
                                  function: onBackClicked, infoFunction: () {
                                showInfoDialog();
                              }, isInfo: null)
                            ],
                          ),
                          SizedBox(
                            height:
                                ConstantWidget.getScreenPercentSize(context, 5),
                          ),
                          FutureBuilder<ModelDetailExerciseList?>(
                            future: getMyPlanExerciseList(
                                context, widget.modelDumySend.id ?? "2"), //
                            builder: (context, snapshot) {
                              getCal = 0;
                              getTime = 0;
                              if (snapshot.hasData) {
                                ModelDetailExerciseList
                                    modelExerciseDetailList = snapshot.data!;
                                print(snapshot.data!);
                                if (modelExerciseDetailList.data!.success ==
                                    1) {
                                  _list =
                                      modelExerciseDetailList.data!.exercise!;
                                  exerciseTools = modelExerciseDetailList
                                      .data!.exercise_tools!;
                                  _list.forEach((price) {
                                    getTime = getTime +
                                        int.parse(price.exerciseTime!);
                                  });
                                  getCal = Constants.calDefaultCalculation *
                                      getTime /
                                      60 *
                                      userWeight;
                                  return ListView(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: margin),
                                        child: ConstantWidget.getTextWidget(
                                            "Tools",
                                            Colors.black,
                                            TextAlign.start,
                                            FontWeight.bold,
                                            ConstantWidget.getScreenPercentSize(
                                                context, 2.5)),
                                      ),

                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: (margin / 2),
                                            vertical: margin / 2),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ConstantWidget.getTextWidget(
                                                exerciseTools,
                                                textColor,
                                                TextAlign.start,
                                                FontWeight.w300,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.7)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: margin),
                                        child: ConstantWidget.getTextWidget(
                                            "Let's Go",
                                            Colors.black,
                                            TextAlign.start,
                                            FontWeight.bold,
                                            ConstantWidget.getScreenPercentSize(
                                                context, 2.5)),
                                      ),

                                      Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: (margin / 2),
                                            vertical: margin),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.watch_later_rounded,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ConstantWidget.getTextWidget(
                                                Constants.getMMSSFromSec(
                                                    getTime),
                                                textColor,
                                                TextAlign.start,
                                                FontWeight.w300,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.7)),
                                            SizedBox(
                                              width: ConstantWidget
                                                  .getScreenPercentSize(
                                                      context, 5),
                                            ),
                                            Icon(
                                              Icons.local_fire_department,
                                              size: 22,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ConstantWidget.getTextWidget(
                                                "${Constants.calFormatter.format(getCal)} " +
                                                    S.of(context).kcal,
                                                textColor,
                                                TextAlign.start,
                                                FontWeight.w300,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.7)),
                                          ],
                                        ),
                                      ),

                                      // Padding(
                                      //   padding: EdgeInsets.symmetric(
                                      //       horizontal: margin),
                                      //   child: ConstantWidget.getTextWidget(
                                      //       'Exercises',
                                      //       Colors.black,
                                      //       TextAlign.start,
                                      //       FontWeight.bold,
                                      //       ConstantWidget.getScreenPercentSize(
                                      //           context, 2)),
                                      // ),

                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight:
                                                      Radius.circular(30)),
                                              color: Colors.white),
                                          child: (snapshot.hasData)
                                              ? ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      color: subTextColor,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  margin),
                                                      height: 0.1,
                                                      width: double.infinity,
                                                    );
                                                  },
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: _list.length,
                                                  primary: false,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Exercise
                                                        _modelExerciseList =
                                                        _list[index];

                                                    double radius = Constants
                                                        .getScreenPercentSize(
                                                            context, 2);
                                                    final Animation<double>
                                                        animation =
                                                        Tween<double>(
                                                                begin: 0.0,
                                                                end: 1.0)
                                                            .animate(
                                                      CurvedAnimation(
                                                        parent:
                                                            animationController!,
                                                        curve: Interval(
                                                            (1 / _list.length) *
                                                                index,
                                                            1.0,
                                                            curve: Curves
                                                                .fastOutSlowIn),
                                                      ),
                                                    );
                                                    animationController!
                                                        .forward();

                                                    double cellSize =
                                                        ConstantWidget
                                                            .getScreenPercentSize(
                                                                context, 9);

                                                    return Column(
                                                      children: [
                                                        index == 0 ||
                                                                (index > 0 &&
                                                                    _list[index -
                                                                                1]
                                                                            .isStretch
                                                                            .toString() !=
                                                                        _list[index]
                                                                            .isStretch
                                                                            .toString())
                                                            ? Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            20),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            margin),
                                                                child: Row(
                                                                  children: [
                                                                    ConstantWidget.getTextWidget(
                                                                        _modelExerciseList.isStretch ==
                                                                                true
                                                                            ? 'Warm Up'
                                                                            : 'Exercises',
                                                                        Colors
                                                                            .black,
                                                                        TextAlign
                                                                            .start,
                                                                        FontWeight
                                                                            .bold,
                                                                        ConstantWidget.getScreenPercentSize(
                                                                            context,
                                                                            2)),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    ConstantWidget.getTextWidget(
                                                                        'Repeat 1 time',
                                                                        Colors
                                                                            .black54,
                                                                        TextAlign
                                                                            .start,
                                                                        FontWeight
                                                                            .w400,
                                                                        ConstantWidget.getScreenPercentSize(
                                                                            context,
                                                                            1.5)),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        AnimatedBuilder(
                                                          builder:
                                                              (context, child) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child: Transform(
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        0.0,
                                                                        50 *
                                                                            (1.0 -
                                                                                animation.value),
                                                                        0.0),
                                                                child:
                                                                    GestureDetector(
                                                                  child: Card(
                                                                    color: Colors
                                                                        .transparent,
                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(radius))),
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            margin,
                                                                        vertical:
                                                                            margin),
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(Constants.getPercentSize(cellSize, 5)),
                                                                            height:
                                                                                cellSize,
                                                                            width:
                                                                                cellSize,
                                                                            decoration:
                                                                                getDefaultDecoration(bgColor: cellColor, radius: radius),
                                                                            child:
                                                                                Image.network(
                                                                              // "${ConstantUrl.uploadUrl}${_modelExerciseList.image!.isNotEmpty?_modelExerciseList.image:_modelExerciseList.thumbnailUrl}",
                                                                              getImageUrl(_modelExerciseList),
                                                                              width: double.infinity,
                                                                              height: double.infinity,
                                                                              fit: BoxFit.contain,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                ConstantWidget.getWidthPercentSize(context, 3.5),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                ConstantWidget.getCustomTextWidget(_modelExerciseList.exerciseName!, textColor, ConstantWidget.getScreenPercentSize(context, 1.8), FontWeight.bold, TextAlign.start, 1),
                                                                                SizedBox(
                                                                                  height: ConstantWidget.getScreenPercentSize(context, 0.5),
                                                                                ),
                                                                                ConstantWidget.getTextWidget("${_modelExerciseList.exerciseTime} ${S.of(context).seconds}", subTextColor, TextAlign.start, FontWeight.w500, ConstantWidget.getScreenPercentSize(context, 1.6)),
                                                                              ],
                                                                            ),
                                                                            flex:
                                                                                1,
                                                                          ),
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              showBottomDialog(_list[index]);
                                                                            },
                                                                            padding:
                                                                                EdgeInsets.all(7),
                                                                            icon:
                                                                                Icon(
                                                                              Icons.more_vert_rounded,
                                                                              color: Colors.black,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    showBottomDialog(
                                                                        _list[
                                                                            index]);
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          animation:
                                                              animationController!,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )
                                              : getProgressDialog())

                                      //add your screen content here
                                    ],
                                  );
                                } else {
                                  return getNoData(context);
                                }
                              } else {
                                return getProgressDialog();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: margin),
                      child: ConstantWidget.getIconButtonWidget(
                          context, 'Start Workout',
                          borderColor: planId == '0'
                              ? Colors.green
                              : planId == '1'
                                  ? Colors.purple
                                  : planId == '2'
                                      ? redColor
                                      : Colors.grey,
                          fillColor: planId == '0'
                              ? Colors.green
                              : planId == '1'
                                  ? Colors.purple
                                  : planId == '2'
                                      ? redColor
                                      : Colors.grey,
                          fontColor: Colors.white,
                          asset: "", () async {
                        bool i = await ConstantUrl.isLogin();
                        print("click====true===$i");
                        if (await ConstantUrl.isLogin()) {
                          adsFile!.showInterstitialAd(() {
                            sendToNext();
                          });
                        } else {
                          if (await PrefData.getFirstSignUp() == true) {
                            Get.toNamed("/intro", arguments: () {
                              sendToNext();
                            });
                          } else {
                            ConstantUrl.sendLoginPage(context, function: () {
                              adsFile!.showInterstitialAd(() {
                                sendToNext();
                              });
                            }, argument: () {
                              adsFile!.showInterstitialAd(() {
                                Get.back();
                                sendToNext();
                              });
                            });
                          }
                        }
                      }),
                    ),
                    showBanner(adsFile)
                  ],
                ))),
        // ),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );
  }

  void showInfoDialog() {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 50,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: ConstantWidget.getScreenPercentSize(context, 1.4)),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 2.5)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ConstantWidget.getCustomTextWidget(
                        widget.modelDumySend.name! + " AAAAA",
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
              ConstantWidget.getTextWidget(
                  'Description',
                  Colors.black,
                  TextAlign.start,
                  FontWeight.bold,
                  ConstantWidget.getScreenPercentSize(context, 2)),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 0.5),
              ),
              HtmlWidget(
                Constants.decode(widget.modelDumySend.desc!),
                textStyle: TextStyle(
                    wordSpacing: 2,
                    color: Colors.black,
                    fontSize: ConstantWidget.getScreenPercentSize(context, 1.6),
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.normal),
              )
            ],
          ),
        );
      },
    );
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
          margin: (margin / 2),
          radius: ConstantWidget.getScreenPercentSize(context, 2),
          topPadding: padding,
          bottomPadding: padding),
      flex: 1,
    );
  }

  void sendToNext() {
    print("exerciseList===${_list.length}");
    if (_list.isNotEmpty && _list.length > 0) {
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) {
      //     return WidgetWorkout(
      //         _list, widget._modelWorkoutList, getCal, getTime);
      //   },
      // ));
      Get.to(WidgetWorkout(_list, widget.modelDumySend, getCal, getTime));
    }
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  void showBottomDialog(Exercise exerciseDetail) {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 72,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: ConstantWidget.getScreenPercentSize(context, 1.6)),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              SizedBox(height: ConstantWidget.getScreenPercentSize(context, 4)),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ConstantWidget.getCustomTextWidget(
                        exerciseDetail.exerciseName!,
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
              Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical! * 45,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      getImageUrl(exerciseDetail),
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: getDefaultDecoration(
                    radius: ConstantWidget.getScreenPercentSize(context, 2),
                    bgColor: cellColor),
                padding: EdgeInsets.all(
                    ConstantWidget.getScreenPercentSize(context, 2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidget.getCustomTextWidget(
                        'How to perform',
                        textColor,
                        ConstantWidget.getScreenPercentSize(context, 2),
                        FontWeight.bold,
                        TextAlign.start,
                        1),
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 1.2),
                    ),
                    HtmlWidget(
                      Constants.decode(exerciseDetail.description ?? ""),
                      textStyle: TextStyle(
                          wordSpacing: 2,
                          color: textColor,
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 1.8),
                          fontFamily: Constants.fontsFamily,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
