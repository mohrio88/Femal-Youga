import 'dart:math';

import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../PrefData.dart';
import '../SizeConfig.dart';
import '../WidgetMyPlanExerciseList.dart';
// import '../Widgets.dart';
import '../ads/ads_file.dart';
import '../generated/l10n.dart';
import '../models/ModelDummySend.dart';
import '../models/ModelSeasonal.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/ChallengeDaysModel.dart';
import '../online_models/UserDetail.dart';

class TabMyPlan extends StatefulWidget {
  @override
  _TabMyPlan createState() => _TabMyPlan();
}

var cardAspectRatio = 16.0 / 20.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatelessWidget {
  final currentPage;
  final double padding = 20.0;
  final double verticalInset = 20.0;
  final List<ModelSeasonal> _discoverList;

  CardScrollWidget(this.currentPage, this._discoverList);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = [];

        for (var i = 0; i < 4; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);
          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            end: start,
            textDirection: Directionality.of(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: _discoverList[i].image != null &&
                        _discoverList[i].image!.length > 5
                    ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Constants.assetsImagePath +
                                _discoverList[i].image!),
                            fit: BoxFit.cover))
                    : null,
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black45,
                                Colors.black54,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(100, 0, 0, 0),
                                Color.fromARGB(50, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0),
                                child: Text(
                                  _discoverList[i].title!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: Constants.fontsFamily,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    top: 3.0,
                                    bottom: 10.0),
                                child: ConstantWidget
                                    .getTextWidgetWithFontWithMaxLine(
                                        _discoverList[i].description!,
                                        Colors.white,
                                        TextAlign.start,
                                        FontWeight.w100,
                                        13,
                                        maOneFont,
                                        3),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

class _TabMyPlan extends State<TabMyPlan> {
  var currentPage = 2 - 1.0;
  AdsFile? adsFile;
  String planId = "-1";

  int userWeight = 0;

  String output = "";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });
    getPlanId();
    super.initState();
    AppReview.getAppID.then(log);
  }

  @override
  void dispose() {
    disposeRewardedAd(adsFile);

    super.dispose();
  }

  void log(String? message) {
    if (message != null) {
      setState(() {
        output = message;
      });
      print(message);
    }
  }

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
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    double quickWorkoutHeight = SizeConfig.safeBlockHorizontal! * 42;
    double quickWorkoutSize = SizeConfig.safeBlockHorizontal! * 37;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //     padding: EdgeInsets.all(textMargin),
            //     child: getTitleTexts(context, S.of(context).bodyFitness)),
            FutureBuilder<ChallengeDaysModel?>(
              future: getChallengeDay(context, planId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ChallengeDaysModel? challengeDays = snapshot.data!;
                  if (challengeDays.data!.success == 1) {
                    List<Days>? dayList = challengeDays.data!.days;
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ListView.builder(
                        itemCount: dayList!.length,
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Days oneDay = dayList[index];
                          Color color = category1;

                          if (index % 6 == 0) {
                            color = category2;
                          } else if (index % 6 == 1) {
                            color = category3;
                          } else if (index % 6 == 2) {
                            color = category4;
                          } else if (index % 6 == 2) {
                            color = category5;
                          } else if (index % 6 == 2) {
                            color = category6;
                          } else if (index % 6 == 2) {
                            color = category7;
                          }
                          double cellSize =
                              ConstantWidget.getScreenPercentSize(context, 9);

                          double radius =
                              Constants.getScreenPercentSize(context, 2);
                          return ConstantWidget.getShadowWidget(
                            leftPadding: (textMargin / 1.7),
                            rightPadding: textMargin,
                            topPadding: (textMargin / 2),
                            bottomPadding: (textMargin / 2),
                            radius: radius,
                            horizontalMargin: (textMargin / 1.2),
                            verticalMargin: (textMargin / 2),
                            widget: GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              Constants.getPercentSize(
                                                  cellSize, 4)),
                                          height: cellSize,
                                          width: cellSize,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: oneDay.image != null &&
                                                    oneDay.image!.length > 0
                                                ? Image.network(
                                                    ConstantUrl.uploadUrl +
                                                        oneDay.image!,
                                                    fit: BoxFit.fill,
                                                    width: Constants
                                                        .getPercentSize(
                                                            cellSize, 70),
                                                    height: Constants
                                                        .getPercentSize(
                                                            cellSize, 70),
                                                  )
                                                : Container(
                                                    color: color,
                                                    width: Constants
                                                        .getPercentSize(
                                                            cellSize, 70),
                                                    height: Constants
                                                        .getPercentSize(
                                                            cellSize, 70)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ConstantWidget
                                              .getWidthPercentSize(
                                                  context, 2.5),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ConstantWidget
                                                      .getCustomTextWidget(
                                                          "Day " +
                                                              oneDay.daysName!,
                                                          textColor,
                                                          ConstantWidget
                                                              .getScreenPercentSize(
                                                                  context, 1.8),
                                                          FontWeight.bold,
                                                          TextAlign.start,
                                                          1),
                                                  getProWidget(
                                                      isActive: oneDay.isPro!,
                                                      context: context,
                                                      verSpace: 3,
                                                      horSpace: 0),
                                                ],
                                              ),
                                              SizedBox(
                                                height: ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 0.5),
                                              ),
                                              ConstantWidget.getTextWidget(
                                                  "${(int.parse(oneDay.totalSecs!) / 60).toStringAsFixed(1)} ${S.of(context).minutes} | ${(int.parse(oneDay.totalSecs!) / 60 * Constants.calDefaultCalculation * userWeight).toStringAsFixed(1)} ${S.of(context).kcal}",
                                                  subTextColor,
                                                  TextAlign.start,
                                                  FontWeight.w500,
                                                  ConstantWidget
                                                      .getScreenPercentSize(
                                                          context, 1.6)),
                                            ],
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                    (index == 0 && oneDay.is_completed == 0) ||
                                            (index > 0 &&
                                                oneDay.is_completed == 0 &&
                                                dayList[index - 1]
                                                        .is_completed ==
                                                    1)
                                        ? Container(
                                            child: ConstantWidget
                                                .getIconButtonWidget(
                                                    context, 'Start Training',
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
                                                    asset: "", () {
                                              if (oneDay.daysName == '2') {
                                                AppReview.requestReview
                                                    .then(log);
                                              }
                                              ModelDummySend dummySend =
                                                  new ModelDummySend(
                                                      oneDay.daysId!,
                                                      oneDay.daysName!,
                                                      ConstantUrl
                                                          .urlGetWorkoutExercise,
                                                      ConstantUrl.varCatId,
                                                      getCellColor(index),
                                                      oneDay.image ?? "",
                                                      true,
                                                      oneDay.description!,
                                                      CHALLENGES_WORKOUT);
                                              checkIsProPlan(
                                                  context: context,
                                                  adsFile: adsFile!,
                                                  isActive: oneDay.isPro ?? "0",
                                                  setState: setState,
                                                  function: () {
                                                    setStatusBarColor(
                                                        color.withOpacity(0.4));
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            new WidgetMyPlanExerciseList(
                                                                dummySend,
                                                                color),
                                                      ),
                                                    ).then((value) {
                                                      setState(() {});
                                                    });
                                                  });
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (context) {
                                              //     return WidgetMyPlanExerciseList(
                                              //         dummySend, color);
                                              //   },
                                              // ));
                                            }),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              onTap: () {},
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: 10,
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Color color = category1;

                        if (index % 6 == 0) {
                          color = category2;
                        } else if (index % 6 == 1) {
                          color = category3;
                        } else if (index % 6 == 2) {
                          color = category4;
                        } else if (index % 6 == 2) {
                          color = category5;
                        } else if (index % 6 == 2) {
                          color = category6;
                        } else if (index % 6 == 2) {
                          color = category7;
                        }
                        double cellSize =
                            ConstantWidget.getScreenPercentSize(context, 9);

                        double radius =
                            Constants.getScreenPercentSize(context, 2);
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: ConstantWidget.getShadowWidget(
                            leftPadding: (textMargin / 1.7),
                            rightPadding: textMargin,
                            topPadding: (textMargin / 2),
                            bottomPadding: (textMargin / 2),
                            radius: radius,
                            horizontalMargin: (textMargin / 1.2),
                            verticalMargin: (textMargin / 2),
                            widget: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                        Constants.getPercentSize(cellSize, 4)),
                                    height: cellSize,
                                    width: cellSize,
                                    decoration: getDefaultDecoration(
                                        bgColor: color, radius: radius),
                                  ),
                                  SizedBox(
                                    width: ConstantWidget.getWidthPercentSize(
                                        context, 2.5),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ConstantWidget.getCustomTextWidget(
                                                "",
                                                textColor,
                                                ConstantWidget
                                                    .getScreenPercentSize(
                                                        context, 1.8),
                                                FontWeight.bold,
                                                TextAlign.start,
                                                1),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ConstantWidget
                                              .getScreenPercentSize(
                                                  context, 0.5),
                                        ),
                                        ConstantWidget.getTextWidget(
                                            "",
                                            subTextColor,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            ConstantWidget.getScreenPercentSize(
                                                context, 1.6)),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
