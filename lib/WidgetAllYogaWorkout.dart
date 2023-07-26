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
import 'online_models/ModelWorkout.dart';

class WidgetAllYogaWorkout extends StatefulWidget {
  WidgetAllYogaWorkout();

  @override
  _WidgetAllYogaWorkout createState() => _WidgetAllYogaWorkout();
}

class _WidgetAllYogaWorkout extends State<WidgetAllYogaWorkout> {
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
              title: S.of(context).yoga,
            ),
            Expanded(
              flex: 1,
              child: FutureBuilder<ModelWorkout?>(
                future: getYogaWorkout(context),
                builder: (context, snapshot) {
                  print("getworkouts123=${snapshot.data}");

                  if (snapshot.hasData && snapshot.data != null) {
                    ModelWorkout? modelWorkout = snapshot.data;

                    if (modelWorkout!.data!.success == 1) {
                      List<Category>? workoutList = modelWorkout.data!.category;

                      return GridView.count(
                        crossAxisCount: _crossAxisCount,
                        childAspectRatio: _aspectRatio,
                        shrinkWrap: true,
                        crossAxisSpacing: _crossAxisSpacing,
                        mainAxisSpacing: _crossAxisSpacing,
                        padding: EdgeInsets.only(
                          //
                          left: _crossAxisSpacing,
                          right: _crossAxisSpacing,
                          //     bottom: _crossAxisSpacing
                        ),
                        primary: false,
                        children: List.generate(workoutList!.length, (index) {
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

                          return GestureDetector(
                            onTap: () {
                              checkIsProPlan(
                                  context: context,
                                  adsFile: adsFile!,
                                  setState: setState,
                                  isActive: _modelWorkoutList.isActive??"0",
                                  function: () {
                                    print("sendtidetail1==true");
                                    sendToWorkoutList(context,_modelWorkoutList, getCellColor(index));
                                  });
                            },
                            child: Container(
                              height: height,
                              width: ConstantWidget.getWidthPercentSize(
                                  context, 33),
                              decoration: getDefaultDecoration(
                                  radius:
                                      ConstantWidget.getPercentSize(height, 8),
                                  bgColor: getCellColor(index)),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      '${ConstantUrl.uploadUrl + _modelWorkoutList.image!}',
                                      height: ConstantWidget.getPercentSize(
                                          height, 45),
                                    ),
                                    // SizedBox(
                                    //   height: ConstantWidget.getPercentSize(
                                    //       height, 12),
                                    // ),
                                    ConstantWidget.getVerSpace(5.h),
                                    getProWidget(
                                        isActive: _modelWorkoutList.isActive??"0",
                                        context: context,
                                        horSpace: 0,
                                        verSpace: 0,
                                        alignment: Alignment.center),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              ConstantWidget.getPercentSize(
                                                  height, 2)),
                                      child:
                                          ConstantWidget.getTextWidgetWithFont(
                                              _modelWorkoutList.category!,
                                              textColor,
                                              TextAlign.start,
                                              FontWeight.bold,
                                              ConstantWidget.getPercentSize(
                                                  height, 7),
                                              Constants.fontsFamily),
                                    ),
                                    FutureBuilder<int?>(
                                      future:
                                          getTotalExercise(context, dummySend),
                                      builder: (context, snapshot) {
                                        int totalExercise = 0;
                                        if (snapshot.hasData) {
                                          totalExercise = snapshot.data!;
                                        } else {
                                          totalExercise = 0;
                                        }

                                        return ConstantWidget.getTextWidgetWithFont(
                                            "$totalExercise ${S.of(context).exercises}",
                                            textColor,
                                            TextAlign.start,
                                            FontWeight.w400,
                                            Constants.getPercentSize(height, 7),
                                            Constants.fontsFamily);
                                      },
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

    Navigator.push(context,MaterialPageRoute(
      builder: (context) {
        return WidgetWorkoutExerciseList(dummySend);
      },
    )).then((value) {
      setState(() {

      });
    });
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }
}
