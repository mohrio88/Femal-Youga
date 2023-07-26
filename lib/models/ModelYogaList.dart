import 'dart:collection';




class ModelYogaList {
  int? id;
  int? levelType;
  String? name;
  String? image;

  ModelYogaList();

  ModelYogaList.fromMap(dynamic dynamicObj) {
    name = dynamicObj['name'];
    levelType = dynamicObj['level_type'];
    image = dynamicObj['image'];
    id = dynamicObj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['level_type'] = levelType;
    return map;
  }
}
