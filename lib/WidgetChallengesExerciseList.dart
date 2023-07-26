import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../models/ModelHistory.dart';
import '../onlineData/ConstantUrl.dart';
import '../online_models/ChallengeDaysModel.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'WidgetChallengeExerciseSecList.dart';
import 'Widgets.dart';
import 'ads/ads_file.dart';
import 'db/DataHelper.dart';
import 'generated/l10n.dart';
import 'onlineData/ServiceProvider.dart';
import 'online_models/ChallengeWeekModel.dart';
import 'online_models/ModelAllChallenge.dart';

class WidgetChallengesExerciseList extends StatefulWidget {
  final Challenge _modelWorkoutList;
  final Color? bgColor;

  WidgetChallengesExerciseList(this._modelWorkoutList, {this.bgColor});

  @override
  _WidgetChallengesExerciseList createState() =>
      _WidgetChallengesExerciseList();
}

class _WidgetChallengesExerciseList
    extends State<WidgetChallengesExerciseList> {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;
  // double getCal = 0;
  // int getTime = 0;
  int getTotalWorkout = 0;
  // List<ModelHistory> priceList = [];
  int lastWeek = 1, lastDay = 1;

  Days? days;

  int totalAllDays = 0;
  String weekId = "";
  String lastDayId = "";

  DataHelper _dataHelper = DataHelper.instance;

  int setWeek = 0;
  int setDay = 0;
  int openWeek = 0;
  Week? week;

  void sendToWorkoutList(
      BuildContext context, int day, int week, Days days, Week weekModel) {
    print(
        "day----$day---$week---${days.daysId}----${days.weekId}----${weekModel.totalDays}---${weekModel.weekId}");
    Route route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          WidgetChallengeExerciseSecList(
        widget._modelWorkoutList,
        day,
        week,
        days,
        weekModel,
        bgColor: widget.bgColor,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
    Navigator.of(context).push(route);
  }

  // void _calcTotal() async {
    // priceList = await _dataHelper.calculateTotalWorkout() ?? [];
    // if (priceList.length > 0) {
    //   getTotalWorkout = priceList.length;
    //   priceList.forEach((price) {
    //     getCal = getCal + double.parse(price.kCal!);
    //   });
    //   getTime = getTotalWorkout * 2;
    //   setState(() {});
    // }
  // }

  AdsFile? adsFile;

  @override
  @override
  void initState() {
    // _calcTotal();

    super.initState();
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createInterstitialAd();
      adsFile!.createAnchoredBanner(context, setState);
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
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    disposeInterstitialAd(adsFile);
    disposeBannerAd(adsFile);
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


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print("heroImage------${widget._modelWorkoutList.challengesName}");
    double screenHeight = SizeConfig.safeBlockVertical! * 100;
    double margin = ConstantWidget.getWidthPercentSize(context, 4);
    double radius = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 6.5);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(widget.bgColor),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            bottom: true,
            child: Container(
              height: double.infinity,
              color: Colors.white,
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
                              color: bgDarkWhite,
                              margin: EdgeInsets.only(
                                  top: Constants.getPercentSize(
                                      screenHeight, 45)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: margin),
                                    child: ConstantWidget.getTextWidget(
                                        widget._modelWorkoutList.challengesName,
                                        Colors.black,
                                        TextAlign.start,
                                        FontWeight.bold,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 2.5)),
                                  ),
                                  SizedBox(
                                    height: Constants.getScreenPercentSize(
                                        context, 1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: margin),
                                    child: ConstantWidget.getTextWidgetWithFont(
                                        "${widget._modelWorkoutList.totalweek} ${S.of(context).week}",
                                        textColor,
                                        TextAlign.start,
                                        FontWeight.w400,
                                        Constants.getScreenPercentSize(
                                            context, 2),
                                        Constants.chilankaFontsFamily),
                                  ),
                                  SizedBox(
                                    height: Constants.getScreenPercentSize(
                                        context, 1),
                                  ),
                                  Container(
                                    child: FutureBuilder<ChallengeWeekModel?>(
                                      future: getChallengeWeek(
                                          context,
                                          widget
                                              ._modelWorkoutList.challengesId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          ChallengeWeekModel?
                                              challengeWeekModel =
                                              snapshot.data;
                                          if (challengeWeekModel!
                                                  .data!.success ==
                                              1) {
                                            List<Week>? weekList =
                                                challengeWeekModel.data!.week;

                                            return ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 40),
                                              itemCount: weekList!.length,
                                              itemBuilder:
                                                  (context, weekPosition) {
                                                // int week = weekPosition;

                                                Week weekModel =
                                                    weekList[weekPosition];

                                                var _crossAxisSpacing =
                                                    ConstantWidget
                                                        .getScreenPercentSize(
                                                            context, 2.5);
                                                var screenWidth = SizeConfig
                                                        .safeBlockHorizontal! *
                                                    65;
                                                var _crossAxisCount = 4;
                                                var _width = (screenWidth -
                                                        ((_crossAxisCount - 1) *
                                                            _crossAxisSpacing)) /
                                                    _crossAxisCount;
                                                var cellHeight = ConstantWidget
                                                        .getWidthPercentSize(
                                                            context, 100) /
                                                    9;
                                                var _aspectRatio =
                                                    _width / cellHeight;
                                                if (lastWeek ==
                                                    (weekPosition + 1)) {
                                                  totalAllDays =
                                                      weekModel.totalDays!;
                                                  weekId = weekModel.weekId!;
                                                  week = weekModel;
                                                }

                                                double padding = ConstantWidget
                                                    .getWidthPercentSize(
                                                        context, 4);

                                                if (openWeek == weekPosition) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: ConstantWidget
                                                          .getScreenPercentSize(
                                                              context, 2.5),
                                                    ),
                                                    child: ConstantWidget
                                                        .getShadowWidget(
                                                            margin: margin,
                                                            bottomPadding:
                                                                padding,
                                                            radius: ConstantWidget
                                                                .getScreenPercentSize(
                                                                    context, 2),
                                                            leftPadding:
                                                                padding,
                                                            rightPadding:
                                                                padding,
                                                            topPadding: padding,
                                                            widget: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ConstantWidget.getTextWidgetWithFont(
                                                                    "${weekModel.weekName}",
                                                                    textColor,
                                                                    TextAlign
                                                                        .start,
                                                                    FontWeight
                                                                        .bold,
                                                                    Constants
                                                                        .getPercentSize(
                                                                            height,
                                                                            25),
                                                                    Constants.chilankaFontsFamily),
                                                                SizedBox(
                                                                  height: ConstantWidget
                                                                      .getScreenPercentSize(
                                                                          context,
                                                                          2),
                                                                ),
                                                                FutureBuilder<
                                                                    ChallengeDaysModel?>(
                                                                  future: getChallengeDay(
                                                                      context,
                                                                      weekModel
                                                                          .weekId!),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                        .hasData) {
                                                                      ChallengeDaysModel?
                                                                          challengeWeekModel =
                                                                          snapshot
                                                                              .data;
                                                                      if (challengeWeekModel!
                                                                              .data!
                                                                              .success ==
                                                                          1) {
                                                                        List<Days>?
                                                                            dayList =
                                                                            challengeWeekModel.data!.days;

                                                                        if ((dayList !=
                                                                                null &&
                                                                            dayList.isNotEmpty)) {
                                                                          return GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (week != null && days != null) {
                                                                                sendToWorkoutList(context, lastDay, lastWeek, days!, week!);
                                                                              }
                                                                            },
                                                                            child:
                                                                                GridView.count(
                                                                              crossAxisCount: _crossAxisCount,
                                                                              shrinkWrap: true,
                                                                              primary: false,
                                                                              physics: new NeverScrollableScrollPhysics(),
                                                                              mainAxisSpacing: _crossAxisSpacing,
                                                                              crossAxisSpacing: _crossAxisSpacing,
                                                                              childAspectRatio: _aspectRatio,
                                                                              children: List.generate((dayList.length + 1), (i) {
                                                                                Color txtColor = textColor;
                                                                                Color setColor = cellColor;

                                                                                days = dayList[0];
                                                                                print("lastAll----$lastDay----$lastWeek");

                                                                                if (i != dayList.length) {
                                                                                  if (weekModel.isCompleted != 1) {
                                                                                    if (i > 0) {
                                                                                      if (dayList[i - 1].is_completed == 1) {
                                                                                        // print("days_is-------${dayList[i].daysId}");
                                                                                        setColor = textColor;
                                                                                        txtColor = Colors.white;
                                                                                        days = dayList[i];
                                                                                        lastDay = i + 1;
                                                                                        lastWeek = weekPosition + 1;
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }

                                                                                return (i == dayList.length)
                                                                                    ? Center(
                                                                                        child: SvgPicture.asset(
                                                                                          Constants.assetsImagePath + "trophy_1.svg",
                                                                                          height: ConstantWidget.getPercentSize(cellHeight, 80),
                                                                                          color: weekModel.isCompleted == 1 ? Colors.orange : Colors.grey,
                                                                                        ),
                                                                                      )
                                                                                    : GestureDetector(
                                                                                        onTap: () {},
                                                                                        child: Container(
                                                                                          height: cellHeight,
                                                                                          width: cellHeight,
                                                                                          decoration: getDefaultDecoration(bgColor: (weekModel.isCompleted == 1 || dayList[i].is_completed == 1) ? Colors.green : setColor, radius: ConstantWidget.getPercentSize(cellHeight, 30)),
                                                                                          child: Center(
                                                                                            child: ConstantWidget.getTextWidget((i + 1).toString(), (weekModel.isCompleted == 1 || dayList[i].is_completed == 1) ? Colors.white : txtColor, TextAlign.center, FontWeight.w500, ConstantWidget.getPercentSize(cellHeight, 40)),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                              }),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          return Container();
                                                                        }
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    } else {
                                                                      return getProgressDialog();
                                                                    }
                                                                  },
                                                                ),
                                                              ],
                                                            )),
                                                  );
                                                } else {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        openWeek = weekPosition;
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: ConstantWidget
                                                              .getScreenPercentSize(
                                                                  context, 2.5),
                                                          right: margin,
                                                          left: margin),
                                                      height: height,
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: ConstantWidget
                                                              .getWidthPercentSize(
                                                                  context, 4)),
                                                      decoration:
                                                          getDefaultDecoration(
                                                              radius: radius,
                                                              bgColor:
                                                                  cellColor),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: ConstantWidget.getTextWidgetWithFont(
                                                                "${weekModel.weekName}",
                                                                subTextColor,
                                                                TextAlign.start,
                                                                FontWeight.bold,
                                                                Constants
                                                                    .getPercentSize(
                                                                        height,
                                                                        25),
                                                                Constants
                                                                    .chilankaFontsFamily),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            color: subTextColor,
                                                            size: Constants
                                                                .getPercentSize(
                                                                    height, 40),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return getProgressDialog();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height:
                                  Constants.getScreenPercentSize(context, 40),
                              decoration: getDecorationWithSide(
                                  radius: ConstantWidget.getScreenPercentSize(
                                      context, 4.5),
                                  bgColor: widget.bgColor,
                                  isBottomLeft: true,
                                  isBottomRight: true),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.only(
                                    top: ConstantWidget.getScreenPercentSize(
                                        context, 6)),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(
                                            ConstantWidget.getScreenPercentSize(
                                                context, 4.5))),
                                    child: Hero(
                                      tag: widget._modelWorkoutList.challengesName,
                                      child: Image.network(
                                        ConstantUrl.uploadUrl +
                                            widget._modelWorkoutList.image,
                                        fit: BoxFit.contain,
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
                        context, 'Go', blueButton, () {
                      showInterstitialAd(adsFile, () {
                        if (week != null && days != null) {
                          sendToWorkoutList(
                              context, lastDay, lastWeek, days!, week!);
                        }
                      });
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

  void onBackClicked() {
    setStatusBarColor(bgDarkWhite);
    Navigator.of(context).pop();
  }
}
