import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../ConstantWidget.dart';
import '../Widgets.dart';
import '../models/model_edit_custom_plan_exercise.dart';
import '../models/model_get_custom_plan_exercise.dart';
import '../onlineData/ConstantUrl.dart';
import 'package:http/http.dart' as http;

class BottomDialog extends StatefulWidget {
  final Customplanexercise customplanexerciseList;

  BottomDialog(this.customplanexerciseList);

  @override
  State<BottomDialog> createState() => _BottomDialogState();
}

class _BottomDialogState extends State<BottomDialog> {
  TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    durationController.text = widget.customplanexerciseList.exerciseTime!;
    return Wrap(
      children: [
        Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(22.h))),
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidget.getVerSpace(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomText("Duration", Colors.black, 1, TextAlign.start,
                        FontWeight.w700, 22.sp),
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child:
                            getSvgImage("close.svg", width: 24.h, height: 24.h))
                  ],
                ),
                ConstantWidget.getVerSpace(20.h),
                getDurationTextField(context, "Duration", durationController,
                    isEnable: false,
                    height: 50.h,
                    withprefix: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number),
                ConstantWidget.getVerSpace(40.h),
                Row(
                  children: [
                    Expanded(
                        child: getButton(
                            context, Colors.white, "Cancel", Colors.black, () {
                      Get.back();
                    }, 14.sp,
                            weight: FontWeight.w600,
                            isBorder: true,
                            buttonHeight: 40.h,
                            borderColor: Colors.black,
                            borderWidth: 1.h,
                            borderRadius: BorderRadius.circular(12.h))),
                    getHorSpace(12.h),
                    Expanded(
                        child: getButton(
                            context, Colors.black, "Ok", Colors.white, () async {
                      Map data = await ConstantUrl.getCommonParams();
                      data[ConstantUrl.paramCustomPlanId] =
                          widget.customplanexerciseList.customPlanId;
                      data[ConstantUrl.paramCustomPlanExerciseId] =
                          widget.customplanexerciseList.customPlanExerciseId;
                      data[ConstantUrl.paramExerciseId] = widget
                          .customplanexerciseList.exercisedetail.exerciseId;
                      data[ConstantUrl.paramExerciseTime] =
                          durationController.text;

                      final response = await http.post(
                          Uri.parse(ConstantUrl.urlEditCustomPlanExercise),
                          body: data);

                      print("response---------------${response.body}");
                      var value = ModelEditCustomPlanExercise.fromJson(
                          jsonDecode(response.body));

                      if (value.data.success == 1) {
                        Get.back();
                      }
                    }, 14.sp,
                            weight: FontWeight.w600,
                            buttonHeight: 40.h,
                            borderRadius: BorderRadius.circular(12.h)))
                  ],
                ),
                ConstantWidget.getVerSpace(40.h),
              ],
            ),
          ),
        )
      ],
    );
  }
}
