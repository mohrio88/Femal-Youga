import 'package:flutter/material.dart';

Color bgDarkWhite="#FFFFFF".toColor();
Color primaryColor=const Color(0xFFF6F6F6);
Color accentColor="#000000".toColor();
Color greyWhite=const Color(0xFFEBEAEF);
Color darkGrey=const Color(0xFFEBEAEF);
Color greenButton=const Color(0xFF37BD4D);
Color blueButton=const Color(0xFF0078FF);
Color quickSvgColor=const Color(0xFF283182);
Color bmiBgColor="#2C698D".toColor();
Color bmiDarkBgColor=const Color(0xFF134B6D);
Color lightPink=const Color(0xFFFBE8EA);
Color itemBgColor=const Color(0xFFF2F1F4);
Color textColor=Colors.black;
Color redColor=Colors.red;
Color borderColor=Colors.grey.shade200;
Color subTextColor="#74707A".toColor();
Color cellColor="#F9F9F9".toColor();
Color bgColor="#F4F4F4".toColor();
Color category1="#FFF8D1".toColor();
Color category2="#FFDFDF".toColor();
Color category3="#D5F6E4".toColor();
Color category4="#E8E5FF".toColor();
Color category5="#F6D5EF".toColor();
Color category6="#FFECDB".toColor();
Color category7="#D6F4FF".toColor();
Color containerShadow = "#33ACB6B5".toColor();


getCellColor(int index){
  if(index % 7 == 0){
    return category1;
  }else if(index % 7 == 1){
    return category2;
  }else if(index % 7 == 2){
    return category3;
  }else if(index % 7 == 3){
    return category4;
  }else if(index % 7 == 4){
    return category5;
  }else if(index % 7 == 5){
    return category6;
  }else if(index % 7 == 6){
    return category7;
  }else {
    return category1;
  }
}




extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}