import 'dart:collection';

class ModelExerciseList {
  int? id;
  int? mainCatId;
  int? exerciseId;
  String? duration;

  ModelExerciseList.fromMap(dynamic objects) {
    id = objects['id'];
    mainCatId = objects['main_cat_id'];
    exerciseId = objects['exercise_id'];
    duration = objects['duration'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['duration'] = duration;
    map['exercise_id'] = exerciseId;
    map['main_cat_id'] = mainCatId;
    map['id'] = id;
    return map;
  }
}
