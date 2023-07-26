library country_state_city_picker_nona;

import 'dart:convert';



import 'package:country_state_city_picker/model/select_status_model.dart' as StatusModel ;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../ConstantWidget.dart';



class SelectState extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final TextStyle? style;
  final Color? dropdownColor;
  final String? selectedCity;
  final String? selectedCountry;
  final String? selectedState;

  final bool? isEdit;
  final bool? isMargin;

  const SelectState(
      {Key? key,
        required this.onCountryChanged,
        required this.onStateChanged,
        required this.onCityChanged,
        this.style,
        this.selectedState,
        this.selectedCountry,
        this.selectedCity,
        this.isMargin,
        this.isEdit,
        this.dropdownColor})
      : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> _cities = ["Choose City"];
  List<String> _country = ["Choose Country"];
  List<String> _countryList = ["Choose Country"];
  String _selectedCity = "Choose City";
  String _selectedCountry = "Choose Country";
  String _selectedState = "Choose State";
  List<String> _states = ["Choose State"];
  var responses;



  @override
  void initState() {

    getCounty().then((value) {
      // setState(() {
        // if(widget.selectedCountry!.isNotEmpty){
        //
        //
        //   // _country.contains(widget.selectedCountry);
        //   _selectedCountry = widget.selectedCountry!;
        // }

        // if(widget.selectedCity!.isNotEmpty){
        //   _selectedCity = widget.selectedCity!;
        // }

        // if(widget.selectedState!.isNotEmpty){
        //   _selectedState = widget.selectedState!;
        // }
        //
      if(widget.selectedCountry!=null) {
        _onSelectedCountry(_selectedCountry, widget.selectedCountry!, true);
        // _onSelectedState(widget.selectedState!);
        // _onSelectedCity(widget.selectedCity!);
      }

        print("print-----${_selectedCountry}-----${_selectedState}---${_selectedCity}-----${_country.length}");
      // });

    });
    //

    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    // countryres.forEach((data) {
    //   var model = StatusModel.StatusModel();
    //   model.name = data['name'];
    //   model.emoji = data['emoji'];
    //   if (!mounted) return;
    //   setState(() {
    //     _country.add(model.emoji! + "    " + model.name!);
    //
    //   });
    // });
    //
    for(int i=0;i<countryres.length;i++){

      var data= countryres[i];
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        String addData=model.emoji! + "    " + model.name!;
        _country.add(addData);
        _countryList.add(model.name!);

        if(widget.selectedCountry!=null&&widget.selectedCountry!.isNotEmpty){

          print("addData---$addData --- ${model.name!} --- ${widget.selectedCountry}");

          if(model.name!.trim() == widget.selectedCountry!.trim()){
            _selectedCountry = addData;
          }
        }

      });
    }

    return _country;
  }

  Future getState(bool isDefault) async {

    print("_selectedCountry----$_selectedCountry");
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          print(statename.toString());
          _states.add(statename.toString());


          if(isDefault &&widget.selectedState!=null&& widget.selectedState!.isNotEmpty&& statename.toString() == widget.selectedState!){

            _selectedState = widget.selectedState!;
            getCity(true);
          }

          print("_states---12-${_states.length}");
        }
      });
    });

    _states.sort();
    return _states;
  }

  Future getCity(bool isDefault) async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());
            _cities.add(citynames.toString());

            if(isDefault &&widget.selectedCity!=null&&  widget.selectedCity!.isNotEmpty&& citynames.toString() == widget.selectedCity!){

              _selectedCity = widget.selectedCity!;
            }
          }
        });
      });
    });

    _cities.sort();
    return _cities;
  }

  void _onSelectedCountry(String value,String name,bool isDefault) {

    print("log-----$value");
    if (!mounted) return;
    setState(() {
      _selectedCountry = value;
      if(!isDefault){


        _selectedState = "Choose State";
        _states = ["Choose State"];


        this.widget.onCountryChanged(name);
      }
      getState(isDefault);

    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "Choose City";
      _cities = ["Choose City"];
      _selectedState = value;
      this.widget.onStateChanged(value);
      getCity(false);
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getShadowWidget(DropdownButton<String>(
          dropdownColor: widget.dropdownColor,
          isExpanded: true,


          underline: SizedBox(),

          items: _country.map((String dropDownStringItem) {

            print("dropDownValue---$dropDownStringItem");
          // items: ['Assesse', 'brown', 'silver'].map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Row(
                children: [
                  Expanded(child: Text(
                    dropDownStringItem,
                    style: widget.style,
                  ))
                ],
              ),
            );
          }).toList(),
          // onChanged: null,
          onChanged: (value) {

            int i = _country.indexOf(value!);

            print("countryName ---- ${_countryList[i]}");

            _onSelectedCountry(value,_countryList[i],false);
          },
          value: _selectedCountry,
        )),
        getShadowWidget(DropdownButton<String>(
          dropdownColor: widget.dropdownColor,
          isExpanded: true, underline: SizedBox(),
          items: _states.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem, style: widget.style),
            );
          }).toList(),
          onChanged: (value) => _onSelectedState(value!),
          value: _selectedState,
        )),
        getShadowWidget(DropdownButton<String>(
          dropdownColor: widget.dropdownColor,
          isExpanded: true,
          underline: SizedBox(),
          items: _cities.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem, style: widget.style),
            );
          }).toList(),
          onChanged: (value) => _onSelectedCity(value!),
          value: _selectedCity,
        )),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
  
  getShadowWidget(Widget child){
      double height = ConstantWidget.getScreenPercentSize(context,7);
      double radius = ConstantWidget.getPercentSize(height, 20);

      double padding= ConstantWidget.getScreenPercentSize(context, 1.2);

    return ConstantWidget.getShadowWidget(widget: IgnorePointer(ignoring: widget.isEdit!,
                    child: child),radius:radius,margin:(widget.isMargin==null)? padding:0,verticalMargin: padding
   ,rightPadding:  padding,leftPadding:  padding);
  //

  //
  //   return Container(
  //       height: height,
  //       alignment: Alignment.centerLeft,

  //       margin: EdgeInsets.symmetric(
  //           vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
  //       padding: EdgeInsets.symmetric(horizontal: ConstantWidget.getScreenPercentSize(context, 1.2)),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(radius),
  //         ),
  //         boxShadow: [
  //           getShadow()
  //         ],
  //       ),
  //       child: IgnorePointer(ignoring: widget.isEdit!,
  //           child: child));
  }
}
