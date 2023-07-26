import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/BodySpesificWorkoutList.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:shimmer/shimmer.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../SizeConfig.dart';
// import '../WidgetAllYogaStyle.dart';
import '../WidgetWorkoutExerciseList.dart';
// import '../Widgets.dart';
import '../ads/ads_file.dart';
// import '../generated/l10n.dart';
import '../models/ModelDummySend.dart';
import '../models/ModelSeasonal.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/ModeBodySpecificCategory.dart';
// import '../online_models/ModelDiscover.dart';
import '../online_models/ModelOtherWorkoutCategoryList.dart';
// import '../online_models/ModelQuickWorkout.dart';
// import '../online_models/ModelStretches.dart';

import '../PrefData.dart';
import '../online_models/UserDetail.dart';

class TabWorkout extends StatefulWidget {
  @override
  _TabWorkout createState() => _TabWorkout();
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
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Constants.assetsImagePath +
                            _discoverList[i].image!),
                        fit: BoxFit.cover)),
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

class _TabWorkout extends State<TabWorkout> {
  // List<ModelSeasonal> _seasonalList = [];
  // DataHelper _dataHelper = DataHelper.instance;

  var currentPage = 2 - 1.0;
  AdsFile? adsFile;

  double sliderHeight = 1;
  double sliderRadius = 1;
  double listHeight = 1;
  double textMargin = 1;
  double quickWorkoutHeight = 1;
  double quickWorkoutSize = 1;
  double otherWoroutItemHeight = 1;
  double otherWorkoutItemImageHeight = 1;

  List<Widget> items = [];

  int userWeight = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });
    getBodySpecificWorkouts();
    getOtherWorkouts();
    getUserWeight();
    super.initState();
  }

  getUserWeight() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      userWeight = int.parse(userDetail.weight.toString());

      setState(() {});
    }
    ;
  }

  @override
  void dispose() {
    disposeRewardedAd(adsFile);

    super.dispose();
  }

  getBodySpecificWorkouts() async {
    var snapshot = await getAllBodySpecificCategory(
      context,
    );
    if (snapshot!.data != null) {
      var _bodySpecificCategory = snapshot.data!;
      if (_bodySpecificCategory.success == 1) {
        List<BodySpecificCategory>? _bodySpecificCategoryList =
            _bodySpecificCategory.category;
        var workOutItem = Container(
          height: quickWorkoutHeight,
          child: ListView.builder(
            itemCount: _bodySpecificCategoryList!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              BodySpecificCategory _bodySpecificCategory =
                  _bodySpecificCategoryList[index];

              Color color = "#99d8ef".toColor();
              int position = index;
              if (position % 4 == 0) {
                color = "#aeacf9".toColor();
              } else if (position % 4 == 1) {
                color = "#fda0dd".toColor();
              } else if (position % 4 == 2) {
                color = "#81c1fe".toColor();
              }

              return GestureDetector(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      //width: quickWorkoutSize,

                      margin: EdgeInsets.only(left: textMargin, right: 10),
                      child: Column(
                        children: [
                          Container(
                            height: ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 60),
                            width: ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 60),
                            margin: EdgeInsets.only(
                                bottom: Constants.getPercentSize(
                                    quickWorkoutHeight, 5)),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    ConstantUrl.uploadUrl +
                                        _bodySpecificCategory.image!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                border: Border.all(color: color),
                                borderRadius: BorderRadius.circular(
                                    ConstantWidget.getPercentSize(
                                        quickWorkoutHeight, 60))),
                          ),
                          Container(
                            width: ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 60),
                            child: Text(
                              _bodySpecificCategory.category!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: ConstantWidget.getPercentSize(
                                    quickWorkoutHeight, 8),
                                color: Colors.black,
                                fontFamily: Constants.fontsFamily,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ConstantWidget.getCustomText(
                            "${_bodySpecificCategory.totalWorkOuts} workouts",
                            textColor,
                            1,
                            TextAlign.center,
                            FontWeight.w400,
                            ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 7),
                          )
                        ],
                      ),
                    ),
                    getBodyWorkoutProWidget(
                        isActive: _bodySpecificCategory.isActive ?? "0",
                        context: context,
                        quickWorkoutHeight: quickWorkoutHeight,
                        color: color),
                  ],
                ),
                onTap: () {
                  checkIsProPlan(
                      context: context,
                      adsFile: adsFile!,
                      isActive: _bodySpecificCategory.isActive!,
                      setState: setState,
                      function: () {
                        ModelDummySend dummySend = new ModelDummySend(
                            _bodySpecificCategory.categoryId!,
                            _bodySpecificCategory.category!,
                            ConstantUrl.urlGetQuickWorkoutExercise,
                            ConstantUrl.varQuickWorkoutId,
                            color,
                            _bodySpecificCategory.image!,
                            true,
                            _bodySpecificCategory.totalWorkOuts!,
                            QUICK_WORKOUT);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return BodySpecificWorkoutList(dummySend);
                          },
                        ));
                      });
                },
              );
            },
          ),
        );
        var workOutTitle = Container(
          padding: EdgeInsets.only(left: 10, bottom: 15),
          child: ConstantWidget.getCustomText(
            "Body Specific",
            Colors.black87,
            1,
            TextAlign.center,
            FontWeight.bold,
            ConstantWidget.getPercentSize(quickWorkoutHeight, 10),
          ),
        );
        if (items.length > 0) {
          items.insert(0, workOutTitle);
          items.insert(1, workOutItem);
        } else {
          items.add(workOutTitle);
          items.add(workOutItem);
        }
        setState(() {});
      }
    }
  }

  addOneOtherWorkOut(ModelOtherWorkoutCategory otherWorkoutCategory) {
    List<ModelOtherWorkoutCategoryWorkout> workouts =
        otherWorkoutCategory.workouts ?? [];
    var oneItem = Container(
      height: otherWoroutItemHeight,
      child: ListView.builder(
        itemCount: workouts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          ModelOtherWorkoutCategoryWorkout oneOtherWorkout = workouts[index];

          double radius = Constants.getPercentSize(quickWorkoutHeight, 10);

          Color color = "#99d8ef".toColor();

          int position = index;

          if (position % 4 == 0) {
            color = "#aeacf9".toColor();
          } else if (position % 4 == 1) {
            color = "#fda0dd".toColor();
          } else if (position % 4 == 2) {
            color = "#81c1fe".toColor();
          }

          return GestureDetector(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: otherWorkoutItemImageHeight * 1.4,
                  height: double.infinity,
                  margin: EdgeInsets.only(left: textMargin),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: otherWorkoutItemImageHeight,
                        margin: EdgeInsets.only(
                            bottom: Constants.getPercentSize(
                                quickWorkoutHeight, 5)),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                ConstantUrl.uploadUrl + oneOtherWorkout.image!,
                              ),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(radius)),
                      ),
                      ConstantWidget.getCustomText(
                        oneOtherWorkout.workout!,
                        textColor,
                        2,
                        TextAlign.left,
                        FontWeight.w600,
                        ConstantWidget.getPercentSize(quickWorkoutHeight, 8),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          ConstantWidget.getCustomText(
                            "${(int.parse(oneOtherWorkout.totalMinutes!) / 60).toStringAsFixed(1)} mins",
                            textColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 7),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          ConstantWidget.getCustomText(
                            "${(int.parse(oneOtherWorkout.totalMinutes!) / 60 * Constants.calDefaultCalculation * userWeight).toStringAsFixed(1)} Kcal",
                            redColor,
                            1,
                            TextAlign.center,
                            FontWeight.w600,
                            ConstantWidget.getPercentSize(
                                quickWorkoutHeight, 7),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                getProWidget(
                    isActive: oneOtherWorkout.isActive!,
                    context: context,
                    verSpace: 5.h),
              ],
            ),
            onTap: () {
              print(oneOtherWorkout.description);
              checkIsProPlan(
                  context: context,
                  adsFile: adsFile!,
                  isActive: oneOtherWorkout.isActive!,
                  setState: setState,
                  function: () {
                    ModelDummySend dummySend = new ModelDummySend(
                        oneOtherWorkout.workoutId!,
                        oneOtherWorkout.workout!,
                        ConstantUrl.urlGetQuickWorkoutExercise,
                        ConstantUrl.varQuickWorkoutId,
                        color,
                        oneOtherWorkout.image!,
                        true,
                        oneOtherWorkout.description ??
                            "", //oneOtherWorkout.desc!,
                        QUICK_WORKOUT);

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return WidgetWorkoutExerciseList(dummySend);
                      },
                    ));
                  });
            },
          );
        },
      ),
    );
    var workOutTitle = Container(
      padding: EdgeInsets.only(left: 10, bottom: 15, top: 30),
      child: ConstantWidget.getCustomText(
        "${otherWorkoutCategory.category}",
        Colors.black87,
        1,
        TextAlign.center,
        FontWeight.bold,
        ConstantWidget.getPercentSize(quickWorkoutHeight, 10),
      ),
    );
    items.add(workOutTitle);
    items.add(oneItem);
  }

  getOtherWorkouts() async {
    var otherWorkOuts = await getAllOtherWorkoutCategoies(context);
    if (otherWorkOuts!.data != null) {
      var _quickWorkout = otherWorkOuts.data!;
      if (_quickWorkout.success == 1) {
        for (var i = 0; i < otherWorkOuts.data!.category!.length; i++) {
          addOneOtherWorkOut(otherWorkOuts.data!.category![i]);
        }
      }
    }
    setState(() {});
  }

  final listController =
      AutoScrollController(axis: Axis.horizontal, suggestedRowHeight: 200);

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    sliderHeight = Constants.getScreenPercentSize(context, 38);
    sliderRadius = Constants.getPercentSize(sliderHeight, 8);
    listHeight = Constants.getScreenPercentSize(context, 4.5);
    textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    quickWorkoutHeight = SizeConfig.safeBlockHorizontal! * 42;
    quickWorkoutSize = SizeConfig.safeBlockHorizontal! * 37;
    otherWoroutItemHeight = SizeConfig.safeBlockHorizontal! * 67;
    otherWorkoutItemImageHeight = SizeConfig.safeBlockHorizontal! * 50;

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      ),
    );
  }
}
