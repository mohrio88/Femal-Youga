import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_yoga_workout_4_all_new/Subscription/SubscriptionWidget_backup.dart';
import 'package:flutter_yoga_workout_4_all_new/main.dart';
import 'package:get/get.dart';
import '../Constants.dart';

import 'ColorCategory.dart';
import 'HomeWidget.dart';
import 'Subscription/SubscriptionWidget.dart';
import 'ads/ads_file.dart';
import 'onlineData/ServiceProvider.dart';
import 'online_models/model_check_purchase_plan_day.dart';

getNoData(BuildContext context) {
  return Container(
      // color: mainBgColor,
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 5)),
      child: Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
              color: Colors.black87,
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.bold),
        ),
      ));
}

getDefaultNextButton(BuildContext context,
    {Function? function, IconData? icon}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return GestureDetector(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        child: Icon(
          (icon != null) ? icon : Icons.close,
          color: Colors.black,
          size: ConstantWidget.getPercentSize(subHeight, 70),
        ),
      ),
    ),
  );
}

getDefaultButton(BuildContext context, {Function? function}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return GestureDetector(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        child: Icon(
          Icons.close,
          color: Colors.black,
          size: ConstantWidget.getPercentSize(subHeight, 70),
        ),
      ),
    ),
  );
}

getDefaultBackButton(BuildContext context, {Function? function}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 45);
  return GestureDetector(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    // child: SvgPicture.asset(
    //   Constants.assetsImagePath + 'Arrow _Left.svg',
    //   height: subHeight,
    //   color: Colors.white,
    // ),
  );
}

getDefaultButtonWithAsset(BuildContext context,
    {Function? function, String? icon}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return GestureDetector(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        child: Image.asset(
          (icon != null)
              ? Constants.assetsImagePath + icon
              : Constants.assetsImagePath + 'Icons.close',
          color: Colors.black,
          height: ConstantWidget.getPercentSize(subHeight, 60),
          width: ConstantWidget.getPercentSize(subHeight, 60),
        ),
      ),
    ),
  );
}

Widget getAssetImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return Image.asset(
    Constants.assetsImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    matchTextDirection: true,
  );
}

Widget getHorSpace(double verSpace) {
  return SizedBox(
    width: verSpace,
  );
}

BoxDecoration getButtonDecoration(Color bgColor,
    {BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow> shadow = const [],
    DecorationImage? image}) {
  return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: shadow,
      image: image);
}

Widget getButton(BuildContext context, Color bgColor, String text,
    Color textColor, Function function, double fontsize,
    {bool isBorder = false,
    EdgeInsetsGeometry? insetsGeometry,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.bold,
    bool isIcon = false,
    String? image,
    Color? imageColor,
    double? imageWidth,
    double? imageHeight,
    bool smallFont = false,
    bool? isProcess = null,
    double? buttonHeight,
    double? buttonWidth,
    List<BoxShadow> boxShadow = const [],
    EdgeInsetsGeometry? insetsGeometrypadding,
    BorderRadius? borderRadius,
    double? borderWidth}) {
  print("process==$isProcess");
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      padding: insetsGeometrypadding,
      width: buttonWidth,
      height: buttonHeight,
      decoration: getButtonDecoration(
        bgColor,
        borderRadius: borderRadius,
        shadow: boxShadow,
        border: (isBorder)
            ? Border.all(color: borderColor, width: borderWidth!)
            : null,
      ),
      child: isProcess == null
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (isIcon) ? getSvgImage(image!) : getHorSpace(0),
                (isIcon) ? getHorSpace(15.h) : getHorSpace(0),
                ConstantWidget.getCustomText(
                    text, textColor, 1, TextAlign.center, weight, fontsize)
              ],
            )
          : Center(
              child: CupertinoActivityIndicator(
              color: Colors.white,
            )),
    ),
  );
}

initializeScreenSize(BuildContext context,
    {double width = 414, double height = 896}) {
  ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
}

getHomeProWidget(
    {required BuildContext context,
    double? horSpace,
    double? verSpace,
    double? size}) {
  return FutureBuilder<bool>(
    future: ConstantWidget.isPlanValid(),
    builder: (context, snapshot) {
      if (snapshot.data != null && !snapshot.data!) {
        return Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            "${Constants.assetsImagePath}crown.png",
            height: size ?? 20.h,
          ),
        ).marginSymmetric(
            horizontal: horSpace ?? 10.w, vertical: verSpace ?? 25.h);
      } else {
        return const SizedBox(
          height: 0,
          width: 0,
        );
      }
    },
  );
}

Widget getMultilineCustomFont(String text, double fontSize, Color fontColor,
    {String? fontFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight = 1.0}) {
  return Text(
    text,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: Constants.fontsFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

Widget getMultilineCustomFont1(String text, double fontSize, Color fontColor,
    {String? fontFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight = 1.0}) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.underline,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: Constants.fontsFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

Widget getSvgImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constants.assetsImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    matchTextDirection: true,
  );
}

Widget getDurationTextField(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool withprefix = false,
    bool withSufix = false,
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool isPass = false,
    bool isEnable = true,
    double? height,
    double? imageHeight,
    double? imageWidth,
    String? image,
    String? suffiximage,
    Function? imagefunction,
    AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
    List<TextInputFormatter>? inputFormatters,
    bool defFocus = false,
    FocusNode? focus1,
    TextInputType? keyboardType}) {
  FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;
  Color color = borderColor;

  return StatefulBuilder(
    builder: (context, setState) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              myFocusNode.canRequestFocus = true;
              color = accentColor;
            });
          } else {
            setState(() {
              myFocusNode.canRequestFocus = false;
              color = borderColor;
            });
          }
        },
        focusNode: myFocusNode,
        child: Container(
          height: height,
          margin: margin,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: color, width: 1.h),
              borderRadius: BorderRadius.circular(12.h)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (!withprefix)
                  ? getHorSpace(12.h)
                  : Padding(
                      padding: EdgeInsets.only(right: 12.h, left: 20.h),
                      child: getSvgImage(image!, height: 24.h, width: 24.h),
                    ),
              Expanded(
                flex: 1,
                child: TextField(
                  keyboardType: keyboardType,
                  enabled: true,
                  inputFormatters: inputFormatters,
                  maxLines: (minLines) ? null : 1,
                  controller: textEditingController,
                  obscuringCharacter: "*",
                  autofocus: false,
                  obscureText: isPass,
                  showCursor: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      fontFamily: Constants.fontsFamily),
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: s,
                      hintStyle: TextStyle(
                          color: "#525252".toColor(),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          fontFamily: Constants.fontsFamily)),
                ),
              ),
              (!withSufix)
                  ? getHorSpace(12.h)
                  : Padding(
                      padding: EdgeInsets.only(right: 20.h, left: 12.h),
                      child: GestureDetector(
                        onTap: () {
                          if (imagefunction != null) {
                            imagefunction();
                          }
                        },
                        child: getSvgImage(suffiximage!,
                            height: 24.h, width: 24.h),
                      ),
                    ),
            ],
          ),
        ),
      );
    },
  );
}

Widget getDefaultTextFiledWithLabel(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool withprefix = false,
    bool withSufix = false,
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool isPass = false,
    bool isEnable = true,
    double? height,
    double? imageHeight,
    double? imageWidth,
    String? image,
    String? suffiximage,
    Function? imagefunction,
    AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
    List<TextInputFormatter>? inputFormatters,
    bool defFocus = false,
    FocusNode? focus1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    double maxWidth = 60,
    ValueChanged<String>? onChanged}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: keyboardType,
    onChanged: onChanged,
    enabled: true,
    validator: validator,
    inputFormatters: inputFormatters,
    maxLines: (minLines) ? null : 1,
    controller: textEditingController,
    obscuringCharacter: "*",
    obscureText: isPass,
    showCursor: true,
    cursorColor: Colors.black,
    style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 15.sp,
        fontFamily: Constants.fontsFamily),
    decoration: InputDecoration(
        prefixIcon: (!withprefix)
            ? getHorSpace(12.h)
            : Padding(
                padding: EdgeInsets.only(right: 12.h, left: 20.h),
                child: getSvgImage(image!, height: 24.h, width: 24.h),
              ),
        prefixIconConstraints:
            BoxConstraints(maxHeight: 24.h, maxWidth: maxWidth.h),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.h),
          borderSide: BorderSide(color: borderColor, width: 1.h),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.h),
          borderSide: BorderSide(color: accentColor, width: 1.h),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.h),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22.h),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
        ),
        hintText: s,
        hintStyle: TextStyle(
            color: "#525252".toColor(),
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            fontFamily: Constants.fontsFamily)),
  );
}

class ConstantWidget {
  static Widget getVerSpace(double verSpace) {
    return SizedBox(
      height: verSpace,
    );
  }

  static Widget textFieldProfileWidget(
      BuildContext context,
      String s,
      var icon,
      bool isEnabled,
      TextEditingController textEditingController,
      Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
      verticalMargin: ConstantWidget.getScreenPercentSize(context, 1.2),
      widget: Container(
        height: height,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                controller: textEditingController,
                enabled: isEnabled,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: isEnabled ? accentColor : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        icon,
                        color: isEnabled ? accentColor : Colors.grey,
                      ),
                    ),
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              ),
            )
          ],
        ),
      ),
      radius: radius,
    );
  }

  static Widget editAddressWidget(BuildContext context, String s, var icon,
      bool isEnabled, TextEditingController textEditingController) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
        widget: Container(
          // height: height,

          alignment: Alignment.centerLeft,
          child: TextField(
            controller: textEditingController,
            enabled: isEnabled,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: isEnabled ? accentColor : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(
                    ConstantWidget.getWidthPercentSize(context, 2.5)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                hintStyle: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
          // ),
        ),
        radius: radius);
  }

  static Widget editProfileWidget(
      BuildContext context,
      String s,
      var icon,
      bool isEnabled,
      TextEditingController textEditingController,
      Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
      radius: radius,
      verticalMargin: ConstantWidget.getScreenPercentSize(context, 1.2),
      widget: GestureDetector(
        onTap: () {
          if (isEnabled) {
            function();
          }
        },
        child: Container(
          height: height,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: ConstantWidget.getWidthPercentSize(context, 2.5)),
          child: TextField(
            maxLines: 1,
            controller: textEditingController,
            enabled: false,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(
                //     left: ConstantWidget.getWidthPercentSize(context, 1.5)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                suffixIcon: getIcon(icon),
                hintStyle: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
        ),
      ),
    );
  }

  static getIcon(var icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(icon),
    );
  }

  static double getPercentSize(double total, double percent) {
    return (total * percent) / 100;
  }

  static Widget getAddressWidget(BuildContext context, String s,
      TextEditingController textEditingController, double margin) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 15);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
        widget: Container(
          padding: EdgeInsets.only(
              top: ConstantWidget.getScreenPercentSize(context, 1)),
          child: TextField(
            maxLines: 5,
            controller: textEditingController,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                    left: ConstantWidget.getWidthPercentSize(context, 2)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                hintStyle: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
        ),
        radius: radius,
        horizontalMargin: margin);
  }

  static Widget getIntroBorderButtonWidget(
      BuildContext context, String s, Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
            horizontal: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.bold, fontSize, Colors.black)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getIntroButtonWidget(
      BuildContext context, String s, var color, Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
        ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
            boxShadow: [getShadow()]),
        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.bold, fontSize, Colors.white)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getCustomTextWidget(String string, Color color, double size,
      FontWeight fontWeight, TextAlign align, int maxLine) {
    return Text(string,
        textAlign: align,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            fontFamily: Constants.fontsFamily,
            color: color));
  }

  static OutlineInputBorder getOutlineBorder(var color, var width, var radius) {
    return new OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static Widget getHorizonSpace(double space) {
    return SizedBox(
      width: space,
    );
  }

  static Widget getCustomTextWithUnderLine(String text, TextAlign textAlign,
      Color color, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          decoration: TextDecoration.underline,
          color: color,
          fontSize: fontSize,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
    );
  }

  static Widget getCustomTextWithFontFamilyWidget(String string, Color color,
      double size, FontWeight fontWeight, TextAlign align, int maxLine) {
    return Text(string,
        textAlign: align,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            fontFamily: Constants.boldFontsFamily,
            color: color));
  }

  static Widget getButtonWithoutSpaceWidget(
      BuildContext context, String s, var color, Function function) {
    double height = getScreenPercentSize(context, 7);
    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 30);

    return GestureDetector(
      child: Material(
        color: Colors.transparent,
        shadowColor: primaryColor.withOpacity(0.3),
        elevation: getPercentSize(height, 45),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(getPercentSize(radius, 85)))),
        child: Container(
          height: height,
          margin: EdgeInsets.only(
            bottom: getScreenPercentSize(context, 1.5),
          ),
          decoration: ShapeDecoration(
            color: color,
            shape: SmoothRectangleBorder(
              side: BorderSide(color: subTextColor, width: 0.3),
              borderRadius: SmoothBorderRadius(
                cornerRadius: radius,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Center(
              child: getDefaultTextWidget(s, TextAlign.center, FontWeight.w500,
                  fontSize, Colors.white)),
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getLoginAppBar(BuildContext context,
      {Function? function,
      String? title,
      bool? isInfo,
      Function? infoFunction}) {
    double height = getScreenPercentSize(context, 7);
    return Container(
      height: height,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: getWidthPercentSize(context, 3)),
      child: Stack(
        children: [
          Center(
            child: ConstantWidget.getTextWidget(
                (title == null) ? '' : title,
                textColor,
                TextAlign.center,
                FontWeight.bold,
                ConstantWidget.getPercentSize(height, 30)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: getDefaultBackButton(context, function: function),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: isInfo == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        if (infoFunction != null) {
                          infoFunction();
                        }
                      },
                      child: Icon(Icons.info,
                          color: textColor,
                          size: ConstantWidget.getScreenPercentSize(
                              context, 3)))),
        ],
      ),
    );
  }

  static Widget getDefaultTextFiledWidgetAutoFocus(BuildContext context,
      String s, TextEditingController textEditingController,
      {bool? isEnabled,
      FocusNode? focus1,
      Function? onChange,
      bool? autoFocus}) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);

    Color color = borderColor;

    FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;

    if (autoFocus != null) {
      myFocusNode.canRequestFocus = true;
      color = accentColor;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                myFocusNode.canRequestFocus = true;
                color = accentColor;
              });
            } else {
              setState(() {
                myFocusNode.canRequestFocus = false;
                color = borderColor;
              });
            }

            print("refresh===true====${myFocusNode.canRequestFocus}");
          },
          focusNode: myFocusNode,
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(
                vertical: getScreenPercentSize(context, 1.2)),
            alignment: Alignment.centerLeft,
            decoration:
                getDefaultDecoration(radius: radius, borderColor: color),
            child: Focus(
              onFocusChange: (hasFocus) {},
              child: TextFormField(
                // focusNode: myFocusNode,
                maxLines: 1,
                onChanged: (va) {
                  if (onChange != null) {
                    onChange(va);
                  }
                },

                autofocus: autoFocus == null ? false : true,
                enabled: (isEnabled != null) ? isEnabled : true,
                controller: textEditingController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                    border: OutlineInputBorder(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    isDense: true,
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: subTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget getDefaultTextFiledWidget(
    BuildContext context,
    String s,
    TextEditingController textEditingController, {
    bool? isEnabled,
    FocusNode? focus1,
    Function? onChange,
  }) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);

    FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                myFocusNode.canRequestFocus = true;
              });
            } else {
              setState(() {
                myFocusNode.canRequestFocus = false;
              });
            }

            print("refresh===true====${myFocusNode.canRequestFocus}");
          },
          focusNode: myFocusNode,
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(
                vertical: getScreenPercentSize(context, 1.2)),
            alignment: Alignment.centerLeft,
            decoration:
                getDefaultDecoration(radius: radius, borderColor: borderColor),
            child: Focus(
              onFocusChange: (hasFocus) {},
              child: TextFormField(
                // focusNode: myFocusNode,
                maxLines: 1,
                onChanged: (va) {
                  if (onChange != null) {
                    onChange(va);
                  }
                },
                enabled: (isEnabled != null) ? isEnabled : true,
                controller: textEditingController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                    border: OutlineInputBorder(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    isDense: true,
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: subTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget getDefaultTextFiledWidgetWithBigPadding(
    BuildContext context,
    String s,
    TextEditingController textEditingController, {
    bool? isEnabled,
    FocusNode? focus1,
    Function? onChange,
  }) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);

    FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                myFocusNode.canRequestFocus = true;
              });
            } else {
              setState(() {
                myFocusNode.canRequestFocus = false;
              });
            }

            print("refresh===true====${myFocusNode.canRequestFocus}");
          },
          focusNode: myFocusNode,
          child: Container(
            height: height,
            margin: EdgeInsets.symmetric(
                vertical: getScreenPercentSize(context, 1.2),
                horizontal: ConstantWidget.getWidthPercentSize(context, 3.7)),
            alignment: Alignment.centerLeft,
            decoration:
                getDefaultDecoration(radius: radius, borderColor: borderColor),
            child: Focus(
              onFocusChange: (hasFocus) {},
              child: TextFormField(
                // focusNode: myFocusNode,
                maxLines: 1,
                onChanged: (va) {
                  if (onChange != null) {
                    onChange(va);
                  }
                },
                enabled: (isEnabled != null) ? isEnabled : true,
                controller: textEditingController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                    border: OutlineInputBorder(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    isDense: true,
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: subTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget getRoundCornerButtonWithoutIcon(String texts, Color color,
      Color textColor, double btnRadius, Function function) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(btnRadius),
              shape: BoxShape.rectangle,
              color: color,
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Center(
              child: getCustomText(
                  texts, textColor, 1, TextAlign.center, FontWeight.w500, 18),
            ),
          )
        ],
      ),
      onTap: () {
        function();
      },
    );
  }

  static getDefaultButtonSize(BuildContext context) {
    return getScreenPercentSize(context, 6.5);
  }

  static Widget getPasswordTextFiled(BuildContext context, String s,
      TextEditingController textEditingController,
      {FocusNode? focus1, bool? isHorizontal}) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);
    bool isShowPass = false;

    FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                myFocusNode.canRequestFocus = true;
              });
            } else {
              setState(() {
                myFocusNode.canRequestFocus = false;
              });
            }
          },
          focusNode: myFocusNode,
          child: Container(
              height: height,
              margin: EdgeInsets.symmetric(
                vertical: getScreenPercentSize(context, 1.2),
                horizontal:
                    isHorizontal == null ? 0 : getScreenPercentSize(context, 2),
              ),
              alignment: Alignment.centerLeft,
              decoration: getDefaultDecoration(
                  radius: radius, borderColor: borderColor),
              child: TextFormField(
                obscureText: !isShowPass,
                enableSuggestions: isShowPass,
                autocorrect: isShowPass,
                // focusNode: myFocusNode,
                maxLines: 1,
                controller: textEditingController,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,

                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                    border: OutlineInputBorder(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isShowPass = !isShowPass;
                        });
                      },
                      child: Icon(
                        isShowPass ? Icons.visibility_off : Icons.visibility,
                        color: subTextColor,
                        size: getPercentSize(height, 40),
                      ),
                    ),
                    isDense: true,
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: subTextColor,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              )),
        );
      },
    );
  }

  static Widget getButtonWidget(
      BuildContext context, String s, var color, Function function) {
    double height = ConstantWidget.getDefaultButtonSize(context);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        // decoration: BoxDecoration(
        //   color: color,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(radius),
        //   ),
        // ),

        decoration: getDefaultDecoration(radius: radius, bgColor: accentColor),

        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.bold, fontSize, Colors.white)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getBorderButtonWidget(
      BuildContext context, String s, Function function,
      {Color? borderColor, double? btnHeight}) {
    double height = btnHeight == null
        ? ConstantWidget.getDefaultButtonSize(context)
        : btnHeight;
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: getDefaultDecoration(
            radius: radius,
            borderColor: borderColor == null ? accentColor : borderColor),
        child: Center(
            child: getDefaultTextWidget(s, TextAlign.center, FontWeight.bold,
                fontSize, borderColor == null ? accentColor : borderColor)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getIconButtonWidget(
      BuildContext context, String s, Function function,
      {Color? borderColor,
      Color? fillColor,
      double? btnHeight,
      Color? fontColor,
      String? asset,
      bool? isHorizontal}) {
    double height = btnHeight == null
        ? ConstantWidget.getDefaultButtonSize(context)
        : btnHeight;
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
            horizontal: isHorizontal == null
                ? 0
                : ConstantWidget.getScreenPercentSize(context, 2.5)),
        decoration: getDefaultDecoration(
            radius: radius,
            bgColor: fillColor ?? borderColor,
            borderColor: borderColor == null ? accentColor : borderColor),
        child: Stack(
          children: [
            asset != null && asset.length > 0
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 20),
                    child: Image.asset(
                      asset ?? "",
                      width: 20,
                      height: 20,
                    ))
                : SizedBox(),
            Center(
                child: getDefaultTextWidget(
                    s,
                    TextAlign.center,
                    FontWeight.bold,
                    fontSize,
                    fontColor == null ? accentColor : fontColor)),
          ],
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getBorderWithBlackBackgroundButtonWidget(
      BuildContext context, String s, Function function,
      {Color? borderColor,
      Color? fillColor,
      double? btnHeight,
      Color? fontColor}) {
    double height = btnHeight == null
        ? ConstantWidget.getDefaultButtonSize(context)
        : btnHeight;
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return GestureDetector(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: getDefaultDecoration(
            radius: 0,
            bgColor: fillColor ?? borderColor,
            borderColor: borderColor == null ? accentColor : borderColor),
        child: Center(
            child: getDefaultTextWidget(s, TextAlign.center, FontWeight.bold,
                fontSize, fontColor == null ? accentColor : fontColor)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static double largeTextSize = 28;

  static double getMarginTop(BuildContext context) {
    // double height = getScreenPercentSize(context, 20);
    double height = getScreenPercentSize(context, 23);

    return (height / 2) + getScreenPercentSize(context, 2.5);
  }

  static double getBlankTop(BuildContext context) {
    double height = getScreenPercentSize(context, 20);

    return getPercentSize(height, 85);
  }

  static double getScreenPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height * percent) / 100;
  }

  static double getWidthPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width * percent) / 100;
  }

  static Widget getShadowWidget(
      {required Widget widget,
      double? margin,
      double? verticalMargin,
      double? horizontalMargin,
      double? radius,
      double? topPadding,
      double? leftPadding,
      double? rightPadding,
      double? bottomPadding,
      Color? color,
      bool? isShadow}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: (margin == null) ? 0 : margin),
      margin: EdgeInsets.symmetric(
          vertical: (verticalMargin == null) ? 0 : verticalMargin,
          horizontal: (horizontalMargin == null) ? 0 : horizontalMargin),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: isShadow == null
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Container(
          decoration: getDefaultDecoration(
              bgColor: (color == null) ? Colors.white : color,
              radius: (radius == null) ? 0 : radius),
          padding: EdgeInsets.only(
            top: (topPadding == null) ? 0 : topPadding,
            bottom: (bottomPadding == null) ? 0 : bottomPadding,
            right: (rightPadding == null) ? 0 : rightPadding,
            left: (leftPadding == null) ? 0 : leftPadding,
          ),
          child: widget,
        ),
      ),
    );
  }

  static Widget getCustomText(String text, Color color, int maxLine,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getCustomTextFontWithSpace(
      String text,
      Color color,
      int maxLine,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          height: 1.3,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getTextWidget(String text, Color color, TextAlign textAlign,
      FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getTextWidgetWithFont(
      String text,
      Color color,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          letterSpacing: 1,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getTextWidgetWithFontWithMaxLine(
      String text,
      Color color,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font,
      int maxLine) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          letterSpacing: 1,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getDefaultTextWidget(String s, TextAlign textAlign,
      FontWeight fontWeight, double fontSize, var color) {
    return Text(
      s,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color),
    );
  }

  static Future<bool> isPlanValid() async {
    Checkpurchaseplanday? _checkPurchasePlanDay = await checkPurchasePlanDay();

    print("_checkPurchasePlanDay===${_checkPurchasePlanDay}");
    if (_checkPurchasePlanDay == null) {
      return false;
    }

    if (_checkPurchasePlanDay != null) {
      int getVal = _checkPurchasePlanDay.expireDay ?? 0;

      String isActive = _checkPurchasePlanDay.isActive ?? "0";

      print("getval===${getVal}===${isActive}");
      // if ( isActive == "1") {
      if (getVal > 0 && isActive == "1") {
        return true;
      }
    }
    return false;
  }

  static void restorePurchases() {
    print("restore ===true");
    // iapConnection.restorePurchases();
  }
}

getDefaultDecoration({double? radius, Color? bgColor, Color? borderColor}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderColor == null) ? 0 : 1),
      borderRadius: SmoothBorderRadius(
        cornerRadius: (radius == null) ? 0 : radius,
        cornerSmoothing: 0.8,
      ),
    ),
  );
}

getDecorationWithSide(
    {double? radius,
    Color? bgColor,
    Color? borderColor,
    bool? isTopRight,
    bool? isTopLeft,
    bool? isBottomRight,
    bool? isBottomLeft}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderColor == null) ? 0 : 1),
      borderRadius: SmoothBorderRadius.only(
        bottomRight: SmoothRadius(
          cornerRadius: (isBottomRight == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        bottomLeft: SmoothRadius(
          cornerRadius: (isBottomLeft == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        topLeft: SmoothRadius(
          cornerRadius: (isTopLeft == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        topRight: SmoothRadius(
          cornerRadius: (isTopRight == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
      ),
    ),
  );
}

getColorStatusBar(Color? color) {
  return AppBar(
    backgroundColor: color,
    toolbarHeight: 0,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: color, statusBarColor: color),
  );
}

setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color));
}

sendHomePage(BuildContext buildContext, int index, {bool? isPushReplace}) {
  setStatusBarColor(bgDarkWhite);

  if (isPushReplace == null) {
    Navigator.push(
        buildContext,
        MaterialPageRoute(
          builder: (context) => HomeWidget(),
        ));
    // Get.to(HomeWidget());
  } else {
    Navigator.pushReplacement(
        buildContext,
        MaterialPageRoute(
          builder: (context) => HomeWidget(),
        ));
    // Get.to(HomeWidget());
  }
}

Widget getPaddingWidget(EdgeInsets edgeInsets, Widget widget) {
  return Padding(
    padding: edgeInsets,
    child: widget,
  );
}

getProWidget(
    {required String isActive,
    required BuildContext context,
    double? horSpace,
    double? verSpace,
    Alignment? alignment}) {
  print("proactive===" + isActive);
  return (isActive == "1")
      ? FutureBuilder<bool>(
          future: ConstantWidget.isPlanValid(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data != null && !snapshot.data!) {
              if (1 == 0) {
                //if(isPro.value==true){
                return Container();
              } else {
                return Align(
                        alignment:
                            alignment == null ? Alignment.topRight : alignment,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: containerShadow,
                                  blurRadius: 32,
                                  offset: Offset(-2, 5)),
                            ],
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                Constants.assetsImagePath + "crown_1.png",
                                height: 18,
                              ),
                              getHorSpace(8),
                              ConstantWidget.getCustomText("Pro", textColor, 1,
                                  TextAlign.start, FontWeight.w500, 14),
                            ],
                          ),
                        ))
                    .marginSymmetric(
                        horizontal: horSpace == null ? 10 : horSpace,
                        vertical: verSpace == null ? 15 : verSpace);
              }
              ;
            } else {
              return Container(
                height: 0,
                width: 0,
              );
            }
          },
        )
      : Container(
          height: 0,
          width: 0,
        );
}

getBodyWorkoutProWidget(
    {required String isActive,
    required BuildContext context,
    double? horSpace,
    double? verSpace,
    double? quickWorkoutHeight,
    Color? color,
    Alignment? alignment}) {
  print("proactive===" + isActive);
  return (isActive == "1")
      ? FutureBuilder<bool>(
          future: ConstantWidget.isPlanValid(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data != null && !snapshot.data!) {
              if (1 == 0) {
                //if(isPro.value==true){
                return Container();
              } else {
                return Container(
                    margin: EdgeInsets.only(
                        top: ConstantWidget.getPercentSize(
                            quickWorkoutHeight ?? 10, 3.5),
                        right: ConstantWidget.getPercentSize(
                            quickWorkoutHeight ?? 10, 11)),
                    decoration: BoxDecoration(
                        border: Border.all(color: color!),
                        color: color,
                        borderRadius: BorderRadius.circular(
                            ConstantWidget.getPercentSize(
                                quickWorkoutHeight ?? 10, 10))),
                    child: Image.asset(
                      Constants.assetsImagePath + "crown_1.png",
                      height: 18.h,
                    ));
              }
              ;
            } else {
              return Container(
                height: 0,
                width: 0,
              );
            }
          },
        )
      : Container(
          height: 0,
          width: 0,
        );
}

checkIsProPlan(
    {required BuildContext context,
    required String isActive,
    required Function function,
    required setState,
    required AdsFile adsFile}) async {
  if (isActive == "1") {
    checkInApp(
        context: context,
        function: () {
          function();
        },
        adsFile: adsFile);
  } else {
    // setState((){});
    Future.delayed(Duration(seconds: 1), () {
      function();
    });
  }
}

checkInApp(
    {required BuildContext context,
    required Function function,
    required AdsFile adsFile}) async {
  bool isPurchase = await ConstantWidget.isPlanValid();

  print("isPurchase===$isPurchase");

  if (isPurchase) {
    function();
  } else {
    setStatusBarColor(accentColor);
    // Get.to(InAppPurchase())!.then((value) {
    //   if (value != null && value) {
    //     function();
    //   }
    // });
    Get.to(SubscriptionWidget())!.then((value) {
      if (value != null && value) {
        function();
      }
    });
    // Get.to(SubscriptionBackupWidget())!.then((value) {
    //   if (value != null && value) {
    //     function();
    //   }
    // });
  }
}

showInAppDialog(BuildContext context, Function function) {
  showDialog(
    context: context,
    builder: (context) {
      return WillPopScope(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            decoration: getDecorationWithSide(
                radius: 22.h,
                bgColor: bgDarkWhite,
                isTopLeft: true,
                isBottomLeft: true,
                isBottomRight: true,
                isTopRight: true),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstantWidget.getVerSpace(10.h),
                        getSvgImage("lock1.svg", height: 52.h, width: 52.h),
                        ConstantWidget.getVerSpace(20.h),
                        ConstantWidget.getCustomText(
                            "Watch Video to Unlock",
                            textColor,
                            1,
                            TextAlign.center,
                            FontWeight.w700,
                            22.sp),
                        ConstantWidget.getVerSpace(10.h),
                        getMultilineCustomFont(
                            "Watch the video to use training plan once",
                            17.sp,
                            textColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center),
                        ConstantWidget.getVerSpace(22.h),
                        GestureDetector(
                          onTap: () {
                            function();
                            Get.back();
                          },
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(10.h)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getSvgImage("video_play.svg",
                                    height: 24.h, width: 24.h),
                                getHorSpace(10.h),
                                ConstantWidget.getCustomText(
                                    "Unlock Once",
                                    Colors.white,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w600,
                                    18.sp)
                              ],
                            ),
                          ),
                        ),
                        ConstantWidget.getVerSpace(20.h),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            setStatusBarColor(accentColor);
                            // Get.to(InAppPurchase());
                          },
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                // color: "#4B4E55".toColor(),
                                border:
                                    Border.all(color: accentColor, width: 1),
                                borderRadius: BorderRadius.circular(10.h)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConstantWidget.getCustomText(
                                    "Free 7 Days Trial",
                                    Colors.black,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w600,
                                    18.sp)
                              ],
                            ),
                          ),
                        ),
                        ConstantWidget.getVerSpace(19.h),
                        getMultilineCustomFont(
                            "Free 7 days trial, then \$3500.00/year,Cancle anytime during the trial.",
                            15.sp,
                            "#7D7D7D".toColor(),
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                            txtHeight: 1.5),
                        ConstantWidget.getVerSpace(10.h),
                      ],
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: getSvgImage("close.svg",
                                height: 24.h, width: 24.h)))
                  ],
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      );
    },
  );
  // showGeneralDialog(
  //   context: context,
  //   barrierColor: Colors.transparent,
  //   barrierLabel: 'Label',
  //   barrierDismissible: true,
  //
  //   pageBuilder: (i, _, ___) => Container(
  //
  //     decoration: getDecorationWithSide(
  //         radius: 22.h,
  //         bgColor: bgDarkWhite,
  //         isTopLeft: true,
  //         isTopRight: true),
  //     child: Stack(
  //       children: [
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             getAssetImage("lock_purchase.png",
  //                 width: 24.h, height: 24.h, color: Colors.white),
  //             ConstantWidget.getVerSpace(15.h),
  //             getCustomText("WATCH VIDEO TO UNLOCK", Colors.white, 1,
  //                 TextAlign.center, FontWeight.w700, 20.sp),
  //             ConstantWidget.getVerSpace(15.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Watch the video to use training plan once",
  //                 17.sp,
  //                 Colors.white60,
  //                 fontWeight: FontWeight.w500,
  //                 textAlign: TextAlign.center),
  //             ConstantWidget.getVerSpace(15.h),
  //             GestureDetector(
  //               onTap: () {
  //                 function();
  //                 Get.back();
  //               },
  //               child: Container(
  //                 height: 60.h,
  //                 decoration: BoxDecoration(
  //                     color: accentColor,
  //                     borderRadius: BorderRadius.circular(12.h)),
  //                 alignment: Alignment.center,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     getSvgImage("video_play.svg", height: 20.h, width: 20.h),
  //                     ConstantWidget.getHorSpace(20.h),
  //                     getCustomText("UNLOCK ONCE", Colors.white, 1,
  //                         TextAlign.center, FontWeight.w600, 17.sp)
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ConstantWidget.getVerSpace(15.h),
  //             GestureDetector(
  //               onTap: () {
  //                 Get.back();
  //                 Get.to(InAppPurchase());
  //               },
  //               child: Container(
  //                 height: 60.h,
  //                 decoration: BoxDecoration(
  //                     color: "#4B4E55".toColor(),
  //                     borderRadius: BorderRadius.circular(12.h)),
  //                 alignment: Alignment.center,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     getCustomText("FREE 7 DAYS TRIAL", Colors.white, 1,
  //                         TextAlign.center, FontWeight.w600, 17.sp)
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ConstantWidget.getVerSpace(15.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Free 7 Days Trial,then \$3500.00/year.", 14.sp, Colors.white60,
  //                 fontWeight: FontWeight.w500, textAlign: TextAlign.center),
  //             ConstantWidget.getVerSpace(5.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Cancel anytime during the trial.", 14.sp, Colors.white60,
  //                 fontWeight: FontWeight.w500, textAlign: TextAlign.center),
  //           ],
  //         ).marginSymmetric(horizontal: 20.h),
  //         GestureDetector(
  //             onTap: () {
  //               Get.back();
  //             },
  //             child: getSvgImage("arrow_left.svg", color: Colors.white)
  //                 .marginOnly(top: 50.h, left: 20.h))
  //       ],
  //     ),
  //   ),
  // );
}

getShadow() {
  return BoxShadow(
    color: Colors.black12,
    blurRadius: 3.0,
    offset: Offset(0, 4),
  );
}
