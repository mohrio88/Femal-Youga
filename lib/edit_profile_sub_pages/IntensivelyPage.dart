import 'dart:async';



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../SizeConfig.dart';

// ignore: unused_import
import '../generated/l10n.dart';
import '../onlineData/ConstantUrl.dart';
import '../online_models/IntensivelyModel.dart';

class IntensivelyPage extends StatefulWidget {

  final int index;
  final ValueChanged<int> valueChange;
  IntensivelyPage(this.index,this.valueChange);

  @override
  _IntensivelyPage createState() {
    return _IntensivelyPage();
  }
}

class _IntensivelyPage extends State<IntensivelyPage> {


  int selectIntensively = 0;

  double margin=0;


  List<IntensivelyModel> intensivelyList = ConstantUrl.getIntensivelyModel();



  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }




  @override
  void initState() {
    super.initState();

    setState(() {
      selectIntensively = widget.index;
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
                toolbarHeight: 0,
                title: Text(""),
                leading: GestureDetector(
                  child: Icon(
                    CupertinoIcons.left_chevron,
                    color: Colors.black,
                  ),
                  onTap: (){
                    _requestPop();
                  },
                ),
              ),
              body: Column(
                children: [
                  ConstantWidget.getLoginAppBar(context,function: (){_requestPop();}),

                  Expanded(child: getIntensively(),flex: 1,),
                ],
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











  Widget getIntensively() {
    SizeConfig().init(context);
    Widget space = SizedBox(
      height: margin,
    );
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: ConstantWidget.getWidthPercentSize(context, 3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              color: isSelect ? Colors.transparent : accentColor,
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
            ),

            ConstantWidget.getButtonWidget(
                context, "Done", accentColor, () {

                  widget.valueChange(selectIntensively);
                  Navigator.of(context).pop();

            })

          ],
        ),
      ),
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
