import 'dart:collection';




class ModelExerciseDetail {
  int? id;
  String? name;
  String? detail;
  String? image;
  String? kcal;
  String? video;

  ModelExerciseDetail();

  ModelExerciseDetail.fromMap(dynamic objects) {
    kcal = objects['kcal'];
    video = objects['video'];
    image = objects['image'];
    detail = objects['detail'];
    name = objects['name'];
    id = objects['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['kcal'] = kcal;
    map['video'] = video;
    map['image'] = image;
    map['detail'] = detail;
    map['name'] = name;
    map['id'] = id;
    return map;
  }
}
