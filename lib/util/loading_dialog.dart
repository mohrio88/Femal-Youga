import 'package:flutter/material.dart';
import '../ColorCategory.dart';
import '../ConstantWidget.dart';

import '../Constants.dart';

class LoadingDialog extends StatefulWidget {
  final Function? func;

  const LoadingDialog({Key? key, this.func}) : super(key: key);

  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return
      Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ConstantWidget.getScreenPercentSize(context, 1.5)),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child:
      contentBox(context)
    ,
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ConstantWidget.getScreenPercentSize(context, 3),
      horizontal: ConstantWidget.getWidthPercentSize(context, 5)),
      child: Row(
        children: [
          Image.asset(
            Constants.assetsImagePath + 'gif_3.gif',
            color: accentColor,
            height: ConstantWidget.getWidthPercentSize(context, 10),
            width: ConstantWidget.getWidthPercentSize(context, 10),
          ),
          SizedBox(
            width: ConstantWidget.getWidthPercentSize(context, 3),
          ),
          ConstantWidget.getTextWidget(
              'Please wait....',
              textColor,
              TextAlign.start,
              FontWeight.w600,
              ConstantWidget.getScreenPercentSize(context, 2.2))
        ],
      ),
    );
  }
}
