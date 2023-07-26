import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_yoga_workout_4_all_new/online_models/ModelOtherWorkoutCategoryList.dart';
// import 'package:get/get.dart';
import '../ConstantWidget.dart';
import '../models/ModelDummySend.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';

import 'ads/ads_file.dart';
import 'generated/l10n.dart';
import 'onlineData/ConstantUrl.dart';
import 'onlineData/ServiceProvider.dart';
import 'online_models/ModelBodySpecificSubCategoryWorkouts.dart';
import '../PrefData.dart';
import '../online_models/UserDetail.dart';

class BodySpecificWorkoutList extends StatefulWidget {
  final ModelDummySend _modelWorkoutList;

  BodySpecificWorkoutList(this._modelWorkoutList);

  @override
  _BodySpecificWorkoutList createState() => _BodySpecificWorkoutList();
}

class _BodySpecificWorkoutList extends State<BodySpecificWorkoutList>
    with TickerProviderStateMixin {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  double getCal = 0;
  int getTime = 0;
  List? priceList;
  AdsFile? adsFile;

  int userWeight = 0;

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
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    getUserWeight();
    super.initState();

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

  List<ModelOtherWorkoutCategoryWorkout> _list = [];

  PageController controller = PageController();
  double margin = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    margin = ConstantWidget.getWidthPercentSize(context, 4);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(widget._modelWorkoutList.color),
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
                                    Constants.getScreenPercentSize(context, 30),
                                decoration: BoxDecoration(
                                  color: widget._modelWorkoutList.color,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        ConstantUrl.uploadUrl +
                                            widget._modelWorkoutList.image,
                                      ),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 15, left: 15),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20, top: 17),
                                    child: ConstantWidget.getCustomText(
                                      widget._modelWorkoutList.name,
                                      Colors.white,
                                      1,
                                      TextAlign.center,
                                      FontWeight.bold,
                                      20,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20, top: 7),
                                    child: ConstantWidget.getCustomText(
                                      "${widget._modelWorkoutList.desc} Workouts",
                                      Colors.white,
                                      1,
                                      TextAlign.center,
                                      FontWeight.w500,
                                      17,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height:
                                ConstantWidget.getScreenPercentSize(context, 2),
                          ),
                          FutureBuilder<ModelBodySpecificSubCategoryWorkouts?>(
                            future: getAllBodySpecificSubCategoryDetail(
                                context, widget._modelWorkoutList.id),
                            builder: (context, snapshot) {
                              getCal = 0;
                              getTime = 0;
                              if (snapshot.hasData) {
                                ModelBodySpecificSubCategoryWorkouts
                                    modelBodySpecificSubCategoryWorkouts =
                                    snapshot.data!;
                                if (modelBodySpecificSubCategoryWorkouts
                                        .data!.success ==
                                    1) {
                                  _list = modelBodySpecificSubCategoryWorkouts
                                      .data!.workouts!;
                                  _list.forEach((price) {
                                    getTime = getTime +
                                        int.parse(price.totalMinutes!);
                                  });
                                  getCal =
                                      Constants.calDefaultCalculation * getTime;
                                  return ListView(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: <Widget>[
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
                                                    ModelOtherWorkoutCategoryWorkout
                                                        modelOtherWorkoutCategoryWorkout =
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

                                                    return AnimatedBuilder(
                                                      builder:
                                                          (context, child) {
                                                        return FadeTransition(
                                                          opacity: animation,
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
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(radius))),
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        margin,
                                                                    vertical:
                                                                        margin),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.all(Constants.getPercentSize(
                                                                          cellSize,
                                                                          5)),
                                                                      height:
                                                                          cellSize,
                                                                      width:
                                                                          cellSize *
                                                                              1.3,
                                                                      decoration: getDefaultDecoration(
                                                                          bgColor:
                                                                              cellColor,
                                                                          radius:
                                                                              radius),
                                                                      child: Image
                                                                          .network(
                                                                        "${ConstantUrl.uploadUrl}${modelOtherWorkoutCategoryWorkout.image}",
                                                                        width: double
                                                                            .infinity,
                                                                        height:
                                                                            double.infinity,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: ConstantWidget.getWidthPercentSize(
                                                                          context,
                                                                          3.5),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          ConstantWidget.getCustomTextWidget(
                                                                              modelOtherWorkoutCategoryWorkout.workout!,
                                                                              textColor,
                                                                              ConstantWidget.getScreenPercentSize(context, 1.8),
                                                                              FontWeight.bold,
                                                                              TextAlign.start,
                                                                              1),
                                                                          SizedBox(
                                                                            height:
                                                                                ConstantWidget.getScreenPercentSize(context, 0.5),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              ConstantWidget.getTextWidget("${(int.parse(modelOtherWorkoutCategoryWorkout.totalMinutes!) / 60).toStringAsFixed(1)} mins", subTextColor, TextAlign.start, FontWeight.w500, ConstantWidget.getScreenPercentSize(context, 1.6)),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              ConstantWidget.getTextWidget("${(int.parse(modelOtherWorkoutCategoryWorkout.totalMinutes!) / 60 * Constants.calDefaultCalculation * userWeight).toStringAsFixed(1)} Kcal", redColor, TextAlign.start, FontWeight.w500, ConstantWidget.getScreenPercentSize(context, 1.6)),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      flex: 1,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .chevron_right,
                                                                      color: Colors
                                                                          .black,
                                                                      size: 16,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                sendToNext(
                                                                    _list[
                                                                        index],
                                                                    index);
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      animation:
                                                          animationController!,
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

  void sendToNext(
      ModelOtherWorkoutCategoryWorkout modelOtherWorkoutCategoryWorkout,
      int index) {
    if (_list.isNotEmpty && _list.length > 0) {
      //Get.to(WidgetWorkout(_list, widget._modelWorkoutList, getCal, getTime));

      Color color = "#99d8ef".toColor();

      int position = index;

      if (position % 4 == 0) {
        color = "#aeacf9".toColor();
      } else if (position % 4 == 1) {
        color = "#fda0dd".toColor();
      } else if (position % 4 == 2) {
        color = "#81c1fe".toColor();
      }

      checkIsProPlan(
          context: context,
          adsFile: adsFile!,
          isActive: modelOtherWorkoutCategoryWorkout.isActive!,
          setState: setState,
          function: () {
            ModelDummySend dummySend = new ModelDummySend(
                modelOtherWorkoutCategoryWorkout.workoutId!,
                modelOtherWorkoutCategoryWorkout.workout!,
                ConstantUrl.urlGetWorkoutExercise,
                ConstantUrl.paramWorkoutId,
                color,
                modelOtherWorkoutCategoryWorkout.image!,
                true,
                "", //oneOtherWorkout.desc!,
                CATEGORY_WORKOUT);

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return WidgetWorkoutExerciseList(dummySend);
              },
            ));
          });
    }
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }
}
