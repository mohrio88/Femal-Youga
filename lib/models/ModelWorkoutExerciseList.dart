import 'dart:collection';




class ModelWorkoutExerciseList {
  int? id;
  int? exerciseId;
  int? workoutId;
  String? duration;

  ModelWorkoutExerciseList();

  ModelWorkoutExerciseList.fromMap(dynamic objects) {
    id = objects['id'];
    exerciseId = objects['exercise_id'];
    workoutId = objects['workout_id'];
    duration = objects['duration'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['id'] = id;
    map['duration'] = duration;
    map['workout_id'] = workoutId;
    map['exercise_id'] = exerciseId;
    return map;
  }
}
