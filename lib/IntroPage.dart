import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yoga_workout_4_all_new/LineChartWidget.dart';
import 'package:flutter_yoga_workout_4_all_new/SignFinalPage.dart';
import 'package:flutter_yoga_workout_4_all_new/util/labeledCheckbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';
import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'generated/l10n.dart';
import 'onlineData/ConstantUrl.dart';
import 'online_models/GuideIntroModel.dart';
import 'online_models/IntensivelyModel.dart';

class IntroPage extends StatefulWidget {
  final GuideIntroModel introModel;
  final Function function;
  IntroPage(this.introModel, this.function);
  @override
  _IntroPage createState() {
    return _IntroPage();
  }
}

class _IntroPage extends State<IntroPage> {
  List<int> list = [1, 2, 3, 4, 5, 6, 7];
  int sliderPosition = 0;
  int cm = 154;
  int age = 20;
  int inch = 25;
  int ft = 25;
  int kg = 25;
  int desiredkg = 25;
  double lbs = 25;
  double desiredlbs = 25;
  double margin = 0;
  int selectIntensively = 0;
  int selectTimeInWeek = 0;

  int genderPosition = 0;
  String gender = "Male";
  List<IntensivelyModel> intensivelyList = ConstantUrl.getIntensivelyModel();

  List<IntensivelyModel> timeInWeekList = ConstantUrl.getTimeInWeekModel();

  List<String> countryList = ["India", "Germany", "London", "America"];
  List<String> cityList = ["Surat", "Delhi", "Bangalore", "Mumbai"];
  String country = "United Kingdom";
  String city = "Bangalore";
  String state = "Bangalore";
  String yourBmi = "";
  String yourDesiredBmi = "";
  List<bool> selectedAreas = [false, false, false, false, false];

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }

  PageController controller = PageController();

  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();

    setLbsValue();
    Timer(Duration(seconds: 1), () {
      setState(() {
        //widgetList.add(getUserName());
        widgetList.add(getAge());
        //widgetList.add(getGender());

        widgetList.add(heightWidget());
        widgetList.add(getWeight(false));
        widgetList.add(getWeight(true));
        widgetList.add(getIntensively());
        widgetList.add(getAreas());
        widgetList.add(LineChartWidget());
        //widgetList.add(getTimeInWeek());
        //widgetList.add(getDetail());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    margin = ConstantWidget.getWidthPercentSize(context, 1.5);

    return GestureDetector(
        child: WillPopScope(
            child: Scaffold(
              backgroundColor: bgDarkWhite,
              appBar: AppBar(
                backgroundColor: bgDarkWhite,
                elevation: 0,
                title: Text(""),
                leading: GestureDetector(
                  child: Icon(
                    CupertinoIcons.left_chevron,
                    color: Colors.black,
                  ),
                  onTap: _requestPop,
                ),
              ),
              body: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Expanded(
                        child: PageView.builder(
                      itemCount: list.length,
                      controller: controller,
                      onPageChanged: (value) {
                        setState(() {
                          sliderPosition = value;
                        });
                      },
                      itemBuilder: (context, index) {
                        return widgetList.length > 0
                            ? widgetList[index]
                            : Container();
                      },
                    )),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: margin),
                      padding: EdgeInsets.only(bottom: margin),
                      child: Column(
                        children: [
                          Visibility(
                            child: ConstantWidget.getIntroButtonWidget(
                                context, 'Done', accentColor, () {
                              actionDone(widget.function);
                            }),
                            visible: (sliderPosition == (list.length - 1)),
                          ),
                          Visibility(
                            child: ConstantWidget.getButtonWidget(
                                context, 'Next', accentColor, () {
                              actionNext();
                            }),
                            visible: (sliderPosition != (list.length - 1)),
                          ),
                          Visibility(
                            child: ConstantWidget.getBorderButtonWidget(
                                context, 'Previous', () {
                              actionPrevious();
                            }),
                            visible: (sliderPosition != 0),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onWillPop: _requestPop),
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        });
  }

  actionNext() {
    focusRemove();
    setState(() {
      if (sliderPosition < list.length) {
        sliderPosition++;
        if (sliderPosition == 6) {
          bool isOneSelected = selectedAreas.contains(true);
          if (isOneSelected == false) {
            _showToast("Please select at least one Area");
            controller.jumpTo(5);
            sliderPosition = 5;
          }
        }

        controller.jumpToPage(sliderPosition);
      }
    });
  }

  focusRemove() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  actionDone(Function function) {
    focusRemove();
    widget.introModel.age = age.toString();
    widget.introModel.height = cm.toString();
    widget.introModel.weight = kg.toString();
    widget.introModel.desiredWeight = desiredkg.toString();
    widget.introModel.intensively = selectIntensively.toString();
    widget.introModel.areas = selectedAreas.join(",");
    Navigator.push(context, MaterialPageRoute(
      builder: (c) {
        return SignUpFinalPage(widget.introModel);
      },
    ));
    //checkNetwork();
  }

  _showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  actionPrevious() {
    focusRemove();
    setState(() {
      sliderPosition--;
      controller.jumpToPage(sliderPosition);
    });
  }

  Widget getDetail() {
    return Container(
      margin: EdgeInsets.all(margin),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: getHeaderView(S.of(context).address, ""),
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 3),
          ),
          SizedBox(
            height: margin,
          )
        ],
      ),
    );
  }

  Widget getWeight(bool isDesired) {
    double height = ConstantWidget.getWidthPercentSize(context, 35);
    double cellHeight = ConstantWidget.getWidthPercentSize(context, 12);
    double subHeight = ConstantWidget.getWidthPercentSize(context, 32);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.all(margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeaderView(
                  isDesired == true
                      ? S.of(context).whatIsYourTargetWeight
                      : S.of(context).whatIsYourWeight,
                  isDesired == false
                      ? S.of(context).toGiveYouABetterExperienceNweNeedToKnow
                      : ""),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 1),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: (height * 1.3),
                    width: height,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getScreenPercentSize(context, 1)),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getScreenPercentSize(context, 2.5)),
                    child: Stack(
                      children: [
                        Container(
                          width: (subHeight * 1.2),
                          height: subHeight,
                          margin: EdgeInsets.only(top: cellHeight / 2),
                          padding: EdgeInsets.only(
                              left: cellHeight / 2, bottom: cellHeight / 3),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ConstantWidget.getTextWidget(
                                  isDesired == false
                                      ? kg.toString()
                                      : desiredkg.toString(),
                                  Colors.black,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 25)),
                              ConstantWidget.getTextWidget(
                                  'Kg',
                                  accentColor,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ],
                          ),
                        ),
                        Container(
                          width: cellHeight,
                          height: cellHeight,
                          margin: EdgeInsets.only(left: (cellHeight / 2)),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(ConstantWidget.getPercentSize(
                                  cellHeight, 30)),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              Constants.assetsImagePath + "dumbbell.png",
                              height:
                                  ConstantWidget.getPercentSize(cellHeight, 40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: (height * 1.3),
                    width: height,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getScreenPercentSize(context, 1)),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getScreenPercentSize(context, 2.5)),
                    child: Stack(
                      children: [
                        Container(
                          width: (subHeight * 1.2),
                          height: subHeight,
                          margin: EdgeInsets.only(top: cellHeight / 2),
                          padding: EdgeInsets.only(
                              left: cellHeight / 2, bottom: cellHeight / 3),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Expanded(
                              //   child:
                              ConstantWidget.getTextWidget(
                                  isDesired == false
                                      ? lbs.toInt().toString()
                                      : desiredlbs.toInt().toString(),
                                  Colors.black,
                                  TextAlign.start,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 25)),
                              // ),
                              ConstantWidget.getTextWidget(
                                  'Lbs',
                                  accentColor,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ],
                          ),
                        ),
                        Container(
                          width: cellHeight,
                          height: cellHeight,
                          margin: EdgeInsets.only(left: (cellHeight / 2)),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(ConstantWidget.getPercentSize(
                                  cellHeight, 30)),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              Constants.assetsImagePath + "weighing-scale.png",
                              height:
                                  ConstantWidget.getPercentSize(cellHeight, 40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: ConstantWidget.getWidthPercentSize(context, 70),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: NumberPicker(
                      value: isDesired == false ? kg : desiredkg,
                      minValue: 20,
                      maxValue: 250,
                      textStyle: TextStyle(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 2),
                          color: Colors.black,
                          fontFamily: Constants.fontsFamily),
                      selectedTextStyle: TextStyle(
                        fontSize:
                            ConstantWidget.getScreenPercentSize(context, 3),
                        color: redColor,
                        fontFamily: Constants.fontsFamily,
                      ),
                      step: 1,
                      haptics: true,
                      onChanged: (value) => setState(() {
                        isDesired == false ? kg = value : desiredkg = value;
                        setLbsValue();
                      }),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDesired == false ? "Your BMI:" : "Your Taget BMI:",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            isDesired == false ? yourBmi : yourDesiredBmi,
                            style: TextStyle(
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                color: redColor),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Calculated on the\ninformation you have\ngiven.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  setLbsValue() {
    lbs = kg * 2.205;
    lbs = double.parse((lbs).toStringAsFixed(0));
    yourBmi = (kg * 10000 / (cm * cm)).toStringAsFixed(1);

    desiredlbs = desiredkg * 2.205;
    sharedDesiredWeight = desiredlbs.toStringAsFixed(0) + "lbs";
    desiredlbs = double.parse((desiredlbs).toStringAsFixed(0));

    yourDesiredBmi = (desiredkg * 10000 / (cm * cm)).toStringAsFixed(1);

    double total = (cm / 2.54);
    double value = (total / 12);
    double value1 = (cm / 30.48);
    // double value1 = (total - 12) * value.toInt();

    ft = value1.toInt();
    // ft = value.toInt();
    inch = getDecimalPlaces(value1);
    // inch = value1.toInt();
    print("total----$ft ---------$inch");

    setState(() {});
  }

  static int getDecimalPlaces(double number) {
    int? decimals = 0;
    List<String> substr = number.toString().split('.');

    print("numbewr===$number===${substr.length}");
    if (substr.length > 1) {
      decimals = int.tryParse(substr[1][0]);
    }
    ;
    return decimals ?? 0;
  }

  Widget heightWidget() {
    double height = ConstantWidget.getWidthPercentSize(context, 40);
    double cellHeight = ConstantWidget.getWidthPercentSize(context, 12);
    double subHeight = ConstantWidget.getWidthPercentSize(context, 32);

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: EdgeInsets.all(margin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeaderView(S.of(context).howTallAreYou,
                  S.of(context).toGiveYouABetterExperienceNweNeedToKnowHeight),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 3),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: (height * 1.3),
                    width: height,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getScreenPercentSize(context, 1)),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getScreenPercentSize(context, 2.5)),
                    child: Stack(
                      children: [
                        Container(
                          width: (subHeight * 1.2),
                          height: subHeight,
                          margin: EdgeInsets.only(top: cellHeight / 2),
                          padding: EdgeInsets.only(
                              left: cellHeight / 2, bottom: cellHeight / 3),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ConstantWidget.getTextWidget(
                                  cm.toString(),
                                  Colors.black,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 25)),
                              ConstantWidget.getTextWidget(
                                  'Cm',
                                  accentColor,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ],
                          ),
                        ),
                        Container(
                          width: cellHeight,
                          height: cellHeight,
                          margin: EdgeInsets.only(left: (cellHeight / 2)),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(ConstantWidget.getPercentSize(
                                  cellHeight, 30)),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              Constants.assetsImagePath + "height.png",
                              height:
                                  ConstantWidget.getPercentSize(cellHeight, 40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: (height * 1.3),
                    width: height,
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ConstantWidget.getScreenPercentSize(context, 1)),
                    padding: EdgeInsets.symmetric(
                        vertical:
                            ConstantWidget.getScreenPercentSize(context, 2.5)),
                    child: Stack(
                      children: [
                        Container(
                          width: (subHeight * 1.2),
                          height: subHeight,
                          margin: EdgeInsets.only(top: cellHeight / 2),
                          padding: EdgeInsets.only(
                              left: cellHeight / 2, bottom: cellHeight / 3),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                  ConstantWidget.getPercentSize(subHeight, 15)),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ConstantWidget.getTextWidget(
                                  ft.toString(),
                                  Colors.black,
                                  TextAlign.start,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 18)),
                              ConstantWidget.getTextWidget(
                                  'Ft',
                                  accentColor,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 12)),

                              SizedBox(
                                width:
                                    ConstantWidget.getPercentSize(subHeight, 5),
                              ),
                              ConstantWidget.getTextWidget(
                                  inch.toString(),
                                  Colors.black,
                                  TextAlign.start,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 18)),
                              // ),
                              ConstantWidget.getTextWidget(
                                  'inches',
                                  accentColor,
                                  TextAlign.end,
                                  FontWeight.w300,
                                  ConstantWidget.getPercentSize(subHeight, 12)),
                            ],
                          ),
                        ),
                        Container(
                          width: cellHeight,
                          height: cellHeight,
                          margin: EdgeInsets.only(left: (cellHeight / 3)),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(ConstantWidget.getPercentSize(
                                  cellHeight, 30)),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              Constants.assetsImagePath + "ft.png",
                              height:
                                  ConstantWidget.getPercentSize(cellHeight, 40),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: ConstantWidget.getWidthPercentSize(context, 70),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: NumberPicker(
                      value: cm,
                      minValue: 80,
                      maxValue: 350,
                      textStyle: TextStyle(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 2),
                          color: Colors.black,
                          fontFamily: Constants.fontsFamily),
                      selectedTextStyle: TextStyle(
                          fontSize:
                              ConstantWidget.getScreenPercentSize(context, 3),
                          color: redColor,
                          fontFamily: Constants.fontsFamily),
                      step: 1,
                      haptics: true,
                      onChanged: (value) => setState(() {
                        cm = value;
                        setLbsValue();
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getAge() {
    SizeConfig().init(context);
    Widget space = SizedBox(
      height: margin,
    );
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: margin * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space,
            getHeaderView("How old are you?", ""),
            space,
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical:
                        ConstantWidget.getScreenPercentSize(context, 2.5)),
                child: Align(
                  alignment: Alignment.center,
                  child: NumberPicker(
                    value: age,
                    minValue: 15,
                    maxValue: 90,
                    textStyle: TextStyle(
                        fontSize:
                            ConstantWidget.getScreenPercentSize(context, 2),
                        color: Colors.black,
                        fontFamily: Constants.fontsFamily),
                    selectedTextStyle: TextStyle(
                        fontSize:
                            ConstantWidget.getScreenPercentSize(context, 3),
                        color: redColor,
                        fontFamily: Constants.fontsFamily),
                    step: 1,
                    haptics: true,
                    onChanged: (value) => setState(() {
                      age = value;
                      setLbsValue();
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getIntensively() {
    SizeConfig().init(context);
    Widget space = SizedBox(
      height: margin,
    );
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: margin * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space,
            getHeaderView(
                "What is your fitness level?",
                // getHeaderView("How intensively you workout?",
                ""),
            space,
            Expanded(
              child: ListView.builder(
                itemCount: intensivelyList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  bool isSelect = (index == selectIntensively);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectIntensively = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: margin),
                      padding: EdgeInsets.symmetric(
                          horizontal: (margin * 2), vertical: margin),
                      decoration: BoxDecoration(
                          color: isSelect ? accentColor : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(
                              ConstantWidget.getScreenPercentSize(
                                  context, 1.5))),
                          border: Border.all(
                              color:
                                  isSelect ? Colors.transparent : accentColor,
                              width: 1.5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          space,
                          ConstantWidget.getTextWidget(
                              intensivelyList[index].title!,
                              isSelect ? Colors.white : accentColor,
                              TextAlign.start,
                              FontWeight.bold,
                              ConstantWidget.getScreenPercentSize(
                                  context, 1.8)),
                          space,
                          ConstantWidget.getTextWidget(
                              intensivelyList[index].desc!,
                              isSelect ? Colors.white : Colors.grey,
                              TextAlign.start,
                              FontWeight.w500,
                              ConstantWidget.getScreenPercentSize(
                                  context, 1.5)),
                          space,
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getAreas() {
    SizeConfig().init(context);
    Widget space = SizedBox(
      height: margin,
    );
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: double.infinity,
        width: double.infinity,
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/area.png',
            ),
            fit: BoxFit.fitWidth,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: margin * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space,
            getHeaderView("Which areas do you want to focus on?", ""),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledCheckbox(
                      label: 'Complete Body\nContouring',
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      value: selectedAreas[0],
                      onChanged: (bool newValue) {
                        setState(() {
                          selectedAreas[0] = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LabeledCheckbox(
                      label: 'Toned Arms',
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      value: selectedAreas[1],
                      onChanged: (bool newValue) {
                        setState(() {
                          selectedAreas[1] = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LabeledCheckbox(
                      label: 'Trim Torso',
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      value: selectedAreas[2],
                      onChanged: (bool newValue) {
                        setState(() {
                          selectedAreas[2] = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LabeledCheckbox(
                      label: 'Shapely Butt',
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      value: selectedAreas[3],
                      onChanged: (bool newValue) {
                        setState(() {
                          selectedAreas[3] = newValue;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LabeledCheckbox(
                      label: 'Toned Legs',
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      value: selectedAreas[4],
                      onChanged: (bool newValue) {
                        setState(() {
                          selectedAreas[4] = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getHeaderView(String s, String subTitle) {
    Widget space = SizedBox(
      height: margin,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        space,
        getTitleWidget(s),
        space,
        getSubTitleWidget(subTitle),
      ],
    );
  }

  getTitleWidget(String s) {
    return ConstantWidget.getTextWidget(s, Colors.black, TextAlign.start,
        FontWeight.bold, ConstantWidget.getScreenPercentSize(context, 2.5));
  }

  getSubTitleWidget(String s) {
    return ConstantWidget.getTextWidget(s, Colors.grey, TextAlign.start,
        FontWeight.w300, ConstantWidget.getScreenPercentSize(context, 1.8));
  }
}
