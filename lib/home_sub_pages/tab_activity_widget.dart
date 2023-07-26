import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';
import '../MyAssetsBar.dart';
import '../PrefData.dart';
import '../SizeConfig.dart';
import '../Widgets.dart';
import '../generated/l10n.dart';
import '../models/ModelHistory.dart';
import '../models/WorkoutHistoryModel.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/HomeWorkout.dart';

class TabActivity extends StatefulWidget {
  @override
  _TabActivity createState() => _TabActivity();
}

class _TabActivity extends State<TabActivity> {
  DateTime selectedDateTime = DateTime.now();

  int bmi = 0;

  double getTotalCal = 0;
  double getTodayTotalCal = 0;
  int getTodayTotalDuration = 0;
  int getTodayTotalWorkout = 0;
  double getCal = 0;
  int getTotalWorkout = 0;
  List<ModelHistory> priceList = [];

  int getTime = 0;

  var myController = TextEditingController();
  var myControllerWeight = TextEditingController();
  var myControllerIn = TextEditingController();

  List<ModelHistory> modelHistory = [];

  void _calcTotalCal() async {
    WorkoutHistoryModel? modelWorkout = await getAllWorkoutHistory(
        context, addDateFormat.format(selectedDateTime));
    List<CompletedHistoryworkout> workoutList = [];
    if (modelWorkout != null && modelWorkout.data!.success == 1) {
      workoutList = modelWorkout.data!.completedworkout!;
    }

    if (workoutList.length > 0) {
      workoutList.forEach((price) {
        setState(() {
          getTotalCal = (double.parse(price.kcal.toString())) + getTotalCal;
          getTodayTotalDuration = ((int.parse(price.workoutTime.toString())) +
              getTodayTotalDuration);
        });
      });
      getTodayTotalWorkout = workoutList.length;
    }
    setState(() {});
  }

  void _calcTotal() async {
    getHomeWorkoutData(context).then((value) {
      print("value---$value");

      if (value != null && value.data!.success == 1) {
        Homeworkout homeWorkout = value.data!.homeworkout!;
        double kcal = double.parse(homeWorkout.kcal!);

        setState(() {
          getCal = kcal;
        });
      } else {
        print("second---true");
      }
    });

    setState(() {});
  }

  int prefCal = 0;
  double weight = 50;
  double height = 100;
  bool isKg = true;

  getHeights() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();
    isKg = await PrefData().getIsKgUnit();
    weight = getWeight;
    height = getHeight;
    getBmiVal();
  }

  @override
  void initState() {
    getPrefCalData();
    _calcTotalCal();
    _calcTotal();
    super.initState();
    getHeights();
  }

  Future<void> getPrefCalData() async {
    prefCal = await PrefData().getDailyCalGoal();
    setState(() {});
  }

  Future<bool> _future = Future<bool>.delayed(
    Duration(seconds: 2),
        () {
      return true;
    },
  );

  void showWeightHeightDialog(BuildContext contexts) async {
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Enter Height and Weight", Colors.black87, 1),
              content: Container(
                width: 300.0,
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText("Height", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myController,
                          ),
                          flex: 1,
                        ),
                        Visibility(
                          child: Text(
                            " , ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                          ),
                          visible: (!isKg) ? true : false,
                        ),
                        Visibility(
                          child: Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  )),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: accentColor,
                                  fontFamily: Constants.fontsFamily),
                              controller: myControllerIn,
                            ),
                            flex: 1,
                          ),
                          visible: (!isKg) ? true : false,
                        ),
                        getMediumNormalTextWithMaxLine((isKg) ? "CM" : "FT/In",
                            Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    getCustomText("Weight", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myControllerWeight,
                          ),
                          flex: 1,
                        ),
                        getMediumNormalTextWithMaxLine((isKg) ? "KG" : "LBS",
                            Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                new TextButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new TextButton(
                  // color: lightPink,
                    style: TextButton.styleFrom(backgroundColor: lightPink),
                    child: Text(
                      'CHECK',
                      style: TextStyle(
                          color: accentColor,
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        if (isKg) {
                          height = double.parse(myController.text);
                        } else {
                          double inch = 0;
                          if (myControllerIn.text.isNotEmpty) {
                            inch = double.parse(myControllerIn.text);
                          }
                          double feet = double.parse(myController.text);
                          double cm = Constants.feetAndInchToCm(feet, inch);
                          height = cm;
                        }
                        PrefData().addHeight(height);
                      }

                      if (myControllerWeight.text.isNotEmpty) {
                        double weight1 = double.parse(myControllerWeight.text);
                        if (isKg) {
                          weight = weight1;
                          PrefData().addWeight(weight1);
                        } else {
                          weight = Constants.poundToKg(weight1);
                          PrefData().addWeight(weight);
                        }
                      }
                      Navigator.pop(context, weight);
                    }),
              ],
            );
          },
        );
      },
    ).then((value) {
      getBmiVal();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBmiVal() {
    double weightKg = weight;
    double heightCm = height;

    double meterHeight = heightCm / 100;
    double bmiGet = weightKg / (meterHeight * meterHeight);
    setState(() {
      bmi = bmiGet.toInt();
    });
  }

  double getProgressPercent(double val) {
    return val / 100;
  }

  @override
  Widget build(BuildContext context) {
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    SizeConfig().init(context);

    double radius = ConstantWidget.getScreenPercentSize(context, 2.5);

    return Container(
      color: bgDarkWhite,
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: textMargin),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidget.getTextWidget(
                    "Today",
                    textColor,
                    TextAlign.start,
                    FontWeight.bold,
                    ConstantWidget.getScreenPercentSize(context, 1.8)),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: (textMargin / 2)),
                  padding: EdgeInsets.symmetric(
                      horizontal: textMargin / 2, vertical: (textMargin / 4)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            ConstantWidget.getScreenPercentSize(context, 2)),
                      ),
                      color: category3),
                  child: ConstantWidget.getTextWidget(
                      Constants.showDateFormat.format(new DateTime.now()),
                      textColor,
                      TextAlign.start,
                      FontWeight.bold,
                      ConstantWidget.getScreenPercentSize(context, 1.4)),
                ),

                // getSmallBoldText("Stats |", Colors.black),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(textMargin),
            child: new CircularPercentIndicator(
              radius: ConstantWidget.getScreenPercentSize(context, 14),
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: ConstantWidget.getScreenPercentSize(context, 1.8),
              linearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  "#FE8E6B".toColor(),
                  "#FCAA73".toColor(),
                  "#FACC7E".toColor(),
                  "#F9E685".toColor(),
                  "#B4EE95".toColor(),
                ],
              ),
              percent: ((((getTotalCal * 100) / prefCal) / 100) > 1.0)
                  ? 1.0
                  : (((getTotalCal * 100) / prefCal) / 100),
              center: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ConstantWidget.getScreenPercentSize(context, 4),
                    width: ConstantWidget.getScreenPercentSize(context, 4),
                    decoration:
                    BoxDecoration(color: category6, shape: BoxShape.circle),
                    child: Center(
                      child: SvgPicture.asset(
                        Constants.assetsImagePath + "bonfire.svg",
                        height:
                        ConstantWidget.getScreenPercentSize(context, 2.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Constants.getScreenPercentSize(context, 1),
                  ),
                  getCustomText(
                      "${Constants.calFormatter.format(getTotalCal)}/$prefCal",
                      Colors.black,
                      1,
                      TextAlign.start,
                      FontWeight.bold,
                      Constants.getScreenPercentSize(context, 3)),
                  SizedBox(
                    height: Constants.getScreenPercentSize(context, 1),
                  ),
                  getCustomText(
                      "KCAL",
                      Colors.black,
                      1,
                      TextAlign.start,
                      FontWeight.bold,
                      Constants.getScreenPercentSize(context, 2)),
                ],
              ),
              backgroundColor: cellColor,
            ),
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 4),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: textMargin),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<bool>(
                    future: _future,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!
                            ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                              ConstantWidget.getScreenPercentSize(
                                  context, 2)),
                          decoration: getDefaultDecoration(
                              bgColor: bgColor,
                              radius: ConstantWidget.getScreenPercentSize(
                                  context, 1.5)),
                          child: Center(
                            child: ConstantWidget.getTextWidget(
                                "$getTodayTotalWorkout workouts",
                                textColor,
                                TextAlign.start,
                                FontWeight.w600,
                                ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                          ),
                        )
                            : Text("No data found");
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                            decoration: getDefaultDecoration(
                                bgColor: bgColor,
                                radius: ConstantWidget.getScreenPercentSize(
                                    context, 1.5)),
                            child: Center(
                              child: ConstantWidget.getTextWidget(
                                  "$getTodayTotalWorkout workouts",
                                  textColor,
                                  TextAlign.start,
                                  FontWeight.w600,
                                  ConstantWidget.getScreenPercentSize(
                                      context, 2)),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 4),
                ),
                Expanded(
                  child: FutureBuilder<bool>(
                    future: _future,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!
                            ? Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                              ConstantWidget.getScreenPercentSize(
                                  context, 2)),
                          decoration: getDefaultDecoration(
                              bgColor: bgColor,
                              radius: ConstantWidget.getScreenPercentSize(
                                  context, 1.5)),
                          child: Center(
                            child: ConstantWidget.getTextWidget(
                                "${Constants.getTimeFromSec(getTodayTotalDuration)} duration",
                                textColor,
                                TextAlign.start,
                                FontWeight.w600,
                                ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                          ),
                        )
                            : Text("No data found");
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                            decoration: getDefaultDecoration(
                                bgColor: bgColor,
                                radius: ConstantWidget.getScreenPercentSize(
                                    context, 1.5)),
                            child: Center(
                              child: ConstantWidget.getTextWidget(
                                  "${Constants.getTimeFromSec(getTodayTotalDuration)} duration",
                                  textColor,
                                  TextAlign.start,
                                  FontWeight.w600,
                                  ConstantWidget.getScreenPercentSize(
                                      context, 2)),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 2),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: textMargin),
            width: double.infinity,
            height: SizeConfig.safeBlockVertical! * 32,
            decoration:
            getDefaultDecoration(radius: radius, bgColor: accentColor),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Image.asset(
                        Constants.assetsImagePath + "path.png",
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            child: getSmallBoldText(
                              "BMI",
                              Colors.white,
                            ),
                            padding: EdgeInsets.all(
                                ConstantWidget.getScreenPercentSize(
                                    context, 2)),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: getCustomText(
                                (isKg)
                                    ? "$bmi kg/m²"
                                    : "${Constants.formatter.format(Constants.kgToPound(bmi.toDouble()))} lb/in²",
                                Colors.white,
                                1,
                                TextAlign.center,
                                FontWeight.bold,
                                22),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                (bmi < 18)
                                    ? "Underweight"
                                    : (bmi < 25)
                                    ? "Normal Weight"
                                    : (bmi < 30)
                                    ? "Overweight"
                                    : "Obesity",
                                style: TextStyle(
                                    color: Constants.getColorFromHex("FBC02D"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              )),
                          Expanded(
                            child: Center(
                              child: Container(
                                height: ConstantWidget.getScreenPercentSize(
                                    context, 4),
                                child: MyAssetsBar(
                                  width: SizeConfig.safeBlockHorizontal! * 90,
                                  background:
                                  Constants.getColorFromHex("CFD8DC"),
                                  height: ConstantWidget.getScreenPercentSize(
                                      context, 4),
                                  radius: 5,
                                  pointer: bmi,
                                  assetsLimit: 50,
                                  order: OrderType.None,
                                  assets: [
                                    MyAsset(
                                        size: 15,
                                        color:
                                        Constants.getColorFromHex("D0E2E2"),
                                        title: "0"),
                                    MyAsset(
                                        size: 3,
                                        color:
                                        Constants.getColorFromHex("9ADF9C"),
                                        title: "16"),
                                    MyAsset(
                                        size: 7,
                                        color:
                                        Constants.getColorFromHex("1EDC3E"),
                                        title: "18"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                        Constants.getColorFromHex("DCE683"),
                                        title: "25"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                        Constants.getColorFromHex("FF9A00"),
                                        title: "30"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                        Constants.getColorFromHex("E26F76"),
                                        title: "35"),
                                    MyAsset(
                                        size: 10,
                                        color:
                                        Constants.getColorFromHex("EF3737"),
                                        title: "40"),
                                  ],
                                ),
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 1.5),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                      ConstantWidget.getWidthPercentSize(context, 5)),
                  child: ConstantWidget.getBorderButtonWidget(
                      context, "Check Now", () {
                    if (isKg) {
                      myController.text = Constants.formatter.format(height);
                      myControllerWeight.text =
                          Constants.formatter.format(weight);
                    } else {
                      Constants.meterToInchAndFeet(
                          height, myController, myControllerIn);
                      myControllerWeight.text = Constants.formatter
                          .format(Constants.kgToPound(weight));
                    }
                    showWeightHeightDialog(context);
                  },
                      borderColor: cellColor,
                      btnHeight:
                      ConstantWidget.getScreenPercentSize(context, 5)),
                ),
                SizedBox(
                  height: ConstantWidget.getScreenPercentSize(context, 1.5),
                )
              ],
            ),
          ),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 3),
          ),
          ConstantWidget.getShadowWidget(
              margin: textMargin,
              widget: Container(
                child: TableCalendar(
                  availableGestures: AvailableGestures.none,
                  firstDay: new DateTime(2018, 1, 13),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: selectedDateTime,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDateTime, day);
                  },
                  eventLoader: (day) {
                    return [];
                  },
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    outsideDaysVisible: false,
                    selectedTextStyle: TextStyle(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                        color: accentColor, shape: BoxShape.circle),
                    canMarkersOverflow: false,
                    weekendTextStyle: TextStyle(
                        color: Colors.black, fontFamily: Constants.fontsFamily),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: Constants.fontsFamily,
                          fontSize:
                          ConstantWidget.getScreenPercentSize(context, 1.5),
                          fontWeight: FontWeight.w600),
                      weekdayStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: Constants.fontsFamily,
                          fontSize:
                          ConstantWidget.getScreenPercentSize(context, 1.5),
                          fontWeight: FontWeight.w600)),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                        color: textColor,
                        fontSize:
                        ConstantWidget.getScreenPercentSize(context, 2),
                        fontWeight: FontWeight.w600),
                    formatButtonTextStyle: TextStyle()
                        .copyWith(color: Colors.transparent, fontSize: 0),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onDaySelected: (day, events) {
                    selectedDateTime = day;
                    setState(() {});
                  },
                ),
              ),
              radius: radius),
          SizedBox(
            height: ConstantWidget.getScreenPercentSize(context, 2),
          ),
          FutureBuilder<WorkoutHistoryModel?>(
            future: getAllWorkoutHistory(
                context, addDateFormat.format(selectedDateTime)),
            builder: (context, snapshot) {
              print("getAllWorkoutHistory=${snapshot.data}");

              if (snapshot.hasData && snapshot.data != null) {
                WorkoutHistoryModel? modelWorkout = snapshot.data;

                if (modelWorkout!.data!.success == 1) {
                  List<CompletedHistoryworkout>? workoutList =
                      modelWorkout.data!.completedworkout;

                  return Column(
                    children: [
                      getCustomText(
                          addDateFormat.format(selectedDateTime),
                          textColor,
                          1,
                          TextAlign.center,
                          FontWeight.w700,
                          ConstantWidget.getScreenPercentSize(context, 2.2)),
                      SizedBox(
                        height: ConstantWidget.getScreenPercentSize(context, 2),
                      ),
                      Container(
                        child: ListView.builder(
                            itemCount: workoutList!.length,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              CompletedHistoryworkout _modelWorkoutList =
                              workoutList[index];

                              Color color = category1;

                              if (index % 4 == 0) {
                                color = category1;
                              } else if (index % 4 == 1) {
                                color = category2;
                              } else if (index % 4 == 2) {
                                color = category3;
                              } else if (index % 4 == 2) {
                                color = category4;
                              }
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: ConstantWidget.getScreenPercentSize(
                                        context, 2),
                                    left: textMargin,
                                    right: textMargin),
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                    ConstantWidget.getScreenPercentSize(
                                        context, 2),
                                    horizontal:
                                    ConstantWidget.getWidthPercentSize(
                                        context, 2)),
                                decoration: getDefaultDecoration(
                                    radius: ConstantWidget.getScreenPercentSize(
                                        context, 2),
                                    bgColor: color),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomText(
                                        getHistoryTitle(
                                            _modelWorkoutList.workoutType!),
                                        textColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w700,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 2.2)),
                                    SizedBox(
                                      height:
                                      ConstantWidget.getScreenPercentSize(
                                          context, 1),
                                    ),
                                    getCustomText(
                                        _modelWorkoutList.workoutDate!,
                                        subTextColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w400,
                                        ConstantWidget.getScreenPercentSize(
                                            context, 1.8)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        getSubItem("timer.png",
                                            "${_modelWorkoutList.kcal} ${S.of(context).kcal}"),
                                        getSubItem(
                                            "cal.png",
                                            Constants.getTimeFromSec(int.parse(
                                                _modelWorkoutList
                                                    .workoutTime!)))
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                } else {
                  return getNoData(context);
                }
              } else {
                return getNoData(context);
              }
            },
          ),
        ],
      ),
    );
  }

  getSubItem(String s, String s1) {
    return Container(
      margin: EdgeInsets.only(
          right: ConstantWidget.getWidthPercentSize(context, 2)),
      padding: EdgeInsets.symmetric(
          horizontal: ConstantWidget.getWidthPercentSize(context, 2),
          vertical: ConstantWidget.getScreenPercentSize(context, 1)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(
              ConstantWidget.getScreenPercentSize(context, 15)))),
      child: Row(
        children: [
          Image.asset(
            Constants.assetsImagePath + s,
            height: ConstantWidget.getScreenPercentSize(context, 2),
            width: ConstantWidget.getScreenPercentSize(context, 2),
            color: textColor,
          ),
          SizedBox(
            width: ConstantWidget.getWidthPercentSize(context, 1),
          ),
          getCustomText(s1, textColor, 1, TextAlign.center, FontWeight.w600,
              ConstantWidget.getScreenPercentSize(context, 1.6)),
        ],
      ),
    );
  }
}
