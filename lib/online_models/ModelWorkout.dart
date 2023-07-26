class ModelWorkout {
  Data? data;

  ModelWorkout({this.data});

  ModelWorkout.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? success;
  List<Category>? category;
  String? error;

  Data({this.success, this.category, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    return data;
  }
}

class Category {
  String? categoryId;
  String? category;
  String? image;
  String? description;
  String? isActive;

  Category(
      {this.categoryId,
      this.category,
      this.image,
      this.description,
      this.isActive});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'].toString();
    category = json['category'];
    image = json['image'];
    description = json['description'];
    isActive = json['is_active'].toString() ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category'] = category;
    data['image'] = image;
    data['description'] = description;
    data['is_active'] = isActive;
    return data;
  }
}
