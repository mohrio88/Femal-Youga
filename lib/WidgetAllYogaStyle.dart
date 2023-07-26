import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ColorCategory.dart';

import 'ConstantWidget.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';
import 'ads/ads_file.dart';
import 'generated/l10n.dart';
import 'models/ModelDummySend.dart';
import 'onlineData/ConstantUrl.dart';
import 'onlineData/ServiceProvider.dart';
import 'online_models/ModelQuickWorkout.dart';
import 'online_models/ModelWorkout.dart';

class WidgetAllYogaStyle extends StatefulWidget {
  WidgetAllYogaStyle();

  @override
  _WidgetAllYogaStyle createState() => _WidgetAllYogaStyle();
}

class _WidgetAllYogaStyle extends State<WidgetAllYogaStyle> {
  @override
  void initState() {
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

  AdsFile? adsFile;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double screenWidth = SizeConfig.safeBlockHorizontal! * 100;

    int _crossAxisCount = 2;
    double _crossAxisSpacing = ConstantWidget.getScreenPercentSize(context, 2);
    var widthItem =
        (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
            _crossAxisCount;
    double height = ConstantWidget.getScreenPercentSize(context, 30);

    double _aspectRatio = widthItem / height;

    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;


    return WillPopScope(
      child: Scaffold(
        backgroundColor: bgDarkWhite,
        appBar: getColorStatusBar(bgDarkWhite),
        body: SafeArea(
            child: Column(
          children: [
            ConstantWidget.getLoginAppBar(
              context,
              function: () {
                onBackClicked();
              },
              title: S.of(context).yogaStyles,
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<ModelQuickWorkout?>(
                future: getAllYogaStyleWorkout(context),
                builder: (context, snapshot) {
                  print("getworkouts123=${snapshot.data}");

                  if (snapshot.hasData && snapshot.data != null) {
                    ModelQuickWorkout? modelWorkout = snapshot.data;

                    if (modelWorkout!.data!.success == 1) {
                      List<Quickworkout>? workoutList = modelWorkout.data!.quickworkout ?? [];

                      return Container(
                        margin: EdgeInsets.all(5),
                        child: ListView.builder(
                          itemCount: workoutList.length,
                          primary: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Quickworkout _modelQuickWorkout =
                            workoutList[index];
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

                              widget: InkWell(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   padding: EdgeInsets.all(
                                      //       Constants.getPercentSize(
                                      //           cellSize, 4)),
                                      //   height: cellSize,
                                      //   width: cellSize,
                                      //   decoration: getDefaultDecoration(
                                      //       bgColor: color, radius: radius),
                                      //   child: Image.network(
                                      //     ConstantUrl.uploadUrl +
                                      //         _modelQuickWorkout.image!,
                                      //     fit: BoxFit.contain,
                                      //     width: Constants.getPercentSize(
                                      //         cellSize, 70),
                                      //     height: Constants.getPercentSize(
                                      //         cellSize, 70),
                                      //   ),
                                      // ),


                                      Container(
                                        height: cellSize,
                                        width: cellSize,

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


                                      SizedBox(
                                        width: ConstantWidget.getWidthPercentSize(
                                            context, 3),
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
                                                        .quickworkout!,
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

                                        Navigator.push(context,MaterialPageRoute(
                                          builder: (context) {
                                            return WidgetWorkoutExerciseList(
                                                dummySend);
                                          },
                                        )).then((value) {
                                          setState(() {

                                          });
                                        });
                                      });
                                },
                              ),
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
            ),
          ],
        )),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );
  }

  void sendToWorkoutList(
      BuildContext context, Category modelWorkoutList, Color color) {
    ModelDummySend dummySend = new ModelDummySend(
        modelWorkoutList.categoryId!,
        modelWorkoutList.category!,
        ConstantUrl.urlGetWorkoutExercise,
        ConstantUrl.varCatId,
        color,
        modelWorkoutList.image!,
        true,
        modelWorkoutList.description!,
        CATEGORY_WORKOUT);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WidgetWorkoutExerciseList(dummySend);
      },
    ));
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }
}
