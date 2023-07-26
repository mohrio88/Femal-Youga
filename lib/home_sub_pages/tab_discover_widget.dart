import 'dart:math';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../SizeConfig.dart';
import '../WidgetAllYogaStyle.dart';
import '../WidgetWorkoutExerciseList.dart';
import '../Widgets.dart';
import '../ads/ads_file.dart';
import '../generated/l10n.dart';
import '../models/ModelDummySend.dart';
import '../models/ModelSeasonal.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/ModelDiscover.dart';
import '../online_models/ModelQuickWorkout.dart';
import '../online_models/ModelStretches.dart';

class TabDiscover extends StatefulWidget {
  @override
  _TabDiscover createState() => _TabDiscover();
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

class _TabDiscover extends State<TabDiscover> {
  // List<ModelSeasonal> _seasonalList = [];
  // DataHelper _dataHelper = DataHelper.instance;

  var currentPage = 2 - 1.0;
  AdsFile? adsFile;

  @override
  void initState() {
    // _dataHelper.getYogaList().then((value) {
    //   setState(() {});
    // });
    // _dataHelper.getAllSeasonalWorkoutsList().then((value) {
    //   if (value != null && value.length > 0) {
    //     setState(() {
    //       _seasonalList = value;
    //       currentPage = _seasonalList.length - 1.0;
    //     });
    //   }
    // });
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });
    super.initState();
  }

  @override
  void dispose() {
    disposeRewardedAd(adsFile);

    super.dispose();
  }

  final listController =
  AutoScrollController(axis: Axis.horizontal, suggestedRowHeight: 200);

  CarouselController buttonCarouselController = CarouselController();

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // PageController controller =
    //     PageController(initialPage: _seasonalList.length - 1);
    // controller.addListener(() {
    //   setState(() {
    //     currentPage = controller.page!;
    //   });
    // });

    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    double quickWorkoutHeight = SizeConfig.safeBlockHorizontal! * 42;
    double quickWorkoutSize = SizeConfig.safeBlockHorizontal! * 37;

    double sliderHeight = Constants.getScreenPercentSize(context, 38);
    double sliderRadius = Constants.getPercentSize(sliderHeight, 8);

    double listHeight = Constants.getScreenPercentSize(context, 4.5);

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
            // if (_seasonalList.isNotEmpty)
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: <Widget>[
                    FutureBuilder<ModelDiscover?>(
                      future: getAllDiscover(
                        context,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          ModelDiscover _modelDiscover = snapshot.data!;
                          if (_modelDiscover.data!.success == 1) {
                            List<Discover>? _discoverList =
                                _modelDiscover.data!.discover;
                            if (currentPage < 0) {
                              currentPage = _discoverList!.length - 1.0;
                            }

                            PageController controller = PageController(
                                initialPage: _discoverList!.length - 1);
                            // PageController();
                            controller.addListener(() {
                              setState(() {
                                currentPage = controller.page!;
                              });
                            });

                            // ignore: unnecessary_null_comparison
                            List<Container>? imageSliders = (_discoverList !=
                                null)
                                ? _discoverList.map((item) {
                              // Color color = "#99d8ef".toColor();

                              int position =
                                  int.parse(item.discoverId!) - 1;

                              Color color = category1;

                              if (position % 4 == 0) {
                                color = category1;
                              } else if (position % 4 == 1) {
                                color = category2;
                              } else if (position % 4 == 2) {
                                color = category3;
                              } else if (position % 4 == 2) {
                                color = category4;
                              }

                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.only(
                                    right: Constants.getWidthPercentSize(
                                        context, 4)),
                                decoration: getDefaultDecoration(
                                    bgColor: color, radius: sliderRadius),
                                // bgColor: color.withOpacity(0.4), radius: sliderRadius),
                                child: GestureDetector(
                                  onTap: () {
                                    checkIsProPlan(
                                        context: context,
                                        adsFile: adsFile!,
                                        isActive: item.isActive!,
                                        setState: setState,
                                        function: () {
                                          ModelDummySend dummySend =
                                          new ModelDummySend(
                                              item.discoverId!,
                                              item.discover!,
                                              ConstantUrl
                                                  .urlGetDiscoverExercise,
                                              ConstantUrl
                                                  .varDiscoverId,
                                              color,
                                              item.image!,
                                              false,
                                              item.description!,
                                              DISCOVER_WORKOUT);

                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) {
                                          //     return WidgetWorkoutExerciseList(
                                          //         dummySend);
                                          //   },
                                          // ));
                                          Get.to(WidgetWorkoutExerciseList(
                                              dummySend))!
                                              .then((value) {
                                            setState(() {});
                                          });
                                        });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomRight:
                                              Radius.circular(
                                                  sliderRadius)),
                                          child: Hero(
                                            tag: item.image ?? "anim",
                                            child: Image.network(
                                                ConstantUrl.uploadUrl +
                                                    item.image!),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: ConstantWidget
                                                  .getPercentSize(
                                                  sliderHeight, 10),
                                              horizontal: ConstantWidget
                                                  .getWidthPercentSize(
                                                  context, 4)),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ConstantWidget
                                                    .getTextWidgetWithFont(
                                                    item.discover!,
                                                    textColor,
                                                    TextAlign.start,
                                                    FontWeight.bold,
                                                    ConstantWidget
                                                        .getPercentSize(
                                                        sliderHeight,
                                                        6),
                                                    Constants
                                                        .chilankaFontsFamily),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: Container(),
                                                flex: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      getProWidget(
                                        isActive: item.isActive!,
                                        context: context,
                                        alignment: Alignment.topRight,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                                : null;

                            return Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: textMargin),
                                  height: listHeight * 2,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: listController,
                                    itemCount: _discoverList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return AutoScrollTag(
                                        key: ValueKey(index),
                                        controller: listController,
                                        index: index,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _current = index;
                                              buttonCarouselController
                                                  .jumpToPage(index);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: (textMargin),
                                                bottom: (listHeight / 1.5),
                                                top: (listHeight / 4),
                                                right: ((_discoverList.length -
                                                    1) ==
                                                    index)
                                                    ? textMargin
                                                    : 0),
                                            child:
                                            ConstantWidget.getShadowWidget(
                                                widget: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: ConstantWidget
                                                          .getScreenPercentSize(
                                                          context, 1)),
                                                  decoration: getDefaultDecoration(
                                                      radius: ConstantWidget
                                                          .getPercentSize(
                                                          listHeight,
                                                          30),
                                                      bgColor: _current ==
                                                          index
                                                          ? accentColor
                                                          : Colors.white),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: getCustomText(
                                                            _discoverList[
                                                            index]
                                                                .discover!,
                                                            _current ==
                                                                index
                                                                ? Colors
                                                                .white
                                                                : subTextColor,
                                                            1,
                                                            TextAlign.start,
                                                            FontWeight.w600,
                                                            Constants
                                                                .getPercentSize(
                                                                listHeight,
                                                                32)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                radius: ConstantWidget
                                                    .getPercentSize(
                                                    listHeight, 30),
                                                color: _current == index
                                                    ? accentColor
                                                    : Colors.white,
                                                isShadow: _current == index
                                                    ? false
                                                    : true),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                CarouselSlider(
                                    items: imageSliders,
                                    carouselController:
                                    buttonCarouselController,
                                    options: CarouselOptions(
                                        height: sliderHeight,
                                        autoPlay: false,
                                        pageSnapping: true,
                                        viewportFraction: 0.9,
                                        enlargeCenterPage: false,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                            listController.scrollToIndex(index);

                                            print("index---$index");
                                          });
                                        },
                                        enableInfiniteScroll: false)),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: textMargin),
                                height: listHeight * 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: listController,
                                  itemCount: 4,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return AutoScrollTag(
                                      key: ValueKey(index),
                                      controller: listController,
                                      index: index,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _current = index;
                                            buttonCarouselController
                                                .jumpToPage(index);
                                          });
                                        },
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: (textMargin),
                                                bottom: (listHeight / 1.5),
                                                top: (listHeight / 4),
                                                right: ((4 - 1) == index)
                                                    ? textMargin
                                                    : 0),
                                            child:
                                            ConstantWidget.getShadowWidget(
                                                widget: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: ConstantWidget
                                                          .getScreenPercentSize(
                                                          context, 1)),
                                                  decoration: getDefaultDecoration(
                                                      radius: ConstantWidget
                                                          .getPercentSize(
                                                          listHeight,
                                                          30),
                                                      bgColor: _current ==
                                                          index
                                                          ? accentColor
                                                          : Colors.white),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: getCustomText(
                                                            "fgddfgfgfgfgfbfgfgfytytyt",
                                                            _current ==
                                                                index
                                                                ? Colors
                                                                .white
                                                                : subTextColor,
                                                            1,
                                                            TextAlign.start,
                                                            FontWeight.w600,
                                                            Constants
                                                                .getPercentSize(
                                                                listHeight,
                                                                32)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                radius: ConstantWidget
                                                    .getPercentSize(
                                                    listHeight, 30),
                                                color: _current == index
                                                    ? accentColor
                                                    : Colors.white,
                                                isShadow: _current == index
                                                    ? false
                                                    : true),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              CarouselSlider(
                                  items: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        margin: EdgeInsets.only(
                                            right:
                                            Constants.getWidthPercentSize(
                                                context, 4)),
                                        decoration: getDefaultDecoration(
                                            bgColor: Colors.black,
                                            radius: sliderRadius),
                                      ),
                                    )
                                  ],
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                      height: sliderHeight,
                                      autoPlay: false,
                                      pageSnapping: true,
                                      viewportFraction: 0.9,
                                      enlargeCenterPage: false,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                          listController.scrollToIndex(index);

                                          print("index---$index");
                                        });
                                      },
                                      enableInfiniteScroll: false)),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            // else

            Padding(
                padding: EdgeInsets.all(textMargin),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child:
                        getTitleTexts(context, S.of(context).yogaStyles)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WidgetAllYogaStyle(),
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
            FutureBuilder<ModelQuickWorkout?>(
              future: getAllYogaStyleWorkout(
                context,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var _quickWorkout = snapshot.data!;
                  if (_quickWorkout.data!.success == 1) {
                    List<Quickworkout>? _quickWorkoutList =
                        _quickWorkout.data!.quickworkout;

                    return Container(
                      height: quickWorkoutHeight,
                      child: ListView.builder(
                        itemCount: _quickWorkoutList!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Quickworkout _modelQuickWorkout =
                          _quickWorkoutList[index];

                          double radius =
                          Constants.getPercentSize(quickWorkoutHeight, 10);

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
                                  width: quickWorkoutSize,
                                  height: double.infinity,
                                  margin: EdgeInsets.only(left: textMargin),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: ConstantWidget.getPercentSize(
                                            quickWorkoutHeight, 65),
                                        margin: EdgeInsets.only(
                                            bottom: Constants.getPercentSize(
                                                quickWorkoutHeight, 5)),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                ConstantUrl.uploadUrl +
                                                    _modelQuickWorkout.image!,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(radius)),
                                      ),
                                      ConstantWidget.getCustomText(
                                        _modelQuickWorkout.quickworkout!,
                                        textColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w600,
                                        ConstantWidget.getPercentSize(
                                            quickWorkoutHeight, 8),
                                      )
                                    ],
                                  ),
                                ),
                                getProWidget(
                                    isActive: _modelQuickWorkout.isActive!,
                                    context: context,
                                    verSpace: 5.h),
                              ],
                            ),
                            onTap: () {
                              checkIsProPlan(
                                  context: context,
                                  adsFile: adsFile!,
                                  isActive: _modelQuickWorkout.isActive!,
                                  setState: setState,
                                  function: () {
                                    ModelDummySend dummySend =
                                    new ModelDummySend(
                                        _modelQuickWorkout.quickworkoutId!,
                                        _modelQuickWorkout.quickworkout!,
                                        ConstantUrl
                                            .urlGetQuickWorkoutExercise,
                                        ConstantUrl.varQuickWorkoutId,
                                        color,
                                        _modelQuickWorkout.image!,
                                        true,
                                        _modelQuickWorkout.desc!,
                                        QUICK_WORKOUT);

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return WidgetWorkoutExerciseList(
                                            dummySend);
                                      },
                                    ));
                                  });
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container(
                    height: quickWorkoutHeight,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        double radius =
                        Constants.getPercentSize(quickWorkoutHeight, 10);

                        int position = index;

                        if (position % 4 == 0) {
                        } else if (position % 4 == 1) {
                        } else if (position % 4 == 2) {}

                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: quickWorkoutSize,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: textMargin),
                            child: Column(
                              children: [
                                Container(
                                  height: ConstantWidget.getPercentSize(
                                      quickWorkoutHeight, 65),
                                  margin: EdgeInsets.only(
                                      bottom: Constants.getPercentSize(
                                          quickWorkoutHeight, 5)),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                      BorderRadius.circular(radius)),
                                ),
                                ConstantWidget.getCustomText(
                                  "",
                                  textColor,
                                  1,
                                  TextAlign.center,
                                  FontWeight.w600,
                                  ConstantWidget.getPercentSize(
                                      quickWorkoutHeight, 8),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            Padding(
                padding: EdgeInsets.all(textMargin),
                child: getTitleTexts(context, S.of(context).bodyFitness)),
            FutureBuilder<ModelStretches?>(
              future: getAllStretch(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ModelStretches? modelStretch = snapshot.data!;
                  if (modelStretch.data!.success == 1) {
                    List<Stretches> _quickWorkoutList =
                    modelStretch.data!.stretches!;
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: ListView.builder(
                        itemCount: _quickWorkoutList.length,
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Stretches _modelQuickWorkout =
                          _quickWorkoutList[index];
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                          Constants.getPercentSize(
                                              cellSize, 4)),
                                      height: cellSize,
                                      width: cellSize,
                                      decoration: getDefaultDecoration(
                                          bgColor: color, radius: radius),
                                      child: Image.network(
                                        ConstantUrl.uploadUrl +
                                            _modelQuickWorkout.image!,
                                        fit: BoxFit.contain,
                                        width: Constants.getPercentSize(
                                            cellSize, 70),
                                        height: Constants.getPercentSize(
                                            cellSize, 70),
                                      ),
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
                                              ConstantWidget
                                                  .getCustomTextWidget(
                                                  _modelQuickWorkout
                                                      .stretches!,
                                                  textColor,
                                                  ConstantWidget
                                                      .getScreenPercentSize(
                                                      context, 1.8),
                                                  FontWeight.bold,
                                                  TextAlign.start,
                                                  1),
                                              getProWidget(
                                                  isActive: _modelQuickWorkout
                                                      .isActive!,
                                                  context: context,
                                                  verSpace: 3.h,
                                                  horSpace: 0),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ConstantWidget
                                                .getScreenPercentSize(
                                                context, 0.5),
                                          ),
                                          ConstantWidget.getTextWidget(
                                              "${_modelQuickWorkout.totalExercise} ${S.of(context).seconds}",
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
                              ),
                              onTap: () {
                                checkIsProPlan(
                                    context: context,
                                    adsFile: adsFile!,
                                    isActive: _modelQuickWorkout.isActive!,
                                    setState: setState,
                                    function: () {
                                      ModelDummySend dummySend =
                                      new ModelDummySend(
                                          _modelQuickWorkout.stretchesId!,
                                          _modelQuickWorkout.stretches!,
                                          ConstantUrl
                                              .urlGetStretchesExercise,
                                          ConstantUrl.varStretchesId,
                                          color,
                                          _modelQuickWorkout.image!,
                                          true,
                                          _modelQuickWorkout.description!,
                                          STRETCH_WORKOUT);
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return WidgetWorkoutExerciseList(
                                              dummySend);
                                        },
                                      )).then((value) {
                                        setState(() {});
                                      });
                                    });

                                // ModelDummySend dummySend =
                                // new ModelDummySend(
                                //     _modelQuickWorkout.stretchesId!,
                                //     _modelQuickWorkout.stretches!,
                                //     ConstantUrl
                                //         .urlGetStretchesExercise,
                                //     ConstantUrl.varStretchesId,
                                //     color,
                                //     _modelQuickWorkout.image!,
                                //     true,
                                //     _modelQuickWorkout.description!,
                                //     STRETCH_WORKOUT);
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(
                                //   builder: (context) {
                                //     return WidgetWorkoutExerciseList(
                                //         dummySend);
                                //   },
                                // ));
                              },
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
