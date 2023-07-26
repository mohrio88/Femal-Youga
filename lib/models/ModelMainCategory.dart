import 'dart:collection';




class ModelMainCategory {
  int? id;
  String? title;
  String? image;

  ModelMainCategory.fromMap(dynamic dynamicObj) {
    image = dynamicObj['image'];
    title = dynamicObj['title'];
    id = dynamicObj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    return map;
  }
}
