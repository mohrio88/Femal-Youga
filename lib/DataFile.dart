import 'package:flutter/cupertino.dart';
import '../ColorCategory.dart';
import 'IntroModel.dart';

class DataFile {
  static List<IntroModel> getIntroModel(BuildContext context) {
    List<IntroModel> introList = [];

    IntroModel mainModel = new IntroModel();
    mainModel.id = 1;
    mainModel.name = "Yoga Like Never\nBefore";
    mainModel.image = "intro_1.png";
    mainModel.svg = "shape_1.svg";
    mainModel.color = "#EBFFFB".toColor();
    mainModel.desc =
        "The term \"yoga\" in the western world often denotes a modern form of Hatha Yoga.";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 2;
    mainModel.name = "Best Medicine For\nYour Body";
    mainModel.image = "intro_3.png";
    mainModel.svg = "shape_2.svg";
    mainModel.color = "#F3FFE3".toColor();


    mainModel.desc =
        "The ascetic traditions of the ganges plain are thought to drew from a common body.";
    introList.add(mainModel);

    mainModel = new IntroModel();
    mainModel.id = 3;
    mainModel.svg = "shape_3.svg";
    mainModel.name = "Mediation For Living\nHealthy Life";
    mainModel.image = "intro_2.png";
    mainModel.color = "#FFF1ED".toColor();
    mainModel.desc = "The ascetic traditions of the ganges plain are thought to drew from a common body.";
    introList.add(mainModel);

    return introList;
  }


}
