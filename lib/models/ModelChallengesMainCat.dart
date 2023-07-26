import 'dart:collection';




class ModelChallengesMainCat {
  int? id;
  int? weeks;
  String? title;
  String? image;
  String? description;
  String? background;

  ModelChallengesMainCat();

  ModelChallengesMainCat.fromMap(dynamic dynamicObj) {
    description = dynamicObj['description'];
    image = dynamicObj['image'];
    title = dynamicObj['title'];
    weeks = dynamicObj['weeks'];
    background = dynamicObj['background'];
    id = dynamicObj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['background'] = background;
    map['description'] = description;
    map['image'] = image;
    map['title'] = title;
    map['weeks'] = weeks;
    map['id'] = id;
    return map;
  }
}
