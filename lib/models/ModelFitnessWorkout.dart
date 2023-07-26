import 'dart:collection';




class ModelFitnessWorkout {
  int? id;
  String? name;
  String? color;
  String? image;
  String? descriptionTxt;

  ModelFitnessWorkout();

  ModelFitnessWorkout.fromMap(dynamic dynamicObj) {
    color = dynamicObj['color'];
    image = dynamicObj['image'];
    name = dynamicObj['name'];
    id = dynamicObj['id'];
    descriptionTxt = dynamicObj['description_txt'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['image'] = image;
    map['color'] = color;
    map['name'] = name;
    map['id'] = id;
    map['description_txt'] = descriptionTxt;

    return map;
  }
}
