import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ConstantWidget.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'PrefData.dart';
import 'onlineData/ConstantUrl.dart';
import 'online_models/UserDetail.dart';

class HealthInfo extends StatefulWidget {
  @override
  _HealthInfo createState() => _HealthInfo();
}

class _HealthInfo extends State<HealthInfo> {
  //String selectedGender = "Female";
  String age = "25";
  double weight = 50;
  double height = 100;
  var myController = TextEditingController();
  var myControllerIn = TextEditingController();

  var selectedDate = Constants.addDateFormat
      .format(DateTime.now().subtract(Duration(days: 5)));

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  bool isKg = true;

  @override
  void initState() {
    getGender();
    myController.text = weight.toString();
    super.initState();
  }

  getGender() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();

    age = await PrefData().getAge();
    isKg = await PrefData().getIsKgUnit();

    weight = (isKg) ? getWeight : (Constants.kgToPound(getWeight));

    height = getHeight;

    //UserDetail userDetail = await ConstantUrl.getUserDetail();
    //age = userDetail.age??"25";
    // bool male = await PrefData().getIsMale();
    // if (male) {
    //   selectedGender = "Male";
    // } else {
    //   selectedGender = "Female";
    // }
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      height: 1,
      color: cellColor,
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 0.3)),
    );
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
            leading: new IconButton(
                icon: new Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  onBackClicked();
                }),
            title: getCustomText("Your Health Information", Colors.white, 1,
                TextAlign.start, FontWeight.w500, 20),
          ),
          body: SafeArea(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    ConstantWidget.getLoginAppBar(context,
                        title: "Your Health Information", function: () {
                      onBackClicked();
                    }),
                    SizedBox(
                      height: ConstantWidget.getScreenPercentSize(context, 2),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                ConstantWidget.getWidthPercentSize(context, 3)),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          // getMultiLineText(context, "Gender", selectedGender,
                          //     () {
                          //   showGenderSelectionDialog(context);
                          // }),
                          divider,
                          // getMultiLineText(
                          //     context, "Age", selectedDate, () async {
                          //   final DateTime? picked = await showDatePicker(
                          //     context: context,
                          //     initialDate: DateTime.now(), // Refer step 1
                          //     firstDate: DateTime(1900),
                          //     lastDate: DateTime.now(),
                          //   );
                          //   if (picked != null &&
                          //       Constants.addDateFormat.format(picked) !=
                          //           selectedDate)
                          //     setState(() {
                          //       selectedDate =
                          //           Constants.addDateFormat.format(picked);
                          //     });
                          // }),
                          getMultiLineText(context, "Age",
                              "${age}",
                                  () {
                                myController.text =age;
                                showAgeDialog(context);
                              }),
                          divider,
                          getMultiLineText(context, "Weight",
                              "${Constants.formatter.format(weight)} ${(isKg) ? "kg" : "lbs"}",
                              () {
                            myController.text =
                                Constants.formatter.format(weight);
                            showWeightKGDialog(true, context);
                          }),
                          divider,
                          getMultiLineText(
                              context,
                              "Height",
                              (isKg)
                                  ? "${Constants.formatter.format(height)} cm"
                                  : Constants.meterToInchAndFeetText(height),
                              () {
                            if (isKg) {
                              myController.text =
                                  Constants.formatter.format(height);
                            } else {
                              Constants.meterToInchAndFeet(
                                  height, myController, myControllerIn);
                            }
                            showHeightDialog(false, context);
                          }),
                          divider,
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
        onWillPop: () async {
          onBackClicked();
          return false;
        });
  }

  // void showGenderSelectionDialog(BuildContext contexts) async {
  //   List<String> ringTone = ['Female', 'Male'];
  //   int _currentIndex = ringTone.indexOf(selectedGender);
  //
  //   return showDialog(
  //     context: contexts,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: getMediumBoldTextWithMaxLine(
  //                 "Select Gender", Colors.black87, 1),
  //             content: Container(
  //               width: 300,
  //               height: 100,
  //               child: ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: ringTone.length,
  //                 itemBuilder: (context, index) {
  //                   return RadioListTile(
  //                     value: index,
  //                     groupValue: _currentIndex,
  //                     title: getSmallNormalTextWithMaxLine(
  //                         ringTone[index], Colors.black87, 1),
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _currentIndex = value as int;
  //                       });
  //                     },
  //                   );
  //                 },
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   selectedGender = ringTone[_currentIndex];
  //                   if (selectedGender == "Male") {
  //                     PrefData().setIsMale(true);
  //                   } else {
  //                     PrefData().setIsMale(false);
  //                   }
  //                   Navigator.pop(context, ringTone[_currentIndex]);
  //                 },
  //                 child: Text('OK'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   ).then((value) => {setState(() {})});
  // }
  void showAgeDialog( BuildContext context) async {
    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    double height = ConstantWidget.getDefaultButtonSize(context);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 27);

    Color color = borderColor;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 29,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Select Age',
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
                  height: height,
                  margin: EdgeInsets.symmetric(
                      vertical:
                      ConstantWidget.getScreenPercentSize(context, 1.2)),
                  alignment: Alignment.centerLeft,
                  decoration:
                  getDefaultDecoration(radius: radius, borderColor: color),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          maxLines: 1,

                          controller: myController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]')),
                          ],
                          // Only numbers
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: ConstantWidget.getWidthPercentSize(
                                      context, 4)),
                              border: OutlineInputBorder(),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '25',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: subTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: fontSize)),
                        ),
                      ),

                      SizedBox(
                        width: ConstantWidget.getWidthPercentSize(context, 4),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1)),
                Row(
                  children: [
                    Expanded(
                      child: ConstantWidget.getBorderButtonWidget(
                          context, "Cancel", () {
                        Navigator.pop(context);
                      }, borderColor: accentColor),
                      flex: 1,
                    ),
                    SizedBox(
                      width: ConstantWidget.getWidthPercentSize(context, 5),
                    ),
                    Expanded(
                      child: ConstantWidget.getButtonWidget(
                          context, "Submit", accentColor, () {
                        if (myController.text.isNotEmpty) {
                            age = myController.text;
                            PrefData().addAge(age);
                            Navigator.pop(context, age);

                        } else {
                          print("getWeight===$weight");
                          Navigator.pop(context, "");
                        }
                      }),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
              ],
            );
          }),
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showWeightKGDialog(bool isWeight, BuildContext context) async {
    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    double height = ConstantWidget.getDefaultButtonSize(context);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 27);

    Color color = borderColor;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 29,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Select Weight',
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
                  height: height,
                  margin: EdgeInsets.symmetric(
                      vertical:
                          ConstantWidget.getScreenPercentSize(context, 1.2)),
                  alignment: Alignment.centerLeft,
                  decoration:
                      getDefaultDecoration(radius: radius, borderColor: color),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          maxLines: 1,

                          controller: myController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]')),
                          ],
                          // Only numbers
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: ConstantWidget.getWidthPercentSize(
                                      context, 4)),
                              border: OutlineInputBorder(),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '0.0',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: subTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: fontSize)),
                        ),
                      ),
                      getCustomText(
                          (isKg) ? "KG" : "LBS",
                          subTextColor,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantWidget.getScreenPercentSize(context, 2)),
                      SizedBox(
                        width: ConstantWidget.getWidthPercentSize(context, 4),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1)),
                Row(
                  children: [
                    Expanded(
                      child: ConstantWidget.getBorderButtonWidget(
                          context, "Cancel", () {
                        Navigator.pop(context);
                      }, borderColor: accentColor),
                      flex: 1,
                    ),
                    SizedBox(
                      width: ConstantWidget.getWidthPercentSize(context, 5),
                    ),
                    Expanded(
                      child: ConstantWidget.getButtonWidget(
                          context, "Submit", accentColor, () {
                        if (myController.text.isNotEmpty) {
                          if (isWeight) {
                            weight = double.parse(myController.text);
                            if (isKg) {
                              PrefData().addWeight(weight);
                            } else {
                              PrefData().addWeight(Constants.poundToKg(weight));
                            }
                            Navigator.pop(context, weight);
                          } else {
                            if (isKg) {
                              height = double.parse(myController.text);
                              PrefData().addHeight(height);
                            } else {
                              double feet = double.parse(myController.text);
                              double inch = double.parse(myControllerIn.text);

                              double cm = Constants.feetAndInchToCm(feet, inch);
                              height = cm;

                              PrefData().addHeight(cm);
                            }

                            Navigator.pop(context, height);
                          }
                        } else {
                          print("getWeight===$weight");
                          Navigator.pop(context, "");
                        }
                      }),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
              ],
            );
          }),
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showHeightDialog(bool isWeight, BuildContext context) async {
    double margin = ConstantWidget.getWidthPercentSize(context, 4);

    double height = ConstantWidget.getDefaultButtonSize(context);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 27);

    Color color = borderColor;

    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 29,
          decoration: getDecorationWithSide(
              radius: ConstantWidget.getScreenPercentSize(context, 4.5),
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 4)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Select Height',
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: height,
                        margin: EdgeInsets.symmetric(
                            vertical: ConstantWidget.getScreenPercentSize(
                                context, 1.2)),
                        alignment: Alignment.centerLeft,
                        decoration: getDefaultDecoration(
                            radius: radius, borderColor: color),
                        child: TextFormField(
                          maxLines: 1,

                          controller: myController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.,]')),
                          ],
                          // Only numbers
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontFamily: Constants.fontsFamily,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: ConstantWidget.getWidthPercentSize(
                                      context, 4)),
                              border: OutlineInputBorder(),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '0.0',
                              isDense: true,
                              hintStyle: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  color: subTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: fontSize)),
                        ),
                      ),
                    ),
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                ConstantWidget.getWidthPercentSize(context, 2)),
                        child: Text(
                          " , ",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.black,
                              decorationColor: accentColor,
                              fontFamily: Constants.fontsFamily),
                        ),
                      ),
                      visible: (!isKg && !isWeight) ? true : false,
                    ),
                    Visibility(
                      visible: (!isKg && !isWeight) ? true : false,
                      child: Expanded(
                        child: Container(
                          height: height,
                          margin: EdgeInsets.symmetric(
                              vertical: ConstantWidget.getScreenPercentSize(
                                  context, 1.2)),
                          alignment: Alignment.centerLeft,
                          decoration: getDefaultDecoration(
                              radius: radius, borderColor: color),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  maxLines: 1,

                                  controller: myControllerIn,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.,]')),
                                  ],
                                  // Only numbers
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                      fontFamily: Constants.fontsFamily,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: fontSize),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: ConstantWidget
                                              .getWidthPercentSize(context, 4)),
                                      border: OutlineInputBorder(),
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '0.0',
                                      isDense: true,
                                      hintStyle: TextStyle(
                                          fontFamily: Constants.fontsFamily,
                                          color: subTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: fontSize)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ),
                    SizedBox(
                      width: ConstantWidget.getWidthPercentSize(context, 4),
                    ),
                    getCustomText(
                        (isKg) ? "CM" : "FT/In",
                        subTextColor,
                        1,
                        TextAlign.start,
                        FontWeight.w500,
                        ConstantWidget.getScreenPercentSize(context, 2)),
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1)),
                Row(
                  children: [
                    Expanded(
                      child: ConstantWidget.getBorderButtonWidget(
                          context, "Cancel", () {
                        Navigator.pop(context);
                      }, borderColor: accentColor),
                      flex: 1,
                    ),
                    SizedBox(
                      width: ConstantWidget.getWidthPercentSize(context, 5),
                    ),
                    Expanded(
                      child: ConstantWidget.getButtonWidget(
                          context, "Submit", accentColor, () {
                        if (myController.text.isNotEmpty) {
                          if (isWeight) {
                            weight = double.parse(myController.text);
                            if (isKg) {
                              PrefData().addWeight(weight);
                            } else {
                              PrefData().addWeight(Constants.poundToKg(weight));
                            }
                            Navigator.pop(context, weight);
                          } else {
                            if (isKg) {
                              height = double.parse(myController.text);
                              PrefData().addHeight(height);
                            } else {
                              double feet = double.parse(myController.text);
                              double inch = double.parse(myControllerIn.text);

                              double cm = Constants.feetAndInchToCm(feet, inch);
                              height = cm;

                              PrefData().addHeight(cm);
                            }

                            Navigator.pop(context, height);
                          }
                        } else {
                          Navigator.pop(context, "");
                        }
                      }),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(
                    height: ConstantWidget.getScreenPercentSize(context, 1.5)),
              ],
            );
          }),
        );
      },
    ).then((value) => {
          setState(() {
            getGender();
          })
        });
  }
}
