import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/ColorCategory.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../ConstantWidget.dart';
import '../online_models/model_package_plan.dart';

class SubscriptionItemWidget extends StatefulWidget {
  ProductDetails? productDetails;
  PurchaseDetails? previousPurchase;
  Packageplan packageplan;
  bool isBestBuy;
  String currentSelectedSubscribeId;
  Map<String, PurchaseDetails> purchases;
  Function callBack;
  SubscriptionItemWidget(
      this.productDetails,
      this.previousPurchase,
      this.packageplan,
      this.currentSelectedSubscribeId,
      this.isBestBuy,
      this.purchases,
      this.callBack);

  @override
  State<SubscriptionItemWidget> createState() => _SubscriptionItemWidgetState();
}

class _SubscriptionItemWidgetState extends State<SubscriptionItemWidget> {
  bool isTrial = false;
  @override
  void initState() {
    super.initState();
    isTrial = widget.packageplan.planName!.toLowerCase().contains('free');
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          widget.isBestBuy == true
              ? Container(
                  alignment: Alignment.center,
                  width: size.width / 3 - 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "BEST BUY",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width / 3 - 50,
                  height: 30,
                ),
          GestureDetector(
            onTap: () {
              widget.callBack(widget.packageplan, widget.previousPurchase,
                  widget.productDetails, widget.purchases);
            },
            child: Container(
              width: size.width / 3 - 40,
              height: size.height * 0.17,
              decoration: BoxDecoration(
                color: widget.currentSelectedSubscribeId ==
                        widget.packageplan.planId
                    ? Colors.white
                    : greyWhite,
                border: Border.all(
                  width: 2,
                  color: widget.currentSelectedSubscribeId ==
                          widget.packageplan.planId
                      ? Colors.red
                      : greyWhite,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstantWidget.getCustomText(
                      "${widget.packageplan.planName}".replaceAll(" ", "\n"),
                      Colors.black,
                      2,
                      TextAlign.center,
                      FontWeight.bold,
                      22),
                  //ConstantWidget.getCustomText(
                  //  widget.packageplan.months == "1"? "MONTH" : "MONTHS",
                  //Colors.black,
                  //1,
                  //TextAlign.center,
                  //FontWeight.bold,
                  //15),
                  !isTrial
                      ? ConstantWidget.getCustomText(
                          "£${(double.parse(widget.packageplan.price!) / double.parse(widget.packageplan.days!)).toStringAsFixed(2)}/ day.",
                          Colors.black,
                          1,
                          TextAlign.center,
                          FontWeight.w500,
                          14)
                      : SizedBox(),
                  !isTrial ? Expanded(child: Container()) : SizedBox(),
                  !isTrial
                      ? ConstantWidget.getCustomText(
                          "£${widget.packageplan.price!}",
                          Colors.black,
                          1,
                          TextAlign.center,
                          FontWeight.bold,
                          14)
                      : SizedBox(),
                  !isTrial
                      ? ConstantWidget.getCustomText(
                          int.parse(widget.packageplan.days ?? "0") < 10
                              ? "billed weekly"
                              : int.parse(widget.packageplan.days ?? "20") <
                                          40 &&
                                      int.parse(
                                              widget.packageplan.days ?? "20") >
                                          10
                                  ? "billed monthly"
                                  : "billed yearly",
                          Colors.black,
                          1,
                          TextAlign.center,
                          FontWeight.w500,
                          12)
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
