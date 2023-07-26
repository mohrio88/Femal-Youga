import 'dart:collection';

class ModelCompleteChallenge {
  int? id;
  int? week;
  int? day;
  int? challengeId;

  ModelCompleteChallenge();

  ModelCompleteChallenge.fromMap(dynamic dynamicObj) {
    id = dynamicObj['id'];
    week = dynamicObj['week'];
    day = dynamicObj['day'];
    challengeId = dynamicObj['challenge_id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['id'] = id;
    map['week'] = week;
    map['day'] = day;
    map['challenge_id'] = challengeId;
    return map;
  }
}
