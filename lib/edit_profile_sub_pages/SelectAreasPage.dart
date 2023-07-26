import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ColorCategory.dart';
import '../ConstantWidget.dart';
import '../SizeConfig.dart';
import '../util/labeledCheckbox.dart';



class SelectAreasPage extends StatefulWidget {
  final List<bool> selectedAreas;
  final Function valueChange;
  SelectAreasPage(this.selectedAreas,this.valueChange);

  @override
  _SelectAreasPage createState() {
    return _SelectAreasPage();
  }
}

class _SelectAreasPage extends State<SelectAreasPage> {
  double margin=0;
  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }




  @override
  void initState() {
    super.initState();
    if(widget.selectedAreas.length<5){
      for(int i=0; i<5 - widget.selectedAreas.length; i++){
        widget.selectedAreas.add(false);
      }
    }
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

                  Expanded(child: getAreaWidgets(),flex: 1,),
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


  Widget getAreaWidgets() {
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
                        value: widget.selectedAreas[0],
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.selectedAreas[0] = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      LabeledCheckbox(
                        label: 'Toned Arms',
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        value: widget.selectedAreas[1],
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.selectedAreas[1] = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      LabeledCheckbox(
                        label: 'Trim Torso',
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        value: widget.selectedAreas[2],
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.selectedAreas[2] = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      LabeledCheckbox(
                        label: 'Shapely Butt',
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        value: widget.selectedAreas[3],
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.selectedAreas[3] = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 10,),
                      LabeledCheckbox(
                        label: 'Toned Legs',
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        value: widget.selectedAreas[4],
                        onChanged: (bool newValue) {
                          setState(() {
                            widget.selectedAreas[4] = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ConstantWidget.getButtonWidget(
                  context, "Done", accentColor, () {

                widget.valueChange(widget.selectedAreas);
                Navigator.of(context).pop();

              })
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
