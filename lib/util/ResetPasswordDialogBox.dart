import 'package:flutter/material.dart';
import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../Constants.dart';


class ResetPasswordDialogBox extends StatefulWidget {
  final Function? func;

  const ResetPasswordDialogBox({Key? key, this.func}) : super(key: key);

  @override
  _ResetPasswordDialogBoxState createState() => _ResetPasswordDialogBoxState();
}

class _ResetPasswordDialogBoxState extends State<ResetPasswordDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: bgDarkWhite,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double padding = ConstantWidget.getScreenPercentSize(context,2);
    double avatarRadius = ConstantWidget.getScreenPercentSize(context,3);
    return Stack(
      children: <Widget>[
        Container(
          padding:
              EdgeInsets.only(left: padding, right: padding, bottom: padding),
          margin: EdgeInsets.only(top: avatarRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                Constants.assetsImagePath + "lock.png",
                height: ConstantWidget.getScreenPercentSize(context, 12),
                // color: primaryColor,
              ),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 5),
              ),
              ConstantWidget.getCustomTextWithFontFamilyWidget('Password Changed', textColor, ConstantWidget.getScreenPercentSize(context, 3),
                  FontWeight.w500, TextAlign.center, 1),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 1.7),
              ),
              ConstantWidget.getCustomTextWidget('Your password has been successfully changed!',
                  textColor, ConstantWidget.getScreenPercentSize(context, 2), FontWeight.w400, TextAlign.center, 2),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 5),
              ),

                // ConstantWidget.getButtonWidget1(context, "Ok",accentColor, (){
                //   Navigator.of(context).pop();
                //   widget.func!();
                // }),


              ConstantWidget.getButtonWidget(
                  context, 'Ok', blueButton, () {
                Navigator.of(context).pop();
                widget.func!();
              }),

              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 1.5),
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 15, right: 15),
              //   width: double.infinity,
              //   child: getRoundCornerButtonWithoutIcon(
              //       'Ok', primaryColor, Colors.white, 20, () {
              //     Navigator.of(context).pop();
              //     widget.func!();
              //   }),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
