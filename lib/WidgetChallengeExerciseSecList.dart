import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import '../WidgetChallengeWorkout.dart';

import '../onlineData/ConstantUrl.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'ads/ads_file.dart';
import 'generated/l10n.dart';
import 'models/ModelDetailExerciseList.dart';
import 'onlineData/ServiceProvider.dart';
import 'online_models/ChallengeDaysModel.dart';
import 'online_models/ChallengeWeekModel.dart';
import 'online_models/ModelAllChallenge.dart';

class WidgetChallengeExerciseSecList extends StatefulWidget {
  final Challenge _modelWorkoutList;
  final int day, week;
  final Color? bgColor;
  final Days dayModel;
  final Week weekModel;

  WidgetChallengeExerciseSecList(this._modelWorkoutList, this.day, this.week,
      this.dayModel, this.weekModel,
      {this.bgColor});

  @override
  _WidgetChallengeExerciseSecList createState() =>
      _WidgetChallengeExerciseSecList();
}

class _WidgetChallengeExerciseSecList
    extends State<WidgetChallengeExerciseSecList>
    with TickerProviderStateMixin {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  List? priceList;

  double getCal = 0;
  int getTime = 0;
  Widget? getListWidget;
  List<Exercise>? exerciseList = [];

  double dialogRadius = 0;

  Future<void> setData() async {
    animationController1!.forward();
  }

  AdsFile? adsFile;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createInterstitialAd();
      adsFile!.createAnchoredBanner(context, setState);
    });
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animationController1 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController1!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
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
  }

  @override
  void dispose() {
    disposeBannerAd(adsFile);
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
    await FlutterShare.share(
      title: S.of(context).app_name,
      text: S.of(context).app_name,
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share':
        share();
        break;
    }
  }

  double margin = 0;

  PageController controller = PageController();

  AnimationController? animationController1;
  Animation<double>? animation1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    margin = ConstantWidget.getWidthPercentSize(context, 4);
    dialogRadius = ConstantWidget.getWidthPercentSize(context, 8);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(widget.bgColor),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  primary: true,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: Constants.getPercentSize(screenHeight, 45)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: margin),
                                child: ConstantWidget.getTextWidget(
                                    widget._modelWorkoutList.challengesName,
                                    Colors.black,
                                    TextAlign.start,
                                    FontWeight.bold,
                                    ConstantWidget.getScreenPercentSize(
                                        context, 2.5)),
                              ),
                              FutureBuilder<ModelDetailExerciseList?>(
                                future: getChallengeDetailExerciseList(
                                    context, widget.dayModel.daysId!),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    ModelDetailExerciseList?
                                        challengeWeekModel = snapshot.data;
                                    if (challengeWeekModel!.data!.success ==
                                        1) {
                                      exerciseList =
                                          challengeWeekModel.data!.exercise;

                                      if ((exerciseList != null &&
                                          exerciseList!.length > 0)) {
                                        int timeSet = 0;
                                        exerciseList!.forEach((price) {
                                          timeSet = timeSet +
                                              int.parse(price.exerciseTime!);
                                        });

                                        print("timeSet--12-$timeSet");

                                        getTime = timeSet;
                                        getCal =
                                            Constants.calDefaultCalculation *
                                                timeSet;

                                        return ListView(
                                          primary: false,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            SizedBox(
                                              height: ConstantWidget
                                                  .getScreenPercentSize(
                                                      context, 1),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: (margin / 2),
                                                  vertical: margin),
                                              child: Row(
                                                children: [
                                                  getCompleteContent(
                                                      "${exerciseList!.length}",
                                                      S.of(context).workout,
                                                      "dumbbell.svg"),
                                                  SizedBox(
                                                    width: ConstantWidget
                                                        .getScreenPercentSize(
                                                            context, 1),
                                                  ),
                                                  getCompleteContent(
                                                      "${Constants.calFormatter.format(getCal)}",
                                                      S.of(context).kcal,
                                                      "bonfire.svg"),
                                                  SizedBox(
                                                    width: ConstantWidget
                                                        .getScreenPercentSize(
                                                            context, 1),
                                                  ),
                                                  getCompleteContent(
                                                      Constants.getTimeFromSec(
                                                          getTime),
                                                      'Duration',
                                                      "stopwatch.svg"),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: margin),
                                              child:
                                                  ConstantWidget.getTextWidget(
                                                      'Exercises',
                                                      Colors.black,
                                                      TextAlign.start,
                                                      FontWeight.bold,
                                                      ConstantWidget
                                                          .getScreenPercentSize(
                                                              context, 2)),
                                            ),
                                            ListView.separated(
                                              separatorBuilder:
                                                  (context, index) {
                                                return Container(
                                                  color: subTextColor,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: margin),
                                                  height: 0.1,
                                                  width: double.infinity,
                                                );
                                              },
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: exerciseList!.length,
                                              primary: false,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                Exercise _modelExerciseList =
                                                    exerciseList![index];

                                                double radius = Constants
                                                    .getScreenPercentSize(
                                                        context, 2);
                                                final Animation<double>
                                                    animation = Tween<double>(
                                                            begin: 0.0,
                                                            end: 1.0)
                                                        .animate(
                                                  CurvedAnimation(
                                                    parent:
                                                        animationController!,
                                                    curve: Interval(
                                                        (1 /
                                                                exerciseList!
                                                                    .length) *
                                                            index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn),
                                                  ),
                                                );
                                                animationController!.forward();

                                                double cellSize = ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 9);

                                                return AnimatedBuilder(
                                                  builder: (context, child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: Transform(
                                                        transform: Matrix4
                                                            .translationValues(
                                                                0.0,
                                                                50 *
                                                                    (1.0 -
                                                                        animation
                                                                            .value),
                                                                0.0),
                                                        child: GestureDetector(
                                                          child: Card(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            radius))),
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        margin,
                                                                    vertical:
                                                                        margin),
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(
                                                                        Constants.getPercentSize(
                                                                            cellSize,
                                                                            5)),
                                                                    height:
                                                                        cellSize,
                                                                    width:
                                                                        cellSize,
                                                                    decoration: getDefaultDecoration(
                                                                        bgColor:
                                                                            cellColor,
                                                                        radius:
                                                                            radius),
                                                                    child: Image
                                                                        .network(
                                                                      "${ConstantUrl.uploadUrl}${_modelExerciseList.image}",
                                                                      width: double
                                                                          .infinity,
                                                                      height: double
                                                                          .infinity,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: ConstantWidget
                                                                        .getWidthPercentSize(
                                                                            context,
                                                                            3.5),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        ConstantWidget.getCustomTextWidget(
                                                                            _modelExerciseList
                                                                                .exerciseName!,
                                                                            textColor,
                                                                            ConstantWidget.getScreenPercentSize(context,
                                                                                1.8),
                                                                            FontWeight.bold,
                                                                            TextAlign.start,
                                                                            1),
                                                                        SizedBox(
                                                                          height: ConstantWidget.getScreenPercentSize(
                                                                              context,
                                                                              0.5),
                                                                        ),
                                                                        ConstantWidget.getTextWidget(
                                                                            "${_modelExerciseList.exerciseTime} ${S.of(context).seconds}",
                                                                            subTextColor,
                                                                            TextAlign
                                                                                .start,
                                                                            FontWeight
                                                                                .w500,
                                                                            ConstantWidget.getScreenPercentSize(context,
                                                                                1.6)),
                                                                      ],
                                                                    ),
                                                                    flex: 1,
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      showBottomDialog(
                                                                          exerciseList![
                                                                              index]);
                                                                    },
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(7),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .more_vert_rounded,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            showBottomDialog(
                                                                exerciseList![
                                                                    index]);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  animation:
                                                      animationController!,
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      } else {
                                        return getNoData(context);
                                      }
                                    } else {
                                      return getNoData(context);
                                    }
                                  } else {
                                    return getProgressDialog();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: Constants.getScreenPercentSize(context, 40),
                          decoration: getDecorationWithSide(
                              radius: ConstantWidget.getScreenPercentSize(
                                  context, 4.5),
                              bgColor: widget.bgColor,
                              isBottomLeft: true,
                              isBottomRight: true),
                          child: ScaleTransition(
                            alignment: Alignment.center,
                            scale: CurvedAnimation(
                                parent: animationController1!,
                                curve: Curves.fastOutSlowIn),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.transparent,
                              margin: EdgeInsets.only(
                                  top: ConstantWidget.getScreenPercentSize(
                                      context, 6)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(
                                        ConstantWidget.getScreenPercentSize(
                                            context, 4.5))),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.network(
                                    ConstantUrl.uploadUrl +
                                        widget._modelWorkoutList.image,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ConstantWidget.getLoginAppBar(context,
                            function: onBackClicked, infoFunction: () {
                          showInfoDialog();
                        }, isInfo: true)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: margin),
                child: ConstantWidget.getButtonWidget(
                    context, 'Start Workout', blueButton, () async {
                  if (await ConstantUrl.isLogin()) {
                    sendToNext();
                  } else {
                    if (await PrefData.getFirstSignUp() == true) {
                      Get.toNamed("/intro", arguments: () {
                        sendToNext();
                      });
                    } else {
                      ConstantUrl.sendLoginPage(context, function: () {
                        sendToNext();
                      }, argument: () {
                        Get.back();
                        sendToNext();
                      });
                    }
                  }
                }),
              ),
              SizedBox(
                height: (margin / 4),
              ),
              showBanner(adsFile),
            ],
          ),
        )),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
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
    print("exerciseList===${exerciseList!.length}");
    if (exerciseList!.length > 0) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return WidgetChallengeWorkout(exerciseList!, widget._modelWorkoutList,
              getCal, getTime, widget.day, widget.dayModel, widget.weekModel);
        },
      ));
    }
  }

  void onBackClicked() {
    Navigator.of(context).pop();
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
                        widget._modelWorkoutList.challengesName,
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
                Constants.decode(widget._modelWorkoutList.description),
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
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Image.network(
                          "${ConstantUrl.uploadUrl}${exerciseDetail.image}",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ]),
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
