import 'dart:collection';




class ModelChallengeExerciseList {
  int? id;
  int? challengeId;
  int? day;
  int? week;
  int? exerciseId;
  String? duration;

  ModelChallengeExerciseList();

  ModelChallengeExerciseList.fromMap(dynamic dynamicObj) {
    duration = dynamicObj['duration'];
    exerciseId = dynamicObj['exercise_id'];
    week = dynamicObj['week'];
    day = dynamicObj['day'];
    challengeId = dynamicObj['challenge_id'];
    id = dynamicObj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['duration'] = duration;
    map['exercise_id'] = exerciseId;
    map['week'] = week;
    map['day'] = day;
    map['challenge_id'] = challengeId;
    map['id'] = id;
    return map;
  }
}
